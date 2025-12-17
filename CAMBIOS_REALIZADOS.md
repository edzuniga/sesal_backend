# 🔧 Cambios Realizados para Solucionar Problemas de Despliegue

## 📋 Problemas Identificados

1. ✅ **Usuario incorrecto en BD**: Se conectaba con `wsuario1` en lugar de `root`
2. ✅ **Configuración persistida sobrescribía .env**: Archivo `.bi-sesal/database-config.json` tenía prioridad
3. ✅ **Puerto MySQL faltante**: No se especificaba `MYSQL_PORT` en ecosystem.config.js
4. ✅ **Error CORS**: Configuración rígida que no permitía orígenes dinámicos
5. ✅ **Error Express 5**: `app.options("*", cors())` no es válido en Express 5

---

## 🔨 Soluciones Implementadas

### 1. Prioridad de Variables de Entorno en Producción

**Archivo**: `src/servicios/configuracion-bd.servicio.ts`

**Cambio**: Cuando `NODE_ENV=production`, se ignora completamente el archivo `.bi-sesal/database-config.json` y solo se usan variables de entorno.

```typescript
async cargarConfiguracionPersistida() {
  // 🔴 En producción, SIEMPRE usar variables de entorno
  if (entorno.ambiente === 'production') {
    console.log('🔒 Modo producción: usando solo variables de entorno');
    return;
  }
  // ... resto del código
}
```

**Resultado**: En producción, las variables de `ecosystem.config.js` siempre tienen prioridad.

---

### 2. Puerto MySQL Agregado

**Archivo**: `ecosystem.config.js`

**Cambio**: Se agregó `MYSQL_PORT: 3306` a las variables de entorno.

```javascript
env: {
  // ... otras variables
  MYSQL_PORT: 3306,  // ← AGREGADO
  // ...
}
```

**Resultado**: La conexión ahora usa el puerto correcto.

---

### 3. CORS Dinámico y Flexible

**Archivo**: `src/aplicacion.ts`

**Cambios**:

1. CORS ahora lee orígenes desde variable de entorno `CORS_ORIGINS`
2. En desarrollo, permite todos los orígenes
3. Se eliminó `app.options("*", cors())` que causaba error en Express 5

```typescript
const ORIGENES_PERMITIDOS = process.env.CORS_ORIGINS
  ? process.env.CORS_ORIGINS.split(",").map((o) => o.trim())
  : ["http://172.16.36.59"];

app.use(
  cors({
    origin: (origin, callback) => {
      if (!origin) return callback(null, true);
      if (ORIGENES_PERMITIDOS.includes(origin)) {
        return callback(null, true);
      }
      // En desarrollo, permitir todos los orígenes
      if (entorno.ambiente === "desarrollo") {
        return callback(null, true);
      }
      return callback(new Error("Origen no permitido por CORS"));
    },
    // ...
  })
);
```

**Resultado**:

- Fácil agregar múltiples orígenes: `CORS_ORIGINS: "http://ip1,http://ip2"`
- Sin errores de CORS en desarrollo
- Sin error de Express 5

---

### 4. Archivo .gitignore Actualizado

**Archivo**: `.gitignore`

**Cambio**: Se agregó `.bi-sesal/` para evitar subir configuración local al repositorio.

```gitignore
# Database configuration (persisted config should not be in git)
.bi-sesal/
```

**Resultado**: La configuración persistida no se sube a Git.

---

### 5. Scripts de Utilidad Creados

#### a) `scripts/cleanup_server.sh`

Elimina configuración persistida en el servidor.

```bash
./scripts/cleanup_server.sh
```

#### b) `scripts/test_health.sh`

Prueba todos los endpoints de health.

```bash
./scripts/test_health.sh
```

---

### 6. Documentación Mejorada

#### Archivos creados/actualizados:

1. **`DEPLOYMENT_CHECKLIST.md`**: Checklist completo de despliegue
2. **`env.example`**: Plantilla de variables de entorno
3. **`README.md`**: Actualizado con nuevas instrucciones
4. **`CAMBIOS_REALIZADOS.md`**: Este archivo

---

## 🎯 Comportamiento Actual

### En Desarrollo (`NODE_ENV=development`)

- ✅ Puede usar archivo `.bi-sesal/database-config.json` si existe
- ✅ Si no existe, usa variables de `.env`
- ✅ CORS permite todos los orígenes

### En Producción (`NODE_ENV=production`)

- ✅ **SIEMPRE** usa variables de `ecosystem.config.js`
- ✅ **IGNORA** archivo `.bi-sesal/database-config.json`
- ✅ CORS estricto (solo orígenes en `CORS_ORIGINS`)
- ✅ Pool optimizado (50 conexiones)

---

## 📝 Pasos para Desplegar

### En el servidor:

```bash
# 1. Limpiar configuración antigua
./scripts/cleanup_server.sh

# 2. Verificar que ecosystem.config.js tenga las variables correctas
cat ecosystem.config.js | grep MYSQL

# 3. Compilar
npm run build

# 4. Detener PM2 si está corriendo
pm2 delete bisesal-backend

# 5. Iniciar con PM2
pm2 start ecosystem.config.js

# 6. Guardar configuración
pm2 save

# 7. Verificar conexión
curl http://localhost:4000/api/health/db

# 8. Ver logs
pm2 logs bisesal-backend
```

---

## ✅ Verificación de Solución

### Antes (con errores):

```
❌ Access denied for user 'wsuario1'@'172.16.36.58'
❌ CORS errors en frontend
❌ PathError: Missing parameter name at index 1: *
```

### Después (funcionando):

```
✅ Conexión exitosa con usuario 'root'
✅ Sin errores de CORS
✅ Sin errores de Express 5
✅ Logs muestran: "🔒 Modo producción: usando solo variables de entorno"
```

---

## 🔍 Cómo Verificar que Funciona

1. **Verificar usuario de BD en logs**:

```bash
pm2 logs bisesal-backend | grep "DB CONFIG EN USO"
```

Debe mostrar: `user: 'root'`

2. **Probar conexión**:

```bash
curl http://localhost:4000/api/health/db
```

Debe responder: `{"connected":true,"message":"Conexión a base de datos exitosa"}`

3. **Verificar que no hay archivo persistido**:

```bash
ls -la .bi-sesal/
```

Debe mostrar: `No such file or directory` (en producción)

---

## 🆘 Si Aún Hay Problemas

1. **Verificar variables de entorno cargadas**:

```bash
pm2 env 0 | grep MYSQL
```

2. **Ver logs completos**:

```bash
pm2 logs bisesal-backend --lines 100
```

3. **Reiniciar completamente**:

```bash
pm2 delete bisesal-backend
rm -rf .bi-sesal/
pm2 start ecosystem.config.js
```

---

## 📞 Contacto

Si persisten los problemas, revisar:

- Que MySQL esté corriendo en `172.16.34.68:3306`
- Que el usuario `root` tenga permisos desde la IP del servidor backend
- Que el firewall permita conexiones al puerto 3306
- Logs de MySQL: `/var/log/mysql/error.log`

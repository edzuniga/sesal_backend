# 🚀 Solución Rápida - Problemas de Despliegue

## ❌ Problema Principal

Tu backend se conectaba con el usuario `wsuario1` en lugar de `root`, causando errores de autenticación.

## ✅ Causa Raíz

Un archivo oculto `.bi-sesal/database-config.json` sobrescribía las variables de entorno del `ecosystem.config.js`.

---

## 🔧 Solución Implementada

### 1️⃣ Cambio en Lógica de Configuración

**En producción, ahora SIEMPRE usa variables de entorno** (ignora archivos persistidos).

### 2️⃣ Puerto MySQL Agregado

Se agregó `MYSQL_PORT: 3306` al `ecosystem.config.js`.

### 3️⃣ CORS Mejorado

- Ahora configurable vía `CORS_ORIGINS`
- En desarrollo permite todos los orígenes
- Eliminado error de Express 5

### 4️⃣ Scripts de Utilidad

- `verify_config.sh` - Verifica configuración antes de desplegar
- `cleanup_server.sh` - Limpia configuración persistida
- `test_health.sh` - Prueba endpoints de salud

---

## 📝 Pasos para Aplicar en el Servidor

### Opción A: Despliegue Limpio (Recomendado)

```bash
# 1. Ir al directorio del proyecto
cd /var/www/bisesal-backend

# 2. Hacer pull de los cambios
git pull origin main

# 3. Instalar dependencias (si hay nuevas)
npm install

# 4. Verificar configuración
./scripts/verify_config.sh

# 5. Limpiar configuración antigua
./scripts/cleanup_server.sh

# 6. Compilar
npm run build

# 7. Reiniciar PM2
pm2 delete bisesal-backend
pm2 start ecosystem.config.js
pm2 save

# 8. Verificar que funciona
curl http://localhost:4000/api/health/db
```

### Opción B: Solución Rápida (Si no puedes hacer pull)

```bash
# 1. Solo eliminar configuración persistida
rm -rf .bi-sesal/

# 2. Reiniciar PM2
pm2 restart bisesal-backend

# 3. Verificar logs
pm2 logs bisesal-backend --lines 20
```

---

## ✅ Verificación de Éxito

### 1. Verificar usuario en logs

```bash
pm2 logs bisesal-backend | grep "DB CONFIG EN USO"
```

**Debe mostrar**:

```
user: root  ← ✅ Correcto
```

**NO debe mostrar**:

```
user: wsuario1  ← ❌ Incorrecto
```

### 2. Probar conexión

```bash
curl http://localhost:4000/api/health/db
```

**Respuesta esperada**:

```json
{ "connected": true, "message": "Conexión a base de datos exitosa" }
```

### 3. Verificar que no hay archivo persistido

```bash
ls -la .bi-sesal/
```

**Debe mostrar**:

```
No such file or directory  ← ✅ Correcto
```

---

## 🎯 Cambios en ecosystem.config.js

Asegúrate de que tenga estas variables:

```javascript
env: {
  NODE_ENV: "production",
  PORT: 4000,
  MYSQL_HOST: "172.16.34.68",
  MYSQL_PORT: 3306,              // ← NUEVO
  MYSQL_USER: "root",
  MYSQL_PASSWORD: "Animalit0..9",
  MYSQL_DATABASE: "sesal_historico",
  MYSQL_CONNECTION_LIMIT: 50,
  MYSQL_QUEUE_LIMIT: 200,
  MYSQL_CONNECT_TIMEOUT: 20000,
  MYSQL_CHARSET: "utf8mb4",
  MYSQL_QUERY_TIMEOUT: 300000,
  CORS_ORIGINS: "http://172.16.36.59",  // ← NUEVO
}
```

---

## 🆘 Si Aún Hay Problemas

### Problema: Sigue usando usuario incorrecto

**Solución**:

```bash
# Eliminar COMPLETAMENTE PM2 y reiniciar
pm2 delete bisesal-backend
pm2 kill
rm -rf .bi-sesal/
pm2 start ecosystem.config.js
```

### Problema: Error de CORS

**Solución**: Agregar IP del frontend a `CORS_ORIGINS`:

```javascript
CORS_ORIGINS: "http://172.16.36.59,http://otra-ip.com";
```

### Problema: No se puede conectar a MySQL

**Verificar**:

1. MySQL está corriendo: `systemctl status mysql`
2. Puerto correcto: `netstat -tlnp | grep 3306`
3. Usuario tiene permisos desde IP del backend:

```sql
SHOW GRANTS FOR 'root'@'%';
```

---

## 📊 Antes vs Después

| Aspecto       | Antes ❌             | Después ✅                      |
| ------------- | -------------------- | ------------------------------- |
| Usuario BD    | `wsuario1`           | `root`                          |
| Configuración | Archivo `.bi-sesal/` | Variables de entorno            |
| CORS          | Rígido               | Configurable vía `CORS_ORIGINS` |
| Puerto MySQL  | No especificado      | `3306` explícito                |
| Express 5     | Error con `*`        | Sin errores                     |

---

## 📞 Comandos Útiles

```bash
# Ver logs en tiempo real
pm2 logs bisesal-backend

# Ver estado
pm2 status

# Ver variables de entorno cargadas
pm2 env 0 | grep MYSQL

# Reiniciar
pm2 restart bisesal-backend

# Ver uso de recursos
pm2 monit

# Probar todos los endpoints de health
./scripts/test_health.sh
```

---

## 📚 Documentación Completa

- **Checklist detallado**: [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md)
- **Cambios técnicos**: [CAMBIOS_REALIZADOS.md](./CAMBIOS_REALIZADOS.md)
- **README actualizado**: [README.md](./README.md)

---

## ✨ Resumen en 3 Pasos

```bash
# 1. Limpiar
rm -rf .bi-sesal/

# 2. Reiniciar
pm2 restart bisesal-backend

# 3. Verificar
curl http://localhost:4000/api/health/db
```

**¡Listo!** 🎉

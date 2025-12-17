# 📋 Checklist de Despliegue - BI SESAL Backend

## 🔧 Antes de desplegar

### 1. Verificar variables de entorno en el servidor

Asegúrate de que estas variables estén configuradas en `ecosystem.config.js`:

```bash
NODE_ENV=production
PORT=4000
MYSQL_HOST=172.16.34.68
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=tu_password
MYSQL_DATABASE=sesal_historico
MYSQL_CONNECTION_LIMIT=50
MYSQL_QUEUE_LIMIT=200
MYSQL_CONNECT_TIMEOUT=20000
MYSQL_CHARSET=utf8mb4
MYSQL_QUERY_TIMEOUT=300000
CORS_ORIGINS=http://172.16.36.59
```

### 2. Limpiar configuración persistida

```bash
# En el servidor, ejecuta:
./scripts/cleanup_server.sh
```

Esto eliminará cualquier archivo `.bi-sesal/database-config.json` que pueda sobrescribir las variables de entorno.

### 3. Construir el proyecto

```bash
npm run build
```

### 4. Iniciar con PM2

```bash
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

## 🔍 Verificar después del despliegue

### 1. Verificar que PM2 esté corriendo

```bash
pm2 list
pm2 logs bisesal-backend --lines 50
```

### 2. Probar conexión a base de datos

```bash
curl http://localhost:4000/api/health/db
```

Respuesta esperada:

```json
{
  "connected": true,
  "message": "Conexión a base de datos exitosa"
}
```

### 3. Verificar métricas del sistema

```bash
curl http://localhost:4000/api/health/metrics
```

### 4. Probar desde el frontend

Desde el navegador en `http://172.16.36.59`, verifica que:

- No haya errores de CORS
- Las peticiones lleguen correctamente
- Los datos se muestren

## 🐛 Solución de problemas comunes

### Error: "Access denied for user 'wsuario1'"

**Causa**: Hay un archivo `.bi-sesal/database-config.json` con configuración antigua.

**Solución**:

```bash
rm -rf .bi-sesal/
pm2 restart bisesal-backend
```

### Error: CORS

**Causa**: El origen del frontend no está en la lista permitida.

**Solución**: Actualizar `CORS_ORIGINS` en `ecosystem.config.js`:

```javascript
CORS_ORIGINS: "http://172.16.36.59,http://otro-origen.com";
```

### Error: "Lost connection to MySQL server"

**Causa**: Host o puerto incorrecto.

**Solución**: Verificar variables de entorno:

```bash
pm2 env 0 | grep MYSQL
```

### PM2 muestra múltiples instancias con errores

**Causa**: Modo cluster con configuración incorrecta.

**Solución temporal**: Cambiar a una sola instancia en `ecosystem.config.js`:

```javascript
instances: 1,
exec_mode: "fork",
```

## 📝 Logs importantes

Ver logs en tiempo real:

```bash
pm2 logs bisesal-backend
```

Ver solo errores:

```bash
pm2 logs bisesal-backend --err
```

Ver logs del archivo:

```bash
tail -f logs/error.log
tail -f logs/out.log
```

## 🔒 Seguridad

1. ✅ Las contraseñas están en variables de entorno (no en código)
2. ✅ CORS configurado solo para orígenes permitidos
3. ✅ Helmet activado para headers de seguridad
4. ✅ Rate limiting configurado (300 req/min por IP)
5. ✅ Logs de todas las peticiones

## 🎯 Comportamiento en producción

Cuando `NODE_ENV=production`:

- ✅ Se ignora cualquier archivo `.bi-sesal/database-config.json`
- ✅ Solo se usan variables de entorno de `ecosystem.config.js`
- ✅ CORS estricto (solo orígenes en `CORS_ORIGINS`)
- ✅ Pool de conexiones optimizado (50 conexiones)
- ✅ SSL opcional para MySQL (configurable)

## 📞 Comandos útiles

```bash
# Reiniciar aplicación
pm2 restart bisesal-backend

# Detener aplicación
pm2 stop bisesal-backend

# Ver estado
pm2 status

# Ver uso de recursos
pm2 monit

# Recargar sin downtime
pm2 reload bisesal-backend

# Eliminar de PM2
pm2 delete bisesal-backend
```

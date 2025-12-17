# 📚 Índice de Documentación - BI SESAL Backend

## 🚀 Inicio Rápido

1. **[SOLUCION_RAPIDA.md](./SOLUCION_RAPIDA.md)** ⭐ **EMPIEZA AQUÍ**
   - Solución en 3 pasos
   - Comandos esenciales
   - Verificación rápida

## 📖 Documentación Principal

2. **[README.md](./README.md)**

   - Descripción del proyecto
   - Instalación y configuración
   - Estructura del proyecto
   - Endpoints disponibles

3. **[DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md)**

   - Checklist completo de despliegue
   - Verificaciones post-despliegue
   - Solución de problemas comunes
   - Comandos útiles de PM2

4. **[CAMBIOS_REALIZADOS.md](./CAMBIOS_REALIZADOS.md)**
   - Documentación técnica detallada
   - Problemas identificados
   - Soluciones implementadas
   - Comparación antes/después

## 🛠️ Configuración

5. **[env.example](./env.example)**

   - Plantilla de variables de entorno
   - Variables para desarrollo
   - Variables para producción

6. **[ecosystem.config.js](./ecosystem.config.js)**
   - Configuración de PM2
   - Variables de entorno de producción
   - Configuración de logs

## 🔧 Scripts Útiles

### Scripts de Shell

7. **[scripts/verify_config.sh](./scripts/verify_config.sh)**

   ```bash
   ./scripts/verify_config.sh
   ```

   - Verifica configuración antes de desplegar
   - Detecta errores y advertencias
   - Valida archivos y dependencias

8. **[scripts/cleanup_server.sh](./scripts/cleanup_server.sh)**

   ```bash
   ./scripts/cleanup_server.sh
   ```

   - Limpia configuración persistida (`.bi-sesal/`)
   - Muestra variables de entorno
   - Útil antes de desplegar

9. **[scripts/test_health.sh](./scripts/test_health.sh)**

   ```bash
   ./scripts/test_health.sh [puerto]
   ```

   - Prueba todos los endpoints de health
   - Muestra respuestas formateadas
   - Útil para verificar que el servidor funciona

10. **[scripts/import_dump.sh](./scripts/import_dump.sh)**

    ```bash
    ./scripts/import_dump.sh [password]
    ```

    - Importa dump SQL comprimido (.gz)
    - Usa conexión TCP
    - Para archivos grandes

11. **[scripts/import_dump_socket.sh](./scripts/import_dump_socket.sh)**
    ```bash
    ./scripts/import_dump_socket.sh [password]
    ```
    - Importa dump SQL comprimido (.gz)
    - Usa socket Unix (más confiable en MAMP)
    - Para archivos grandes

### Scripts SQL

12. **[scripts/verificar_permisos_mysql.sql](./scripts/verificar_permisos_mysql.sql)**
    - Queries para verificar usuarios MySQL
    - Verificar permisos
    - Ver estado de conexiones
    - Comandos para crear/modificar permisos

### Scripts Node.js

13. **[scripts/db_counts.js](./scripts/db_counts.js)**
    - Utilidad para contar registros en tablas
    - (Script existente del proyecto)

## 📊 Flujo de Trabajo Recomendado

### Para Desarrollo Local

```bash
# 1. Configurar entorno
cp env.example .env
# Editar .env con tus valores locales

# 2. Instalar dependencias
npm install

# 3. Ejecutar en modo desarrollo
npm run dev

# 4. Probar endpoints
./scripts/test_health.sh
```

### Para Despliegue en Servidor

```bash
# 1. Verificar configuración
./scripts/verify_config.sh

# 2. Limpiar configuración antigua
./scripts/cleanup_server.sh

# 3. Compilar
npm run build

# 4. Iniciar con PM2
pm2 start ecosystem.config.js
pm2 save

# 5. Verificar
curl http://localhost:4000/api/health/db
./scripts/test_health.sh
```

### Para Importar Base de Datos

```bash
# Opción 1: Socket Unix (recomendado para MAMP)
./scripts/import_dump_socket.sh tu_password

# Opción 2: TCP
./scripts/import_dump.sh tu_password
```

## 🆘 Solución de Problemas

### Problema: Usuario incorrecto en BD

📖 Ver: [SOLUCION_RAPIDA.md](./SOLUCION_RAPIDA.md) - Sección "Verificación de Éxito"

### Problema: Errores de CORS

📖 Ver: [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md) - Sección "Error: CORS"

### Problema: PM2 con errores

📖 Ver: [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md) - Sección "PM2 muestra múltiples instancias con errores"

### Problema: No se puede conectar a MySQL

📖 Ver: [SOLUCION_RAPIDA.md](./SOLUCION_RAPIDA.md) - Sección "Problema: No se puede conectar a MySQL"

## 🔍 Verificación Rápida

```bash
# ¿Todo está configurado correctamente?
./scripts/verify_config.sh

# ¿El servidor está funcionando?
curl http://localhost:4000/api/health/db

# ¿Hay errores en los logs?
pm2 logs bisesal-backend --lines 50

# ¿Qué usuario está usando?
pm2 logs bisesal-backend | grep "DB CONFIG EN USO"
```

## 📞 Comandos Más Usados

```bash
# Ver estado de PM2
pm2 status

# Ver logs en tiempo real
pm2 logs bisesal-backend

# Reiniciar aplicación
pm2 restart bisesal-backend

# Probar endpoints de health
./scripts/test_health.sh

# Verificar configuración
./scripts/verify_config.sh

# Limpiar configuración persistida
./scripts/cleanup_server.sh
```

## 🎯 Resumen de Cambios Clave

| Problema                 | Solución                     | Archivo                        |
| ------------------------ | ---------------------------- | ------------------------------ |
| Usuario incorrecto       | Priorizar env en producción  | `configuracion-bd.servicio.ts` |
| Puerto MySQL faltante    | Agregado `MYSQL_PORT: 3306`  | `ecosystem.config.js`          |
| CORS rígido              | Variable `CORS_ORIGINS`      | `aplicacion.ts`                |
| Error Express 5          | Eliminado `app.options("*")` | `aplicacion.ts`                |
| Config persistida en Git | Agregado `.bi-sesal/`        | `.gitignore`                   |

## 📝 Notas Importantes

- ⚠️ En **producción**, el archivo `.bi-sesal/database-config.json` se **IGNORA**
- ✅ Siempre usa variables de `ecosystem.config.js` en producción
- 🔒 Nunca subas `.env` o `.bi-sesal/` a Git
- 📊 Usa `./scripts/verify_config.sh` antes de cada despliegue
- 🧹 Ejecuta `./scripts/cleanup_server.sh` si cambias de servidor

---

**Última actualización**: Diciembre 2025
**Versión del proyecto**: 1.0.0

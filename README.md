# Backend BI SESAL

Backend del Sistema de Business Intelligence para SESAL (Secretaría de Salud de Honduras).

## 🚀 Tecnologías

- **Node.js** con TypeScript
- **Express.js** para API REST
- **MySQL** como base de datos
- **PM2** para gestión de procesos en producción

## 📋 Prerrequisitos

- Node.js 18+
- MySQL 8.0+
- PM2 (opcional para producción)

## 🛠️ Instalación

1. Instalar dependencias:

```bash
npm install
```

2. Configurar variables de entorno:
   Copiar `env.example` a `.env` y ajustar los valores:

```bash
cp env.example .env
```

Variables principales:

```env
NODE_ENV=development
PORT=4000
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=tu_contraseña
MYSQL_DATABASE=sesal_historico
CORS_ORIGINS=http://localhost:5173
```

3. Compilar TypeScript:

```bash
npm run build
```

## 🏃 Ejecución

### Desarrollo

```bash
npm run dev
```

### Producción

```bash
npm run build
npm start
```

### Con PM2

```bash
pm2 start ecosystem.config.js
```

## 📁 Estructura del Proyecto

```
backend/
├── src/
│   ├── server.ts              # Punto de entrada
│   ├── aplicacion.ts          # Configuración de Express
│   ├── base_datos/            # Configuración de base de datos
│   ├── configuracion/         # Configuración de entorno
│   ├── controladores/         # Controladores de rutas
│   ├── middleware/            # Middlewares
│   ├── rutas/                 # Definición de rutas
│   ├── servicios/             # Lógica de negocio
│   └── utilidades/            # Utilidades y helpers
├── scripts/                   # Scripts auxiliares
├── package.json
├── tsconfig.json
└── ecosystem.config.js        # Configuración PM2
```

## 🔌 Endpoints Principales

### Health & Monitoring

- `GET /salud` - Health check básico
- `GET /api/health/db` - Estado de conexión a BD
- `GET /api/health/metrics` - Métricas del sistema
- `GET /api/health/cache` - Estado del caché

### API

- `GET /api/configuracion` - Configuración del sistema
- `GET /api/reportes` - Reportes y datos
- `GET /api/pivot` - Datos para tablas dinámicas
- `GET /api/tablero` - Datos del dashboard

## 📝 Scripts Disponibles

### NPM Scripts

- `npm run dev` - Ejecuta en modo desarrollo con ts-node
- `npm run build` - Compila TypeScript a JavaScript
- `npm start` - Ejecuta la versión compilada

### Utilidades

- `./scripts/import_dump.sh` - Importar dump SQL (TCP)
- `./scripts/import_dump_socket.sh` - Importar dump SQL (socket Unix)
- `./scripts/test_health.sh` - Probar endpoints de health
- `./scripts/cleanup_server.sh` - Limpiar configuración persistida

## 🔒 Seguridad

- Helmet para headers de seguridad
- CORS configurado (orígenes permitidos vía `CORS_ORIGINS`)
- Rate limiting (300 req/min por IP)
- Validación de entrada
- Variables de entorno para credenciales
- En producción: configuración persistida deshabilitada

## 🚀 Despliegue en Producción

Ver [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md) para instrucciones detalladas.

### Resumen rápido:

```bash
# 1. Limpiar configuración local
./scripts/cleanup_server.sh

# 2. Compilar
npm run build

# 3. Iniciar con PM2
pm2 start ecosystem.config.js
pm2 save

# 4. Verificar
curl http://localhost:4000/api/health/db
```

## ⚠️ Problemas Comunes

### Error: "Access denied for user 'wsuario1'"

Hay un archivo `.bi-sesal/database-config.json` con configuración antigua.

```bash
rm -rf .bi-sesal/
pm2 restart bisesal-backend
```

### Error: CORS

Agregar el origen del frontend a `CORS_ORIGINS` en `ecosystem.config.js`:

```javascript
CORS_ORIGINS: "http://172.16.36.59,http://otro-origen.com";
```

## 📄 Licencia

ISC

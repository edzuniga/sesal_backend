# 👋 ¡Bienvenido al Backend BI SESAL!

## 🚨 ¿Problemas de Despliegue?

Si vienes aquí porque hay problemas en producción, ve directamente a:

### ⭐ [SOLUCION_RAPIDA.md](./SOLUCION_RAPIDA.md) ⭐

**Solución en 3 pasos** (5 minutos):

```bash
rm -rf .bi-sesal/
pm2 restart bisesal-backend
curl http://localhost:4000/api/health/db
```

---

## 📚 Documentación Completa

### Para Desarrolladores:

- 📖 [README.md](./README.md) - Instalación y uso general
- 🔧 [scripts/README.md](./scripts/README.md) - Guía de scripts

### Para DevOps/Despliegue:

- ✅ [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md) - Checklist paso a paso
- 📊 [DIAGRAMA_CONFIGURACION.md](./DIAGRAMA_CONFIGURACION.md) - Arquitectura visual
- 📝 [CAMBIOS_REALIZADOS.md](./CAMBIOS_REALIZADOS.md) - Cambios técnicos

### Para Gestión:

- 📊 [RESUMEN_EJECUTIVO.md](./RESUMEN_EJECUTIVO.md) - Resumen ejecutivo

### Índice General:

- 📚 [INDICE_DOCUMENTACION.md](./INDICE_DOCUMENTACION.md) - Toda la documentación

---

## 🚀 Inicio Rápido

### Desarrollo Local:

```bash
# 1. Instalar
npm install

# 2. Configurar
cp env.example .env
# Editar .env con tus valores

# 3. Ejecutar
npm run dev

# 4. Probar
curl http://localhost:4000/api/health/db
```

### Despliegue en Servidor:

```bash
# 1. Verificar
./scripts/verify_config.sh

# 2. Limpiar
./scripts/cleanup_server.sh

# 3. Compilar
npm run build

# 4. Iniciar
pm2 start ecosystem.config.js

# 5. Verificar
./scripts/test_health.sh
```

---

## 🆘 Ayuda Rápida

### ¿El servidor no conecta a la BD?

```bash
./scripts/cleanup_server.sh
pm2 restart bisesal-backend
```

### ¿Errores de CORS?

Agregar origen del frontend a `CORS_ORIGINS` en `ecosystem.config.js`:

```javascript
CORS_ORIGINS: "http://tu-frontend.com";
```

### ¿Verificar configuración?

```bash
./scripts/verify_config.sh
```

### ¿Ver logs?

```bash
pm2 logs bisesal-backend
```

---

## 📞 Comandos Más Usados

```bash
# Estado del servidor
pm2 status

# Reiniciar
pm2 restart bisesal-backend

# Ver logs en tiempo real
pm2 logs bisesal-backend

# Probar endpoints
./scripts/test_health.sh

# Verificar configuración
./scripts/verify_config.sh
```

---

## 🎯 Problemas Comunes y Soluciones

| Problema              | Solución Rápida                                               |
| --------------------- | ------------------------------------------------------------- |
| Usuario BD incorrecto | `rm -rf .bi-sesal/ && pm2 restart`                            |
| Error de CORS         | Agregar origen a `CORS_ORIGINS`                               |
| No conecta a MySQL    | Verificar IP y puerto en `ecosystem.config.js`                |
| PM2 con errores       | `pm2 delete bisesal-backend && pm2 start ecosystem.config.js` |

---

## ✨ Características Principales

- ✅ Express 5 con TypeScript
- ✅ Pool de conexiones MySQL optimizado
- ✅ CORS configurable
- ✅ Rate limiting (300 req/min)
- ✅ Caché inteligente
- ✅ Logs estructurados
- ✅ Health checks
- ✅ PM2 cluster mode

---

## 🏗️ Arquitectura

```
Frontend (172.16.36.59)
    ↓
Backend (172.16.36.58:4000)
    ↓
MySQL (172.16.34.68:3306)
```

---

**¿Necesitas más ayuda?** → [INDICE_DOCUMENTACION.md](./INDICE_DOCUMENTACION.md)

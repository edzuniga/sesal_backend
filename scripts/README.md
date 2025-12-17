# 🛠️ Scripts de Utilidad - BI SESAL Backend

Esta carpeta contiene scripts útiles para el desarrollo, despliegue y mantenimiento del backend.

## 📋 Scripts Disponibles

### 🔍 Verificación y Diagnóstico

#### `verify_config.sh`

Verifica que la configuración del proyecto esté correcta antes de desplegar.

```bash
./scripts/verify_config.sh
```

**Verifica**:

- Archivos necesarios (ecosystem.config.js, package.json, etc.)
- Variables de entorno configuradas
- Dependencias instaladas
- Estado del proyecto

**Salida**:

- ✅ Verde: Todo correcto
- ⚠️ Amarillo: Advertencias (puede continuar)
- ❌ Rojo: Errores (debe corregir)

---

#### `test_health.sh`

Prueba todos los endpoints de health del backend.

```bash
./scripts/test_health.sh [puerto]
```

**Parámetros**:

- `puerto` (opcional): Puerto del servidor (default: 4000)

**Prueba**:

- `/api/health/db` - Estado de conexión a BD
- `/api/health/metrics` - Métricas del sistema
- `/api/health/cache` - Estado del caché

**Ejemplo**:

```bash
./scripts/test_health.sh 4000
```

---

### 🧹 Limpieza y Mantenimiento

#### `cleanup_server.sh`

Limpia la configuración persistida del servidor.

```bash
./scripts/cleanup_server.sh
```

**Función**:

- Elimina directorio `.bi-sesal/` (configuración persistida)
- Muestra variables de entorno MySQL actuales
- Interactivo: pide confirmación antes de eliminar

**Cuándo usar**:

- Antes de desplegar en producción
- Al cambiar de servidor
- Cuando hay problemas de autenticación a BD
- Para forzar uso de variables de entorno

---

### 💾 Importación de Base de Datos

#### `import_dump.sh`

Importa un dump SQL comprimido (.gz) usando conexión TCP.

```bash
./scripts/import_dump.sh [password]
```

**Parámetros**:

- `password` (opcional): Contraseña de MySQL. Si no se proporciona, la pedirá.

**Configuración**:

- Host: 127.0.0.1
- Puerto: 9000 (MAMP)
- Usuario: root
- Base de datos: sesal_historico

**Características**:

- Descomprime y importa en un solo paso (sin archivo temporal)
- Aumenta `max_allowed_packet` a 1024M
- Configura charset UTF8MB4

**Ejemplo**:

```bash
./scripts/import_dump.sh root
```

---

#### `import_dump_socket.sh`

Importa un dump SQL comprimido (.gz) usando socket Unix.

```bash
./scripts/import_dump_socket.sh [password]
```

**Parámetros**:

- `password` (opcional): Contraseña de MySQL

**Ventajas sobre TCP**:

- Más confiable en MAMP
- Busca automáticamente el socket correcto
- Fallback a TCP si no encuentra socket

**Socket común**: `/Applications/MAMP/tmp/mysql/mysql.sock`

**Recomendado para**:

- Desarrollo local con MAMP
- Archivos muy grandes
- Cuando TCP da problemas de conexión

---

### 🗄️ SQL

#### `verificar_permisos_mysql.sql`

Queries SQL para verificar y diagnosticar permisos en MySQL.

**Uso**:

```bash
mysql -u root -p < scripts/verificar_permisos_mysql.sql
```

**Incluye queries para**:

1. Ver usuarios existentes
2. Ver permisos del usuario root
3. Ver conexiones actuales
4. Verificar base de datos sesal_historico
5. Ver tablas y tamaños
6. Verificar variables de MySQL
7. Ver estado de conexiones

**También incluye** (comentados):

- Comandos para crear usuarios
- Comandos para otorgar permisos
- Comandos para verificar después de cambios

---

### 📊 Node.js

#### `db_counts.js`

Script Node.js para contar registros en tablas.

```bash
node scripts/db_counts.js
```

_(Script existente del proyecto)_

---

## 🚀 Flujos de Trabajo Comunes

### Despliegue en Producción

```bash
# 1. Verificar configuración
./scripts/verify_config.sh

# 2. Limpiar configuración antigua
./scripts/cleanup_server.sh

# 3. Compilar proyecto
npm run build

# 4. Iniciar con PM2
pm2 start ecosystem.config.js

# 5. Verificar que funciona
./scripts/test_health.sh
```

---

### Importar Base de Datos (Desarrollo Local)

```bash
# Opción 1: Con socket (recomendado para MAMP)
./scripts/import_dump_socket.sh root

# Opción 2: Con TCP
./scripts/import_dump.sh root

# Verificar importación
mysql -u root -p sesal_historico -e "SHOW TABLES;"
```

---

### Diagnosticar Problemas de Conexión

```bash
# 1. Verificar configuración
./scripts/verify_config.sh

# 2. Probar endpoints
./scripts/test_health.sh

# 3. Si hay errores, verificar permisos en MySQL
mysql -u root -p < scripts/verificar_permisos_mysql.sql

# 4. Limpiar configuración persistida
./scripts/cleanup_server.sh

# 5. Reiniciar y probar
pm2 restart bisesal-backend
./scripts/test_health.sh
```

---

## 📝 Notas Importantes

### Permisos de Ejecución

Todos los scripts `.sh` deben tener permisos de ejecución:

```bash
chmod +x scripts/*.sh
```

### Variables de Entorno

Los scripts asumen ciertas configuraciones por defecto:

- **Puerto backend**: 4000
- **Puerto MySQL (MAMP)**: 9000
- **Usuario MySQL**: root
- **Base de datos**: sesal_historico

Si tu configuración es diferente, edita los scripts o pasa parámetros.

### Seguridad

⚠️ **Advertencia**: Algunos scripts aceptan contraseñas como parámetros. Esto puede ser inseguro en entornos compartidos ya que las contraseñas quedan en el historial de comandos.

**Alternativa segura**:

```bash
# No pasar contraseña como parámetro
./scripts/import_dump.sh
# El script pedirá la contraseña de forma segura
```

### Compatibilidad

- **OS**: macOS, Linux
- **Shell**: bash
- **Dependencias**: curl, jq (opcional para formato JSON)

---

## 🆘 Solución de Problemas

### Script no ejecutable

```bash
chmod +x scripts/nombre_script.sh
```

### Comando no encontrado

Asegúrate de ejecutar desde la raíz del proyecto:

```bash
cd /ruta/al/proyecto
./scripts/nombre_script.sh
```

### Error de permisos en MySQL

Verifica permisos con:

```bash
mysql -u root -p < scripts/verificar_permisos_mysql.sql
```

---

## 📚 Más Información

- [Documentación completa](../INDICE_DOCUMENTACION.md)
- [Guía de despliegue](../DEPLOYMENT_CHECKLIST.md)
- [Solución rápida](../SOLUCION_RAPIDA.md)

---

**Última actualización**: Diciembre 2025

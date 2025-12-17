-- Script SQL para verificar permisos de usuario en MySQL
-- Ejecutar desde el servidor de base de datos

-- ============================================
-- 1. Ver usuarios existentes
-- ============================================
SELECT 
    user, 
    host, 
    authentication_string,
    plugin
FROM mysql.user
WHERE user = 'root';

-- ============================================
-- 2. Ver permisos del usuario root
-- ============================================
SHOW GRANTS FOR 'root'@'%';
SHOW GRANTS FOR 'root'@'localhost';

-- ============================================
-- 3. Ver conexiones actuales
-- ============================================
SELECT 
    user,
    host,
    db,
    command,
    time,
    state,
    info
FROM information_schema.processlist
WHERE user = 'root';

-- ============================================
-- 4. Verificar base de datos sesal_historico
-- ============================================
SELECT 
    SCHEMA_NAME,
    DEFAULT_CHARACTER_SET_NAME,
    DEFAULT_COLLATION_NAME
FROM information_schema.SCHEMATA
WHERE SCHEMA_NAME = 'sesal_historico';

-- ============================================
-- 5. Ver tablas en sesal_historico
-- ============================================
SELECT 
    TABLE_NAME,
    TABLE_ROWS,
    DATA_LENGTH,
    INDEX_LENGTH,
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS 'Size_MB'
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sesal_historico'
ORDER BY (DATA_LENGTH + INDEX_LENGTH) DESC
LIMIT 20;

-- ============================================
-- 6. Verificar variables de MySQL
-- ============================================
SHOW VARIABLES LIKE 'max_connections';
SHOW VARIABLES LIKE 'max_allowed_packet';
SHOW VARIABLES LIKE 'wait_timeout';
SHOW VARIABLES LIKE 'character_set%';

-- ============================================
-- 7. Ver estado de conexiones
-- ============================================
SHOW STATUS LIKE 'Threads_connected';
SHOW STATUS LIKE 'Threads_running';
SHOW STATUS LIKE 'Max_used_connections';
SHOW STATUS LIKE 'Aborted_connects';

-- ============================================
-- COMANDOS PARA CREAR/MODIFICAR PERMISOS
-- (Solo ejecutar si es necesario)
-- ============================================

-- Crear usuario root con acceso desde cualquier IP (si no existe)
-- CREATE USER 'root'@'%' IDENTIFIED BY 'tu_password';

-- Dar todos los permisos a root desde cualquier IP
-- GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- Dar permisos específicos solo a sesal_historico
-- GRANT ALL PRIVILEGES ON sesal_historico.* TO 'root'@'%';

-- Dar permisos desde IP específica del servidor backend
-- GRANT ALL PRIVILEGES ON sesal_historico.* TO 'root'@'172.16.36.58';

-- Aplicar cambios
-- FLUSH PRIVILEGES;

-- ============================================
-- VERIFICAR DESPUÉS DE CAMBIOS
-- ============================================
-- SHOW GRANTS FOR 'root'@'%';
-- SELECT user, host FROM mysql.user WHERE user = 'root';


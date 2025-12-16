#!/bin/bash

# Script alternativo usando socket Unix (más confiable en MAMP)
# Uso: ./scripts/import_dump_socket.sh [password]

MYSQL_PATH="/Applications/MAMP/Library/bin/mysql80/bin/mysql"
DUMP_FILE="sesal_historico_dump_20251208_210133.sql.gz"
DB_NAME="sesal_historico"
DB_USER="root"

# Socket común de MAMP (ajusta según tu versión de MySQL)
SOCKET_PATH="/Applications/MAMP/tmp/mysql/mysql.sock"

# Verificar que el archivo existe
if [ ! -f "$DUMP_FILE" ]; then
    echo "Error: No se encontró el archivo $DUMP_FILE"
    exit 1
fi

# Verificar que MySQL está disponible
if [ ! -f "$MYSQL_PATH" ]; then
    echo "Error: No se encontró MySQL en $MYSQL_PATH"
    exit 1
fi

# Verificar socket alternativo si el primero no existe
if [ ! -S "$SOCKET_PATH" ]; then
    # Intentar encontrar el socket
    ALTERNATIVE_SOCKET=$(find /Applications/MAMP/tmp -name "mysql.sock" 2>/dev/null | head -1)
    if [ -n "$ALTERNATIVE_SOCKET" ]; then
        SOCKET_PATH="$ALTERNATIVE_SOCKET"
        echo "Usando socket encontrado: $SOCKET_PATH"
    else
        echo "Advertencia: No se encontró socket Unix, intentando con TCP..."
        SOCKET_PATH=""
    fi
fi

# Obtener contraseña
if [ -n "$1" ]; then
    DB_PASSWORD="$1"
else
    echo -n "Ingresa la contraseña de MySQL (root): "
    read -s DB_PASSWORD
    echo
fi

echo "Importando $DUMP_FILE a la base de datos $DB_NAME..."
echo "Esto puede tardar varios minutos dependiendo del tamaño del archivo..."

# Construir comando mysql
MYSQL_CMD="$MYSQL_PATH -u $DB_USER -p$DB_PASSWORD"

# Agregar socket o host/port
if [ -n "$SOCKET_PATH" ] && [ -S "$SOCKET_PATH" ]; then
    MYSQL_CMD="$MYSQL_CMD --socket=$SOCKET_PATH"
else
    MYSQL_CMD="$MYSQL_CMD -h 127.0.0.1 -P 9000"
fi

# Agregar opciones adicionales
MYSQL_CMD="$MYSQL_CMD --max_allowed_packet=1024M --default-character-set=utf8mb4 $DB_NAME"

# Importar usando gunzip y pipe a mysql
gunzip -c "$DUMP_FILE" | eval "$MYSQL_CMD"

if [ $? -eq 0 ]; then
    echo "¡Importación completada exitosamente!"
else
    echo "Error durante la importación. Verifica:"
    echo "1. Que MySQL esté corriendo en MAMP"
    echo "2. Que la base de datos '$DB_NAME' exista"
    echo "3. Que tengas permisos suficientes"
    echo ""
    echo "Puedes verificar la conexión manualmente con:"
    echo "$MYSQL_PATH -u $DB_USER -p -h 127.0.0.1 -P 9000"
    exit 1
fi


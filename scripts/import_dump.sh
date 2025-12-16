#!/bin/bash

# Script para importar el dump SQL comprimido a MySQL en MAMP
# Uso: ./scripts/import_dump.sh [password]

MYSQL_PATH="/Applications/MAMP/Library/bin/mysql80/bin/mysql"
DUMP_FILE="sesal_historico_dump_20251208_210133.sql.gz"
DB_NAME="sesal_historico"
DB_HOST="127.0.0.1"
DB_PORT="9000"
DB_USER="root"

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

# Obtener contraseña (puede pasarse como argumento o se pedirá)
if [ -n "$1" ]; then
    DB_PASSWORD="$1"
else
    echo -n "Ingresa la contraseña de MySQL (root): "
    read -s DB_PASSWORD
    echo
fi

echo "Importando $DUMP_FILE a la base de datos $DB_NAME..."
echo "Esto puede tardar varios minutos dependiendo del tamaño del archivo..."

# Importar usando gunzip y pipe a mysql
gunzip -c "$DUMP_FILE" | "$MYSQL_PATH" \
    -u "$DB_USER" \
    -p"$DB_PASSWORD" \
    -h "$DB_HOST" \
    -P "$DB_PORT" \
    --max_allowed_packet=1024M \
    --default-character-set=utf8mb4 \
    "$DB_NAME"

if [ $? -eq 0 ]; then
    echo "¡Importación completada exitosamente!"
else
    echo "Error durante la importación. Verifica:"
    echo "1. Que MySQL esté corriendo en MAMP"
    echo "2. Que el puerto sea correcto (9000)"
    echo "3. Que la base de datos '$DB_NAME' exista"
    echo "4. Que tengas permisos suficientes"
    exit 1
fi


#!/bin/bash

# Script para limpiar configuración persistida en el servidor
# Útil cuando se despliega a producción y se quiere asegurar que solo use variables de entorno

echo "🧹 Limpiando configuración persistida del servidor..."

# Directorio de configuración persistida
CONFIG_DIR=".bi-sesal"

if [ -d "$CONFIG_DIR" ]; then
    echo "📁 Encontrado directorio $CONFIG_DIR"
    echo "   Contenido:"
    ls -la "$CONFIG_DIR"
    echo ""
    read -p "¿Deseas eliminar este directorio? (s/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        rm -rf "$CONFIG_DIR"
        echo "✅ Directorio eliminado"
    else
        echo "❌ Operación cancelada"
    fi
else
    echo "✅ No hay configuración persistida (directorio $CONFIG_DIR no existe)"
fi

echo ""
echo "📋 Variables de entorno MySQL actuales:"
env | grep MYSQL_ | sed 's/=.*/=***/' || echo "   No se encontraron variables MYSQL_*"

echo ""
echo "✅ Limpieza completada"


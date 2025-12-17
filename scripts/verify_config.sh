#!/bin/bash

# Script para verificar la configuración antes de desplegar
# Uso: ./scripts/verify_config.sh

echo "🔍 Verificando configuración del proyecto..."
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Contadores
ERRORS=0
WARNINGS=0

# Función para verificar
check() {
    local name=$1
    local condition=$2
    local message=$3
    local level=${4:-error}  # error o warning
    
    if [ "$condition" = "true" ]; then
        echo -e "${GREEN}✓${NC} $name"
    else
        if [ "$level" = "error" ]; then
            echo -e "${RED}✗${NC} $name"
            echo -e "  ${RED}→${NC} $message"
            ((ERRORS++))
        else
            echo -e "${YELLOW}⚠${NC} $name"
            echo -e "  ${YELLOW}→${NC} $message"
            ((WARNINGS++))
        fi
    fi
}

echo -e "${BLUE}=== Archivos del Proyecto ===${NC}"

check "ecosystem.config.js existe" \
    "$([ -f ecosystem.config.js ] && echo true || echo false)" \
    "Falta archivo ecosystem.config.js"

check "package.json existe" \
    "$([ -f package.json ] && echo true || echo false)" \
    "Falta archivo package.json"

check "tsconfig.json existe" \
    "$([ -f tsconfig.json ] && echo true || echo false)" \
    "Falta archivo tsconfig.json"

echo ""
echo -e "${BLUE}=== Configuración de Producción ===${NC}"

if [ -f ecosystem.config.js ]; then
    check "NODE_ENV configurado" \
        "$(grep -q 'NODE_ENV.*production' ecosystem.config.js && echo true || echo false)" \
        "NODE_ENV debe ser 'production' en ecosystem.config.js"
    
    check "MYSQL_HOST configurado" \
        "$(grep -q 'MYSQL_HOST' ecosystem.config.js && echo true || echo false)" \
        "Falta MYSQL_HOST en ecosystem.config.js"
    
    check "MYSQL_PORT configurado" \
        "$(grep -q 'MYSQL_PORT' ecosystem.config.js && echo true || echo false)" \
        "Falta MYSQL_PORT en ecosystem.config.js"
    
    check "MYSQL_USER configurado" \
        "$(grep -q 'MYSQL_USER' ecosystem.config.js && echo true || echo false)" \
        "Falta MYSQL_USER en ecosystem.config.js"
    
    check "MYSQL_PASSWORD configurado" \
        "$(grep -q 'MYSQL_PASSWORD' ecosystem.config.js && echo true || echo false)" \
        "Falta MYSQL_PASSWORD en ecosystem.config.js"
    
    check "MYSQL_DATABASE configurado" \
        "$(grep -q 'MYSQL_DATABASE' ecosystem.config.js && echo true || echo false)" \
        "Falta MYSQL_DATABASE en ecosystem.config.js"
    
    check "CORS_ORIGINS configurado" \
        "$(grep -q 'CORS_ORIGINS' ecosystem.config.js && echo true || echo false)" \
        "Falta CORS_ORIGINS en ecosystem.config.js" \
        "warning"
fi

echo ""
echo -e "${BLUE}=== Estado del Proyecto ===${NC}"

check "node_modules instalado" \
    "$([ -d node_modules ] && echo true || echo false)" \
    "Ejecuta: npm install"

check "Proyecto compilado" \
    "$([ -d dist ] && echo true || echo false)" \
    "Ejecuta: npm run build" \
    "warning"

check "Sin configuración persistida" \
    "$([ ! -d .bi-sesal ] && echo true || echo false)" \
    "Ejecuta: ./scripts/cleanup_server.sh" \
    "warning"

echo ""
echo -e "${BLUE}=== Dependencias ===${NC}"

if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo -e "${GREEN}✓${NC} Node.js instalado: $NODE_VERSION"
else
    echo -e "${RED}✗${NC} Node.js no instalado"
    ((ERRORS++))
fi

if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm -v)
    echo -e "${GREEN}✓${NC} npm instalado: $NPM_VERSION"
else
    echo -e "${RED}✗${NC} npm no instalado"
    ((ERRORS++))
fi

if command -v pm2 &> /dev/null; then
    PM2_VERSION=$(pm2 -v)
    echo -e "${GREEN}✓${NC} PM2 instalado: $PM2_VERSION"
else
    echo -e "${YELLOW}⚠${NC} PM2 no instalado (opcional para producción)"
    echo -e "  ${YELLOW}→${NC} Instala con: npm install -g pm2"
    ((WARNINGS++))
fi

echo ""
echo -e "${BLUE}=== Resumen ===${NC}"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ Todo está correcto. Listo para desplegar.${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ $WARNINGS advertencia(s) encontrada(s).${NC}"
    echo -e "${YELLOW}Puedes continuar, pero revisa las advertencias.${NC}"
    exit 0
else
    echo -e "${RED}❌ $ERRORS error(es) encontrado(s).${NC}"
    echo -e "${RED}Corrige los errores antes de desplegar.${NC}"
    exit 1
fi


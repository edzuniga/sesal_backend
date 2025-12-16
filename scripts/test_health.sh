#!/bin/bash

# Script para probar los endpoints de health
# Uso: ./scripts/test_health.sh [puerto]

PORT=${1:-4000}
BASE_URL="http://localhost:${PORT}/api/health"

echo "🧪 Probando endpoints de health en puerto ${PORT}..."
echo ""

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para probar un endpoint
test_endpoint() {
    local endpoint=$1
    local name=$2
    echo -n "Probando ${name}... "
    
    response=$(curl -s -w "\n%{http_code}" "${BASE_URL}${endpoint}")
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" -eq 200 ]; then
        echo -e "${GREEN}✓ OK${NC} (HTTP $http_code)"
        echo "$body" | jq . 2>/dev/null || echo "$body"
    else
        echo -e "${RED}✗ ERROR${NC} (HTTP $http_code)"
        echo "$body"
    fi
    echo ""
}

# Probar cada endpoint
test_endpoint "/db" "Estado de base de datos"
test_endpoint "/metrics" "Métricas del sistema"
test_endpoint "/cache" "Estado del caché"

echo "✅ Pruebas completadas"


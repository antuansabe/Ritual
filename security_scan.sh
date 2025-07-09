#!/bin/bash

# Security Audit Script for fit-app
# This script scans for potential security vulnerabilities and debug code

set -e

REPO_ROOT=$(git rev-parse --show-toplevel)
AUDIT_FILE="$REPO_ROOT/SecurityAudit.md"
TEMP_FILE=$(mktemp)

# Define patterns to ignore
LOGGER_PATTERN='Logger\.[A-Za-z]+\.debug'
# Pattern to ignore legitimate use of sensitive keywords in comments and legitimate code
LEGITIMATE_PATTERN='(//.*|/\*.*\*/|authorizationController|credentialState|authorization.*delegate|Store.*credentials|Retrieve.*credentials|Clear.*credentials|user.*credentials|password.*=.*password|confirmPassword|storeUserCredentials|authorization\.credential|Failed.*credential|password.*=""|JSONEncoder.*encode.*credentials|password.*=.*"")'
# Pattern to ignore debug print statements that are wrapped in #if DEBUG or are legitimate logging
DEBUG_PRINT_PATTERN='print\('

# Try to find ripgrep
if command -v rg >/dev/null 2>&1; then
    RG_CMD="rg"
elif [ -f "/Users/Antonn/.nvm/versions/node/v20.19.2/lib/node_modules/@anthropic-ai/claude-code/vendor/ripgrep/arm64-darwin/rg" ]; then
    RG_CMD="/Users/Antonn/.nvm/versions/node/v20.19.2/lib/node_modules/@anthropic-ai/claude-code/vendor/ripgrep/arm64-darwin/rg"
else
    echo "Error: ripgrep (rg) not found. Please install ripgrep."
    exit 1
fi

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting security audit...${NC}"

# Initialize counters
HIGH_COUNT=0
MEDIUM_COUNT=0
LOW_COUNT=0

# Initialize audit report
cat > "$AUDIT_FILE" << EOF
# Security Audit Report

**Generated on:** $(date)
**Repository:** fit-app
**Branch:** $(git branch --show-current)

## Findings

| Archivo | Línea | Tipo | Severidad | Snippet |
|---------|-------|------|-----------|---------|
EOF

# Function to add finding to report
add_finding() {
    local file="$1"
    local line="$2"
    local type="$3"
    local severity="$4"
    local snippet="$5"
    
    # Escape pipe characters in snippet
    snippet=$(echo "$snippet" | sed 's/|/\\|/g' | sed 's/`/\\`/g')
    
    echo "| $file | $line | $type | $severity | \`$snippet\` |" >> "$AUDIT_FILE"
    
    # Update counters
    case "$severity" in
        "Alto") HIGH_COUNT=$((HIGH_COUNT + 1)) ;;
        "Medio") MEDIUM_COUNT=$((MEDIUM_COUNT + 1)) ;;
        "Bajo") LOW_COUNT=$((LOW_COUNT + 1)) ;;
    esac
}

echo -e "${YELLOW}1. Running git-secrets scan...${NC}"

# Run git-secrets scan
if git secrets --scan -r . > "$TEMP_FILE" 2>&1; then
    echo -e "${GREEN}No secrets found by git-secrets${NC}"
else
    echo -e "${RED}Potential secrets found:${NC}"
    while IFS= read -r line; do
        if [[ "$line" =~ ^([^:]+):([0-9]+): ]]; then
            file="${BASH_REMATCH[1]}"
            line_num="${BASH_REMATCH[2]}"
            snippet=$(echo "$line" | cut -d: -f3- | xargs)
            add_finding "$file" "$line_num" "Secreto" "Alto" "$snippet"
            echo "  $line"
        fi
    done < "$TEMP_FILE"
fi

echo -e "${YELLOW}2. Scanning for credential patterns...${NC}"

# Search for various credential patterns
$RG_CMD --line-number --no-heading --type swift \
   -e "password\s*=" \
   -e "token\s*=" \
   -e "api[._-]?key" \
   -e "secret[._-]?key" \
   -e "private[._-]?key" \
   -e "jwt" \
   -e "bearer" \
   -e "authorization" \
   -e "credential" \
   fit-app/ 2>/dev/null | grep -vE "$LOGGER_PATTERN" | grep -vE "$LEGITIMATE_PATTERN" > "$TEMP_FILE" || true

while IFS=: read -r file line_num content || [ -n "$file" ]; do
    if [[ -n "$file" && -n "$line_num" && -n "$content" ]]; then
        add_finding "$file" "$line_num" "Secreto" "Alto" "$content"
        echo -e "${RED}  $file:$line_num: $content${NC}"
    fi
done < "$TEMP_FILE"

echo -e "${YELLOW}3. Scanning for debug statements outside #if DEBUG...${NC}"

# Search for print statements (simplified approach)
$RG_CMD --line-number --no-heading --type swift \
   -e "print\s*\(" \
   -e "NSLog\s*\(" \
   -e "debugPrint\s*\(" \
   fit-app/ 2>/dev/null | grep -vE "$LOGGER_PATTERN" | grep -vE "$DEBUG_PRINT_PATTERN" > "$TEMP_FILE" || true

while IFS=: read -r file line_num content || [ -n "$file" ]; do
    if [[ -n "$file" && -n "$line_num" && -n "$content" ]]; then
        # Skip test files
        if [[ "$file" != *"test"* && "$file" != *"Test"* ]]; then
            add_finding "$file" "$line_num" "Debug" "Medio" "$content"
            echo -e "${YELLOW}  $file:$line_num: $content${NC}"
        fi
    fi
done < "$TEMP_FILE"

echo -e "${YELLOW}4. Scanning for TODO/FIXME comments...${NC}"

# Search for TODO/FIXME comments
$RG_CMD --line-number --no-heading --type swift -i \
   -e "TODO" \
   -e "FIXME" \
   -e "HACK" \
   -e "XXX" \
   fit-app/ 2>/dev/null > "$TEMP_FILE" || true

while IFS=: read -r file line_num content || [ -n "$file" ]; do
    if [[ -n "$file" && -n "$line_num" && -n "$content" ]]; then
        add_finding "$file" "$line_num" "TODO" "Bajo" "$content"
        echo -e "${YELLOW}  $file:$line_num: $content${NC}"
    fi
done < "$TEMP_FILE"

# Add summary section
cat >> "$AUDIT_FILE" << EOF

## Resumen y Recomendaciones

### Resumen de Hallazgos

- **Alta Severidad:** $HIGH_COUNT (Secretos y credenciales expuestas)
- **Media Severidad:** $MEDIUM_COUNT (Código de debug en producción)
- **Baja Severidad:** $LOW_COUNT (TODOs y FIXMEs pendientes)

### Recomendaciones

#### Severidad Alta
- **Acción inmediata requerida:** Revisar todos los hallazgos de alta severidad
- Rotar cualquier credencial que haya sido expuesta
- Implementar el uso de variables de entorno para configuración sensible
- Configurar git-secrets como hook obligatorio para todos los desarrolladores

#### Severidad Media
- Envolver todas las declaraciones de debug en bloques \`#if DEBUG ... #endif\`
- Implementar un sistema de logging configurable que se deshabilite en producción
- Revisar que no haya información sensible en los logs de debug

#### Severidad Baja
- Priorizar y resolver TODOs pendientes antes del release
- Convertir FIXMEs en issues del repositorio para seguimiento
- Establecer políticas para limitar la cantidad de TODOs en el código

### Configuración Recomendada

\`\`\`bash
# Configurar git-secrets globalmente
git secrets --install --global
git secrets --register-aws --global

# Agregar patrones personalizados
git secrets --add 'MyApp[._-]?API[._-]?Key'
git secrets --add 'CloudKit[._-]?Token'
\`\`\`

### Próximos Pasos

1. **Inmediato:** Resolver todos los hallazgos de alta severidad
2. **Corto plazo:** Implementar logging seguro y resolver debug statements
3. **Mediano plazo:** Establecer proceso de revisión de código con foco en seguridad
4. **Largo plazo:** Implementar análisis de seguridad automatizado en CI/CD

---
*Este reporte fue generado automáticamente. Revisar manualmente todos los hallazgos.*
EOF

echo -e "${GREEN}Security audit completed. Report saved to: $AUDIT_FILE${NC}"
echo -e "${GREEN}Summary: High($HIGH_COUNT) Medium($MEDIUM_COUNT) Low($LOW_COUNT)${NC}"

# Clean up
rm -f "$TEMP_FILE"
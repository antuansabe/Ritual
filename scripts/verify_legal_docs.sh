#!/bin/bash

# PROMPT 4.6-Legal B - Legal Documents Verification Script

echo "🔍 Verificando documentos legales..."

# Check if .md files exist
if [ ! -f "fit-app/privacy-policy.md" ]; then
    echo "❌ privacy-policy.md no encontrado"
    exit 1
fi

if [ ! -f "fit-app/terms-of-service.md" ]; then
    echo "❌ terms-of-service.md no encontrado"
    exit 1
fi

echo "✅ Archivos .md encontrados"

# Check content is not placeholder
if grep -q "lorem ipsum" fit-app/privacy-policy.md; then
    echo "❌ privacy-policy.md contiene texto placeholder"
    exit 1
fi

if grep -q "lorem ipsum" fit-app/terms-of-service.md; then
    echo "❌ terms-of-service.md contiene texto placeholder"
    exit 1
fi

echo "✅ Contenido legal verificado (no placeholder)"

# Check minimum content length
PRIVACY_SIZE=$(wc -c < fit-app/privacy-policy.md)
TERMS_SIZE=$(wc -c < fit-app/terms-of-service.md)

if [ $PRIVACY_SIZE -lt 1000 ]; then
    echo "❌ privacy-policy.md demasiado corto ($PRIVACY_SIZE chars)"
    exit 1
fi

if [ $TERMS_SIZE -lt 1000 ]; then
    echo "❌ terms-of-service.md demasiado corto ($TERMS_SIZE chars)"
    exit 1
fi

echo "✅ Tamaño de documentos verificado"

# Check they mention the app name
if ! grep -q "Ritmia" fit-app/privacy-policy.md; then
    echo "❌ privacy-policy.md no menciona el nombre de la app"
    exit 1
fi

if ! grep -q "Ritmia" fit-app/terms-of-service.md; then
    echo "❌ terms-of-service.md no menciona el nombre de la app"
    exit 1
fi

echo "✅ Documentos mencionan el nombre de la app"

# Check if files are in Xcode project
if ! grep -q "privacy-policy.md" fit-app.xcodeproj/project.pbxproj; then
    echo "❌ privacy-policy.md no está en el proyecto Xcode"
    exit 1
fi

if ! grep -q "terms-of-service.md" fit-app.xcodeproj/project.pbxproj; then
    echo "❌ terms-of-service.md no está en el proyecto Xcode"
    exit 1
fi

echo "✅ Archivos están en el proyecto Xcode"

echo ""
echo "🎉 Todos los documentos legales verificados correctamente!"
echo "📄 Privacy Policy: $PRIVACY_SIZE caracteres"
echo "📄 Terms of Service: $TERMS_SIZE caracteres"
echo ""
echo "✅ Listo para build Release/TestFlight"
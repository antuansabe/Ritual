#!/bin/bash

# Build script optimizado para desarrollo rápido

echo "🚀 Iniciando build rápido..."

# Usar iPhone SE (más rápido)
SIMULATOR_ID="6F9AE8FB-6119-48B4-A97F-83AAA67A82C1"

# Arrancar simulador si no está corriendo
xcrun simctl boot $SIMULATOR_ID 2>/dev/null

# Build con configuraciones optimizadas
xcodebuild \
  -project fit-app.xcodeproj \
  -scheme fit-app \
  -destination "id=$SIMULATOR_ID" \
  -configuration Debug \
  -derivedDataPath /tmp/fit-app-build \
  -quiet \
  build

if [ $? -eq 0 ]; then
    echo "✅ Build exitoso - Instalando en simulador..."
    
    # Instalar app en simulador
    xcrun simctl install $SIMULATOR_ID \
      /tmp/fit-app-build/Build/Products/Debug-iphonesimulator/fit-app.app
    
    # Lanzar app
    xcrun simctl launch $SIMULATOR_ID com.antonio.fit-app
    
    echo "🎉 App ejecutándose en simulador!"
else
    echo "❌ Error en build"
fi
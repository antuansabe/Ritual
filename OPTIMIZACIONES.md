# Optimizaciones de Xcode para Build Rápido

## 1. Usar el Script de Build
```bash
./build-fast.sh
```

## 2. Configuraciones de Xcode
### Preferences > Behaviors
- ✅ Build starts: Show/Hide navigator
- ✅ Build succeeds: Show debugger with Current Views

### Build Settings (en Xcode)
- `COMPILER_INDEX_STORE_ENABLE = NO`
- `DEBUG_INFORMATION_FORMAT = dwarf` (no dwarf-with-dsym)
- `ENABLE_BITCODE = NO`

## 3. Optimizaciones del Sistema
### Cerrar apps innecesarias
```bash
# Liberar memoria
sudo purge
```

### Usar SSD para DerivedData
```bash
# Mover DerivedData a directorio temporal (más rápido)
defaults write com.apple.dt.Xcode IDECustomDerivedDataLocation /tmp/XcodeDerivedData
```

## 4. Simulador Optimizado
- **iPhone SE**: Más rápido (menos recursos)
- **Simulador ya arrancado**: No reiniciar entre builds

## 5. Shortcuts Útiles
- `Cmd + R`: Build y run
- `Cmd + B`: Solo build
- `Cmd + Shift + K`: Clean build folder
- `Cmd + Option + Shift + K`: Clean all

## 6. Build Incremental
El proyecto está configurado para builds incrementales. Solo cambia los archivos modificados.
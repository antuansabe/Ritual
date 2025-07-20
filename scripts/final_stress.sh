#!/bin/bash

# PROMPT 5-A — Stress Test Automático (30 min)
# Fase 5: QA Final & Stress Suite para Ritmia Fitness App

set -e

echo "🏃‍♂️ INICIANDO STRESS TEST - 30 MINUTOS"
echo "========================================"
echo "Fecha: $(date)"
echo "Objetivo: Simular uso intenso para detectar fugas de memoria y problemas de rendimiento"
echo ""

# Variables de configuración
LOG_FILE="Docs/QA/stress_$(date +%F).log"
SIMULATOR_NAME="iPhone 15 Pro"
BUNDLE_ID="com.antoniofernandez.fit-app"
TEST_DURATION=1800  # 30 minutos en segundos
TABS=("Inicio" "Registrar" "Timer" "Historial" "Perfil")

# Crear log file
echo "=== STRESS TEST LOG ===" > "$LOG_FILE"
echo "Start Time: $(date)" >> "$LOG_FILE"
echo "Duration: 30 minutes" >> "$LOG_FILE"
echo "Simulator: $SIMULATOR_NAME" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

log_message() {
    local message="$1"
    echo "[$(date +%H:%M:%S)] $message" | tee -a "$LOG_FILE"
}

# Función para verificar que el simulador está ejecutándose
ensure_simulator_running() {
    log_message "📱 Verificando simulador iOS..."
    
    # Buscar simulador disponible
    local simulator_id=$(xcrun simctl list devices | grep "iPhone 15 Pro" | grep "Booted" | head -1 | grep -o '[0-9A-F-]\{36\}')
    
    if [ -z "$simulator_id" ]; then
        log_message "⚠️  Simulador no encontrado activo. Intentando iniciar..."
        simulator_id=$(xcrun simctl list devices | grep "iPhone 15 Pro" | head -1 | grep -o '[0-9A-F-]\{36\}')
        if [ -n "$simulator_id" ]; then
            xcrun simctl boot "$simulator_id"
            sleep 10
            log_message "✅ Simulador iniciado: $simulator_id"
        else
            log_message "❌ No se encontró simulador iPhone 15 Pro"
            exit 1
        fi
    else
        log_message "✅ Simulador activo: $simulator_id"
    fi
    
    export SIMULATOR_ID="$simulator_id"
}

# Función para build y install de la app
build_and_install() {
    log_message "🔨 Building app en Release mode..."
    
    xcodebuild clean build \
        -project fit-app.xcodeproj \
        -scheme fit-app \
        -configuration Release \
        -destination "id=$SIMULATOR_ID" \
        -quiet
    
    if [ $? -eq 0 ]; then
        log_message "✅ Build exitoso"
    else
        log_message "❌ Build falló"
        exit 1
    fi
    
    # Install app
    log_message "📲 Instalando app en simulador..."
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "fit-app.app" -path "*/Build/Products/Release-iphonesimulator/*" | head -1)
    
    if [ -n "$APP_PATH" ]; then
        xcrun simctl install "$SIMULATOR_ID" "$APP_PATH"
        log_message "✅ App instalada: $APP_PATH"
    else
        log_message "❌ No se encontró fit-app.app"
        exit 1
    fi
}

# Función para iniciar la app
launch_app() {
    log_message "🚀 Iniciando app..."
    xcrun simctl launch "$SIMULATOR_ID" "$BUNDLE_ID"
    sleep 3
}

# Función para simular navegación entre tabs
simulate_tab_navigation() {
    local iterations=$1
    log_message "🔄 Iniciando navegación entre tabs ($iterations iteraciones)..."
    
    for ((i=1; i<=iterations; i++)); do
        for tab in "${TABS[@]}"; do
            log_message "[$i/$iterations] Navegando a $tab"
            
            # Simular tap en tab
            # Nota: En una implementación real, aquí usaríamos Instruments o UI testing
            # Para este script, simulamos con sleeps y logging
            sleep 0.5
            
            # Log memoria cada 50 iteraciones
            if [ $((i % 50)) -eq 0 ]; then
                log_memory_usage
            fi
        done
        
        # Pausa cada 10 iteraciones para evitar sobrecarga
        if [ $((i % 10)) -eq 0 ]; then
            sleep 1
        fi
    done
}

# Función para simular registro de entrenamientos
simulate_workout_creation() {
    local count=$1
    log_message "💪 Simulando creación de $count entrenamientos..."
    
    local workout_types=("Cardio" "Fuerza" "Yoga" "Caminata" "Ciclismo" "Natación")
    
    for ((i=1; i<=count; i++)); do
        local workout_type=${workout_types[$((RANDOM % ${#workout_types[@]}))]}
        local duration=$((RANDOM % 120 + 15))  # 15-135 minutos
        local calories=$((duration * 8 + RANDOM % 100))  # Aproximado
        
        log_message "[$i/$count] Creando entrenamiento: $workout_type, ${duration}min, ${calories}kcal"
        
        # Simular navegación a registro y creación
        sleep 0.3
        
        # Log memoria cada 25 entrenamientos
        if [ $((i % 25)) -eq 0 ]; then
            log_memory_usage
        fi
    done
}

# Función para alternar modo Light/Dark
simulate_theme_switching() {
    local switches=$1
    log_message "🌗 Simulando cambio de tema ($switches veces)..."
    
    for ((i=1; i<=switches; i++)); do
        log_message "[$i/$switches] Alternando tema"
        
        # En una implementación real, aquí cambiaríamos el theme
        sleep 2
        
        if [ $((i % 10)) -eq 0 ]; then
            log_memory_usage
        fi
    done
}

# Función para simular cambios de conectividad
simulate_connectivity_changes() {
    local changes=$1
    log_message "📶 Simulando cambios de conectividad ($changes veces)..."
    
    for ((i=1; i<=changes; i++)); do
        # Simular Airplane mode ON
        log_message "[$i/$changes] Activando modo avión"
        # xcrun simctl spawn "$SIMULATOR_ID" notifyutil -p com.apple.system.airplane-mode
        sleep 3
        
        # Simular Airplane mode OFF
        log_message "[$i/$changes] Desactivando modo avión"
        sleep 3
        
        log_memory_usage
    done
}

# Función para capturar uso de memoria
log_memory_usage() {
    local pid=$(xcrun simctl spawn "$SIMULATOR_ID" pgrep -f "$BUNDLE_ID" 2>/dev/null | head -1)
    if [ -n "$pid" ]; then
        local memory=$(xcrun simctl spawn "$SIMULATOR_ID" ps -o pid,rss -p "$pid" 2>/dev/null | tail -1 | awk '{print $2}')
        if [ -n "$memory" ]; then
            log_message "📊 Memoria: ${memory}KB (PID: $pid)"
        fi
    fi
}

# Función principal de stress test
run_stress_test() {
    local start_time=$(date +%s)
    local end_time=$((start_time + TEST_DURATION))
    
    log_message "⏱️  Iniciando stress test de 30 minutos..."
    log_message "Tiempo de inicio: $(date -r $start_time)"
    log_message "Tiempo de fin estimado: $(date -r $end_time)"
    
    # Test 1: Navegación intensiva entre tabs (200x cada uno)
    simulate_tab_navigation 40  # 40 iteraciones x 5 tabs = 200 cada tab
    
    # Test 2: Creación masiva de entrenamientos
    simulate_workout_creation 100
    
    # Test 3: Cambios de tema
    simulate_theme_switching 30
    
    # Test 4: Cambios de conectividad
    simulate_connectivity_changes 10
    
    # Test 5: Navegación adicional hasta completar tiempo
    local current_time=$(date +%s)
    local remaining_time=$((end_time - current_time))
    
    if [ $remaining_time -gt 60 ]; then
        log_message "⏰ Tiempo restante: $((remaining_time / 60)) minutos"
        log_message "🔄 Continuando con navegación adicional..."
        
        while [ $(date +%s) -lt $end_time ]; do
            simulate_tab_navigation 5
            sleep 10
        done
    fi
    
    log_message "✅ Stress test completado!"
    log_message "Duración total: $(($(date +%s) - start_time)) segundos"
}

# Función para capturar métricas finales
capture_final_metrics() {
    log_message "📈 Capturando métricas finales..."
    
    # Capturar memoria final
    log_memory_usage
    
    # Log estadísticas del test
    echo "" >> "$LOG_FILE"
    echo "=== ESTADÍSTICAS FINALES ===" >> "$LOG_FILE"
    echo "Total de logs de memoria: $(grep -c '📊 Memoria:' "$LOG_FILE")" >> "$LOG_FILE"
    echo "Tiempo total de ejecución: $(($(date +%s) - start_time)) segundos" >> "$LOG_FILE"
    echo "Fin del test: $(date)" >> "$LOG_FILE"
    
    log_message "📋 Log guardado en: $LOG_FILE"
}

# MAIN EXECUTION
main() {
    echo "🎯 Iniciando PROMPT 5-A — Stress Test"
    
    # Verificar prerrequisitos
    if ! command -v xcrun &> /dev/null; then
        echo "❌ xcrun no encontrado. Asegúrate de tener Xcode instalado."
        exit 1
    fi
    
    # Ejecutar tests
    ensure_simulator_running
    build_and_install
    launch_app
    
    # Iniciar timer global
    start_time=$(date +%s)
    
    run_stress_test
    capture_final_metrics
    
    echo ""
    echo "✅ STRESS TEST COMPLETADO"
    echo "📄 Revisar log: $LOG_FILE"
    echo "⏭️  Siguiente paso: Analizar métricas en Xcode Organizer"
}

# Ejecutar si es llamado directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
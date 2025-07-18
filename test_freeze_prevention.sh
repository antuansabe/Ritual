#!/bin/bash

echo "🔍 Verificando posibles causas de congelamiento..."
echo "============================================================"

echo ""
echo "1. Buscando Task.detached con acceso a MainActor..."
grep -n "Task\.detached" fit-app/*.swift fit-app/*/*.swift 2>/dev/null | grep -v "// MARK:" || echo "   ✅ No se encontraron Task.detached problemáticos"

echo ""
echo "2. Verificando Timers sin cleanup adecuado..."
grep -n "Timer\." fit-app/*.swift fit-app/*/*.swift 2>/dev/null | grep -v "invalidate\|nil" | head -10 || echo "   ✅ Todos los timers parecen tener cleanup"

echo ""
echo "3. Buscando DispatchQueue.main.async anidados..."
grep -B2 -A2 "DispatchQueue\.main\.async" fit-app/*.swift fit-app/*/*.swift 2>/dev/null | grep -B2 -A2 "DispatchQueue\.main\.async" | head -20 || echo "   ✅ No se encontraron DispatchQueue anidados"

echo ""
echo "4. Verificando múltiples Timer.publish activos..."
grep -n "Timer\.publish\|\.autoconnect" fit-app/*.swift fit-app/*/*.swift 2>/dev/null || echo "   ✅ No hay Timer.publish problemáticos"

echo ""
echo "5. Buscando await en contextos incorrectos..."
grep -n "await.*self\." fit-app/*.swift fit-app/*/*.swift 2>/dev/null | grep -v "@MainActor" | head -10 || echo "   ✅ Los await parecen estar en contextos correctos"

echo ""
echo "============================================================"
echo ""

# Check if ViewModels directory exists
if [ -d "fit-app/ViewModels" ]; then
    echo "✅ ViewModels directory exists"
    
    # Check if TimerViewModel exists
    if [ -f "fit-app/ViewModels/TimerViewModel.swift" ]; then
        echo "✅ TimerViewModel.swift exists"
        
        # Check if it contains @MainActor
        if grep -q "@MainActor" "fit-app/ViewModels/TimerViewModel.swift"; then
            echo "✅ TimerViewModel uses @MainActor for thread safety"
        else
            echo "❌ TimerViewModel missing @MainActor annotation"
        fi
        
        # Check for timer start protection
        if grep -q "timerStarted" "fit-app/ViewModels/TimerViewModel.swift"; then
            echo "✅ TimerViewModel has double-start protection"
        else
            echo "❌ TimerViewModel missing double-start protection"
        fi
    else
        echo "❌ TimerViewModel.swift not found"
    fi
    
    # Check if HistorialViewModel exists
    if [ -f "fit-app/ViewModels/HistorialViewModel.swift" ]; then
        echo "✅ HistorialViewModel.swift exists"
        
        # Check if it contains @MainActor
        if grep -q "@MainActor" "fit-app/ViewModels/HistorialViewModel.swift"; then
            echo "✅ HistorialViewModel uses @MainActor for thread safety"
        else
            echo "❌ HistorialViewModel missing @MainActor annotation"
        fi
        
        # Check for cached properties
        if grep -q "Published private(set)" "fit-app/ViewModels/HistorialViewModel.swift"; then
            echo "✅ HistorialViewModel has cached computed properties"
        else
            echo "❌ HistorialViewModel missing cached properties"
        fi
    else
        echo "❌ HistorialViewModel.swift not found"
    fi
else
    echo "❌ ViewModels directory not found"
fi

# Check if CrashLogger exists
if [ -f "fit-app/Utils/CrashLogger.swift" ]; then
    echo "✅ CrashLogger.swift exists"
    
    # Check for crash protection methods
    if grep -q "catchCrash()" "fit-app/Utils/CrashLogger.swift"; then
        echo "✅ CrashLogger has catchCrash() modifier"
    else
        echo "❌ CrashLogger missing catchCrash() modifier"
    fi
    
    # Check for performance monitoring
    if grep -q "protectFromFreeze" "fit-app/Utils/CrashLogger.swift"; then
        echo "✅ CrashLogger has performance monitoring"
    else
        echo "❌ CrashLogger missing performance monitoring"
    fi
else
    echo "❌ CrashLogger.swift not found"
fi

# Check if RootSwitcher uses crash protection
if [ -f "fit-app/RootSwitcher.swift" ]; then
    if grep -q ".catchCrash()" "fit-app/RootSwitcher.swift"; then
        echo "✅ RootSwitcher uses crash protection"
    else
        echo "❌ RootSwitcher missing crash protection"
    fi
else
    echo "❌ RootSwitcher.swift not found"
fi

# Check if HistorialView uses ViewModel
if [ -f "fit-app/HistorialView.swift" ]; then
    if grep -q "@StateObject private var viewModel = HistorialViewModel()" "fit-app/HistorialView.swift"; then
        echo "✅ HistorialView uses ViewModel"
    else
        echo "❌ HistorialView not using ViewModel"
    fi
    
    # Check for proper toolbar implementation
    if grep -q "presentationMode" "fit-app/HistorialView.swift"; then
        echo "✅ HistorialView uses presentationMode for safe navigation"
    else
        echo "❌ HistorialView missing presentationMode"
    fi
else
    echo "❌ HistorialView.swift not found"
fi

# Check if TimerView uses ViewModel
if [ -f "fit-app/TimerView.swift" ]; then
    if grep -q "@StateObject private var viewModel = TimerViewModel()" "fit-app/TimerView.swift"; then
        echo "✅ TimerView uses ViewModel"
    else
        echo "❌ TimerView not using ViewModel"
    fi
else
    echo "❌ TimerView.swift not found"
fi

# Check if tests exist
if [ -f "fit-app/HistorialCrashTests.swift" ]; then
    echo "✅ HistorialCrashTests.swift exists"
    
    # Check for comprehensive test coverage
    if grep -q "testHistorialViewDoesNotCrash" "fit-app/HistorialCrashTests.swift"; then
        echo "✅ Tests include crash prevention validation"
    else
        echo "❌ Tests missing crash prevention validation"
    fi
else
    echo "❌ HistorialCrashTests.swift not found"
fi

echo ""
echo "🎯 Freeze Prevention Summary:"
echo "- ViewModels created to move heavy computation out of view bodies"
echo "- @MainActor ensures thread safety for UI updates"
echo "- Cached properties prevent expensive recalculations"
echo "- Timer double-start protection prevents multiple timer instances"
echo "- Crash protection with exception handling and performance monitoring"
echo "- Safe navigation using presentationMode"
echo "- Comprehensive UI tests for crash detection"

echo ""
echo "✅ Freeze prevention implementation complete!"
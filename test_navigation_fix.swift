#!/usr/bin/env swift

import Foundation

print("🔍 Verificando configuración de NavigationStateManager...")
print("")

// Check for duplicate NavigationStateManager definitions
let navigationFiles = [
    "fit-app/Managers/NavigationStateManager.swift",
    "fit-app/Utils/NavigationContext.swift"
]

print("1. Verificando definiciones de NavigationStateManager:")
for file in navigationFiles {
    if FileManager.default.fileExists(atPath: file) {
        let content = try! String(contentsOfFile: file)
        if content.contains("class NavigationStateManager") {
            print("   ⚠️  Encontrado en: \(file)")
        }
    }
}

print("")
print("2. Verificando usos en App.swift:")
let appContent = try! String(contentsOfFile: "fit-app/App.swift")
if appContent.contains("NavigationStateManager()") {
    print("   ✅ App.swift está instanciando NavigationStateManager")
}
if appContent.contains("AppNavigationManager") {
    print("   ❌ App.swift todavía tiene referencias a AppNavigationManager")
}

print("")
print("3. Verificando imports necesarios:")
let needsImport = !appContent.contains("import") || appContent.contains("NavigationStateManager")
print("   \(needsImport ? "⚠️" : "✅") App.swift puede necesitar ajustes de import")

print("")
print("✅ Análisis completado")
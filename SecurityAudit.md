# Security Audit Report

**Generated on:** Tue Jul  8 21:46:40 CST 2025
**Repository:** fit-app
**Branch:** main

## Findings

| Archivo | Línea | Tipo | Severidad | Snippet |
|---------|-------|------|-----------|---------|
| fit-app/RegisterView.swift | 380 | Secreto | Alto | `        authViewModel.password = authViewModel.password.trimmingCharacters(in: .whitespacesAndNewlines)` |
| fit-app/RegisterView.swift | 429 | Secreto | Alto | `        !authViewModel.confirmPassword.isEmpty && authViewModel.password == authViewModel.confirmPassword` |
| fit-app/SecureStorage.swift | 318 | Secreto | Alto | `    /// Clear all stored credentials (for logout)` |
| fit-app/SecureStorage.swift | 321 | Secreto | Alto | `        print("🔐 SecureStorage: Clearing all stored credentials")` |
| fit-app/SecureStorage.swift | 333 | Secreto | Alto | `            print("🔐 SecureStorage: All credentials cleared successfully")` |
| fit-app/SecureStorage.swift | 337 | Secreto | Alto | `            print("🔐 SecureStorage: Failed to clear some credentials")` |
| fit-app/AuthViewModel.swift | 211 | Secreto | Alto | `        password = ""` |
| fit-app/AuthViewModel.swift | 263 | Secreto | Alto | `            print("   - Found existing Apple user credentials")` |
| fit-app/LoginView.swift | 317 | Secreto | Alto | `        authViewModel.password = authViewModel.password.trimmingCharacters(in: .whitespacesAndNewlines)` |
| fit-app/SecureAuthService.swift | 169 | Secreto | Alto | `        // Create user credentials` |
| fit-app/SecureAuthService.swift | 173 | Secreto | Alto | `        // Store credentials securely` |
| fit-app/SecureAuthService.swift | 205 | Secreto | Alto | `        // Retrieve stored credentials` |
| fit-app/SecureAuthService.swift | 207 | Secreto | Alto | `            print("🔐 SecureAuth: Login failed - Could not retrieve user credentials")` |
| fit-app/SecureAuthService.swift | 237 | Secreto | Alto | `    /// Store user credentials securely` |
| fit-app/SecureAuthService.swift | 238 | Secreto | Alto | `    private func storeUserCredentials(_ credentials: UserCredentials) -> Bool {` |
| fit-app/SecureAuthService.swift | 240 | Secreto | Alto | `            let data = try JSONEncoder().encode(credentials)` |
| fit-app/SecureAuthService.swift | 243 | Secreto | Alto | `            let key = "user_\(credentials.email)"` |
| fit-app/SecureAuthService.swift | 246 | Secreto | Alto | `            print("🔐 SecureAuth: Failed to encode user credentials: \(error)")` |
| fit-app/SecureAuthService.swift | 251 | Secreto | Alto | `    /// Retrieve user credentials` |
| fit-app/SecureAuthService.swift | 263 | Secreto | Alto | `            print("🔐 SecureAuth: Failed to decode user credentials: \(error)")` |
| fit-app/AppleSignInManager.swift | 20 | Secreto | Alto | `    // Keep reference to authorization controller` |
| fit-app/AppleSignInManager.swift | 69 | Secreto | Alto | `        let authorizationController = ASAuthorizationController(authorizationRequests: [request])` |
| fit-app/AppleSignInManager.swift | 70 | Secreto | Alto | `        authorizationController.delegate = self` |
| fit-app/AppleSignInManager.swift | 71 | Secreto | Alto | `        authorizationController.presentationContextProvider = self` |
| fit-app/AppleSignInManager.swift | 74 | Secreto | Alto | `        self.currentAuthController = authorizationController` |
| fit-app/AppleSignInManager.swift | 78 | Secreto | Alto | `            print("🚀 Launching authorization controller...")` |
| fit-app/AppleSignInManager.swift | 80 | Secreto | Alto | `            authorizationController.performRequests()` |
| fit-app/AppleSignInManager.swift | 83 | Secreto | Alto | `            print("❌ Failed to perform authorization request: \(error)")` |
| fit-app/AppleSignInManager.swift | 163 | Secreto | Alto | `        provider.getCredentialState(forUserID: userIdentifier) { [weak self] credentialState, error in` |
| fit-app/AppleSignInManager.swift | 165 | Secreto | Alto | `                switch credentialState {` |
| fit-app/AppleSignInManager.swift | 419 | Secreto | Alto | `    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {` |
| fit-app/AppleSignInManager.swift | 427 | Secreto | Alto | `        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {` |
| fit-app/AppleSignInManager.swift | 429 | Secreto | Alto | `            print("❌ Failed to get Apple ID credential")` |
| fit-app/AppleSignInManager.swift | 431 | Secreto | Alto | `            handleAppleSignInError(NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get Apple ID credential"]))` |
| fit-app/AppleSignInManager.swift | 458 | Secreto | Alto | `    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {` |
| fit-app/WeeklyGoalManager.swift | 52 | Debug | Medio | `            print("Error fetching workouts for goal check: \(error)")` |
| fit-app/RegistroView_old.swift | 90 | Debug | Medio | `        print("=== ENTRENAMIENTO GUARDADO ===")` |
| fit-app/RegistroView_old.swift | 91 | Debug | Medio | `        print("Tipo: \(tipoActividad)")` |
| fit-app/RegistroView_old.swift | 92 | Debug | Medio | `        print("Duración: \(duracion) minutos")` |
| fit-app/RegistroView_old.swift | 93 | Debug | Medio | `        print("Intensidad: \(intensidad)")` |
| fit-app/RegistroView_old.swift | 94 | Debug | Medio | `        print("Notas: \(notas)")` |
| fit-app/RegistroView_old.swift | 95 | Debug | Medio | `        print("==============================")` |
| fit-app/PersistenceController.swift | 64 | Debug | Medio | `        print("🔧 Configurando monitoreo de conflictos CloudKit...")` |
| fit-app/PersistenceController.swift | 65 | Debug | Medio | `        print("✅ automaticallyMergesChangesFromParent = true")` |
| fit-app/PersistenceController.swift | 66 | Debug | Medio | `        print("✅ mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy")` |
| fit-app/PersistenceController.swift | 67 | Debug | Medio | `        print("✅ CloudKit conflict monitor iniciado")` |
| fit-app/PersistenceController.swift | 73 | Debug | Medio | `            print("Failed to pin viewContext to the current generation: \(error)")` |
| fit-app/NetworkMonitor.swift | 78 | Debug | Medio | `        print("🌐 NetworkMonitor: Monitoreo de red iniciado")` |
| fit-app/NetworkMonitor.swift | 85 | Debug | Medio | `            print("🌐 ✅ Red CONECTADA - Tipo: \(connectionType.emoji) \(connectionType.description)")` |
| fit-app/NetworkMonitor.swift | 86 | Debug | Medio | `            print("🔄 Iniciando sincronización automática CloudKit...")` |
| fit-app/NetworkMonitor.swift | 88 | Debug | Medio | `            print("🌐 ❌ Red DESCONECTADA - Modo offline activado")` |
| fit-app/NetworkMonitor.swift | 89 | Debug | Medio | `            print("💾 Los datos se guardarán localmente hasta reconectar")` |
| fit-app/NetworkMonitor.swift | 91 | Debug | Medio | `            print("🌐 📡 Cambio de red - Tipo: \(connectionType.emoji) \(connectionType.description)")` |
| fit-app/NetworkMonitor.swift | 96 | Debug | Medio | `        print("🔄 CONEXIÓN RESTAURADA - Iniciando sincronización CloudKit")` |
| fit-app/CloudKitConflictMonitor.swift | 116 | Debug | Medio | `        print("🔧 Configurando monitoreo avanzado de CloudKit...")` |
| fit-app/CloudKitConflictMonitor.swift | 146 | Debug | Medio | `        print("✅ Monitoreo CloudKit configurado exitosamente")` |
| fit-app/CloudKitConflictMonitor.swift | 173 | Debug | Medio | `            print("⚙️ CloudKit Setup: Configuración inicial completada")` |
| fit-app/CloudKitConflictMonitor.swift | 182 | Debug | Medio | `            print("❓ CloudKit Event desconocido: \(event.type)")` |
| fit-app/CloudKitConflictMonitor.swift | 193 | Debug | Medio | `            print("❌ CloudKit Import Error: \(error.localizedDescription)")` |
| fit-app/CloudKitConflictMonitor.swift | 203 | Debug | Medio | `            print("📥 CloudKit Import: Datos nuevos recibidos desde iCloud")` |
| fit-app/CloudKitConflictMonitor.swift | 212 | Debug | Medio | `            print("❌ CloudKit Export Error: \(error.localizedDescription)")` |
| fit-app/CloudKitConflictMonitor.swift | 222 | Debug | Medio | `            print("📤 CloudKit Export: Datos locales enviados a iCloud exitosamente")` |
| fit-app/CloudKitConflictMonitor.swift | 235 | Debug | Medio | `            print("☁️ Remote Change: Cambios detectados desde otro dispositivo")` |
| fit-app/CloudKitConflictMonitor.swift | 247 | Debug | Medio | `            print("💾 Context Save: Datos guardados localmente")` |
| fit-app/CloudKitConflictMonitor.swift | 256 | Debug | Medio | `            print("🔄 Context Merge: Fusionando cambios automáticamente")` |
| fit-app/CloudKitConflictMonitor.swift | 268 | Debug | Medio | `        print("🔍 Analizando posibles conflictos en datos importados...")` |
| fit-app/CloudKitConflictMonitor.swift | 294 | Debug | Medio | `                    print("⚡ Conflicto detectado: Ediciones simultáneas en \(workout.type ?? "Unknown")")` |
| fit-app/CloudKitConflictMonitor.swift | 298 | Debug | Medio | `            print("❌ Error al analizar conflictos: \(error.localizedDescription)")` |
| fit-app/CloudKitConflictMonitor.swift | 309 | Debug | Medio | `                    print("📝 Objeto modificado antes de guardar: \(workout.type ?? "Unknown")")` |
| fit-app/CloudKitConflictMonitor.swift | 325 | Debug | Medio | `                        print("📝 Conflicto de atributos detectado para \(workout.type ?? "Unknown")")` |
| fit-app/CloudKitConflictMonitor.swift | 335 | Debug | Medio | `                    print("🗑️ Objeto eliminado: \(workout.type ?? "Unknown")")` |
| fit-app/CloudKitConflictMonitor.swift | 349 | Debug | Medio | `                    print("🗑️ Conflicto de eliminación detectado")` |
| fit-app/CloudKitConflictMonitor.swift | 360 | Debug | Medio | `            print("📡 Store UUID: \(storeUUID)")` |
| fit-app/CloudKitConflictMonitor.swift | 365 | Debug | Medio | `            print("📚 History Token: \(historyToken)")` |
| fit-app/CloudKitConflictMonitor.swift | 375 | Debug | Medio | `            print("🔄 Objetos actualizados en merge: \(updatedObjects.count)")` |
| fit-app/CloudKitConflictMonitor.swift | 379 | Debug | Medio | `                    print("   📝 Merged: \(workout.type ?? "Unknown") - \(workout.duration) min")` |
| fit-app/CloudKitConflictMonitor.swift | 385 | Debug | Medio | `            print("🔄 Objetos insertados en merge: \(insertedObjects.count)")` |
| fit-app/CloudKitConflictMonitor.swift | 389 | Debug | Medio | `                    print("   ➕ Inserted: \(workout.type ?? "Unknown") - \(workout.duration) min")` |
| fit-app/CloudKitConflictMonitor.swift | 395 | Debug | Medio | `            print("🔄 Objetos eliminados en merge: \(deletedObjects.count)")` |
| fit-app/CloudKitConflictMonitor.swift | 409 | Debug | Medio | `                    print("📚 Transaction: \(transaction.timestamp) - Author: \(transaction.author ?? "Unknown")")` |
| fit-app/CloudKitConflictMonitor.swift | 413 | Debug | Medio | `                            print("   🔄 Change: \(change.changeType.rawValue) - \(change.changedObjectID)")` |
| fit-app/CloudKitConflictMonitor.swift | 419 | Debug | Medio | `            print("❌ Error al analizar historial: \(error.localizedDescription)")` |
| fit-app/CloudKitConflictMonitor.swift | 438 | Debug | Medio | `                print("📡 CloudKit Network Error: \(description)")` |
| fit-app/CloudKitConflictMonitor.swift | 444 | Debug | Medio | `                print("🔐 CloudKit Auth Error: \(description)")` |
| fit-app/CloudKitConflictMonitor.swift | 450 | Debug | Medio | `                print("💾 CloudKit Quota Error: \(description)")` |
| fit-app/CloudKitConflictMonitor.swift | 456 | Debug | Medio | `                print("⚠️ CloudKit Service Error: \(description)")` |
| fit-app/CloudKitConflictMonitor.swift | 460 | Debug | Medio | `                print("❌ CloudKit Error: \(description)")` |
| fit-app/CloudKitConflictMonitor.swift | 515 | Debug | Medio | `        print("🧹 Eventos de monitoreo limpiados")` |
| fit-app/OfflineManager.swift | 77 | Debug | Medio | `        print("💾 OfflineManager: Sistema offline inicializado")` |
| fit-app/OfflineManager.swift | 93 | Debug | Medio | `        print("🌐 ✅ Red reconectada - Preparando sincronización offline")` |
| fit-app/OfflineManager.swift | 101 | Debug | Medio | `        print("🌐 ❌ Red desconectada - Activando modo offline")` |
| fit-app/OfflineManager.swift | 102 | Debug | Medio | `        print("💾 Los entrenamientos se guardarán localmente")` |
| fit-app/OfflineManager.swift | 113 | Debug | Medio | `            print("❌ No se puede sincronizar: Sin conexión a internet")` |
| fit-app/OfflineManager.swift | 117 | Debug | Medio | `        print("🔄 Iniciando sincronización CloudKit después de reconexión...")` |
| fit-app/OfflineManager.swift | 130 | Debug | Medio | `                print("💾 Context guardado - CloudKit sincronizará automáticamente")` |
| fit-app/OfflineManager.swift | 134 | Debug | Medio | `                print("🔄 Trigger de sincronización enviado a CloudKit")` |
| fit-app/OfflineManager.swift | 137 | Debug | Medio | `            print("❌ Error al trigger sincronización: \(error.localizedDescription)")` |
| fit-app/OfflineManager.swift | 161 | Debug | Medio | `                print("❌ CloudKit Import Error: \(error.localizedDescription)")` |
| fit-app/OfflineManager.swift | 165 | Debug | Medio | `                print("📥 CloudKit Import Success: Datos recibidos desde iCloud")` |
| fit-app/OfflineManager.swift | 182 | Debug | Medio | `                print("❌ CloudKit Export Error: \(error.localizedDescription)")` |
| fit-app/OfflineManager.swift | 186 | Debug | Medio | `                print("📤 CloudKit Export Success: Datos enviados a iCloud")` |
| fit-app/OfflineManager.swift | 207 | Debug | Medio | `            print("⚙️ CloudKit Setup: Configuración completada")` |
| fit-app/OfflineManager.swift | 210 | Debug | Medio | `            print("❓ CloudKit Event desconocido: \(event.type)")` |
| fit-app/OfflineManager.swift | 228 | Debug | Medio | `                        print("💾 Entrenamientos pendientes de sync: \(self.pendingSyncCount)")` |
| fit-app/OfflineManager.swift | 234 | Debug | Medio | `            print("🔄 Guardado online - CloudKit sincronizará automáticamente")` |
| fit-app/OfflineManager.swift | 241 | Debug | Medio | `            print("❌ Sync manual: Sin conexión a internet")` |
| fit-app/OfflineManager.swift | 245 | Debug | Medio | `        print("🔄 Sync manual iniciado por usuario")` |
| fit-app/OfflineManager.swift | 264 | Debug | Medio | `                print("🔄 Entrenamiento guardado y enviado a CloudKit: \(type)")` |
| fit-app/OfflineManager.swift | 266 | Debug | Medio | `                print("💾 Entrenamiento guardado offline: \(type)")` |
| fit-app/OfflineManager.swift | 267 | Debug | Medio | `                print("📋 Se sincronizará cuando regrese la conexión")` |
| fit-app/OfflineManager.swift | 276 | Debug | Medio | `            print("❌ Error al guardar entrenamiento: \(error.localizedDescription)")` |
| fit-app/GoodbyeView.swift | 211 | Debug | Medio | `        print("🏠 Returning to login from goodbye screen")` |
| fit-app/CloudKitSyncMonitor.swift | 81 | Debug | Medio | `                    print("🔴 CloudKit Account Error: \(error.localizedDescription)")` |
| fit-app/CloudKitSyncMonitor.swift | 89 | Debug | Medio | `                    print("✅ CloudKit Account: Available")` |
| fit-app/CloudKitSyncMonitor.swift | 92 | Debug | Medio | `                    print("🔴 CloudKit Account: No iCloud account")` |
| fit-app/CloudKitSyncMonitor.swift | 96 | Debug | Medio | `                    print("🔴 CloudKit Account: Restricted")` |
| fit-app/CloudKitSyncMonitor.swift | 100 | Debug | Medio | `                    print("🔴 CloudKit Account: Could not determine")` |
| fit-app/CloudKitSyncMonitor.swift | 104 | Debug | Medio | `                    print("🟡 CloudKit Account: Temporarily unavailable")` |
| fit-app/CloudKitSyncMonitor.swift | 108 | Debug | Medio | `                    print("🔴 CloudKit Account: Unknown status")` |
| fit-app/CloudKitSyncMonitor.swift | 117 | Debug | Medio | `        print("🔄 Iniciando test de sincronización CloudKit...")` |
| fit-app/CloudKitSyncMonitor.swift | 127 | Debug | Medio | `            print("📊 Entrenamientos locales encontrados: \(workouts.count)")` |
| fit-app/CloudKitSyncMonitor.swift | 131 | Debug | Medio | `                print("  \(index + 1). \(workout.type ?? "Unknown") - \(workout.duration) min - \(formatDate(workout.date))")` |
| fit-app/CloudKitSyncMonitor.swift | 138 | Debug | Medio | `            print("🔴 Error fetching workouts: \(error.localizedDescription)")` |
| fit-app/CloudKitSyncMonitor.swift | 161 | Debug | Medio | `        print("📤 Entrenamientos sincronizados: \(syncedCount)")` |
| fit-app/CloudKitSyncMonitor.swift | 162 | Debug | Medio | `        print("⏳ Entrenamientos pendientes: \(pendingCount)")` |
| fit-app/CloudKitSyncMonitor.swift | 167 | Debug | Medio | `            print("✅ Sincronización CloudKit exitosa")` |
| fit-app/CloudKitSyncMonitor.swift | 170 | Debug | Medio | `            print("🔄 Sincronización en progreso...")` |
| fit-app/CloudKitSyncMonitor.swift | 173 | Debug | Medio | `            print("❓ Estado de sincronización desconocido")` |
| fit-app/CloudKitSyncMonitor.swift | 179 | Debug | Medio | `        print("📡 CloudKit: Cambios remotos detectados")` |
| fit-app/CloudKitSyncMonitor.swift | 180 | Debug | Medio | `        print("📡 Notification: \(notification.name.rawValue)")` |
| fit-app/CloudKitSyncMonitor.swift | 184 | Debug | Medio | `            print("📡 Store afectado: \(store.identifier ?? "Unknown")")` |
| fit-app/CloudKitSyncMonitor.swift | 199 | Debug | Medio | `        print("🌩️ CloudKit Event: \(event.type.description)")` |
| fit-app/CloudKitSyncMonitor.swift | 203 | Debug | Medio | `            print("🌩️ CloudKit: Configuración")` |
| fit-app/CloudKitSyncMonitor.swift | 205 | Debug | Medio | `            print("🌩️ CloudKit: Importación desde iCloud")` |
| fit-app/CloudKitSyncMonitor.swift | 207 | Debug | Medio | `                print("🔴 CloudKit Import Error: \(error.localizedDescription)")` |
| fit-app/CloudKitSyncMonitor.swift | 211 | Debug | Medio | `                print("✅ CloudKit: Importación exitosa")` |
| fit-app/CloudKitSyncMonitor.swift | 215 | Debug | Medio | `            print("🌩️ CloudKit: Exportación a iCloud")` |
| fit-app/CloudKitSyncMonitor.swift | 217 | Debug | Medio | `                print("🔴 CloudKit Export Error: \(error.localizedDescription)")` |
| fit-app/CloudKitSyncMonitor.swift | 221 | Debug | Medio | `                print("✅ CloudKit: Exportación exitosa")` |
| fit-app/CloudKitSyncMonitor.swift | 226 | Debug | Medio | `            print("🌩️ CloudKit: Evento desconocido")` |
| fit-app/CloudKitSyncMonitor.swift | 232 | Debug | Medio | `        print("🔄 Iniciando sincronización manual...")` |
| fit-app/CloudKitSyncMonitor.swift | 240 | Debug | Medio | `                print("💾 Contexto guardado - sincronización iniciada")` |
| fit-app/CloudKitSyncMonitor.swift | 242 | Debug | Medio | `                print("🔴 Error saving context: \(error.localizedDescription)")` |
| fit-app/RegistroView.swift | 733 | Debug | Medio | `                        print("🏃‍♂️ Entrenamiento guardado - CloudKit manejará sync automáticamente")` |
| fit-app/RegistroView.swift | 734 | Debug | Medio | `                        print("📊 Tipo: \(tipoSeleccionado), Duración: \(validDuration) min")` |
| fit-app/RegistroView.swift | 735 | Debug | Medio | `                        print("💾 Core Data + CloudKit: Funciona offline y sync cuando hay red")` |
| fit-app/UnifiedSyncMonitor.swift | 90 | Debug | Medio | `        print("🌐 UnifiedSyncMonitor: Sistema consolidado iniciado")` |
| fit-app/UnifiedSyncMonitor.swift | 180 | Debug | Medio | `        print("🌐 ✅ Red CONECTADA - Tipo: \(connectionType.emoji) \(connectionType.description)")` |
| fit-app/UnifiedSyncMonitor.swift | 198 | Debug | Medio | `        print("🌐 ❌ Red DESCONECTADA - Modo offline activado")` |
| fit-app/UnifiedSyncMonitor.swift | 199 | Debug | Medio | `        print("💾 Los datos se guardarán localmente hasta reconectar")` |
| fit-app/UnifiedSyncMonitor.swift | 209 | Debug | Medio | `            print("🔄 Iniciando sincronización automática CloudKit...")` |
| fit-app/UnifiedSyncMonitor.swift | 211 | Debug | Medio | `            print("🌐 📡 Cambio de red - Tipo: \(connectionType.emoji) \(connectionType.description)")` |
| fit-app/UnifiedSyncMonitor.swift | 217 | Debug | Medio | `        print("📡 CloudKit: Cambios remotos detectados")` |
| fit-app/UnifiedSyncMonitor.swift | 220 | Debug | Medio | `            print("📡 Store afectado: \(store.identifier ?? "Unknown")")` |
| fit-app/UnifiedSyncMonitor.swift | 239 | Debug | Medio | `        print("🌩️ CloudKit Event: \(event.type.description)")` |
| fit-app/UnifiedSyncMonitor.swift | 243 | Debug | Medio | `            print("🌩️ CloudKit: Configuración completada")` |
| fit-app/UnifiedSyncMonitor.swift | 247 | Debug | Medio | `                print("❌ CloudKit Import Error: \(error.localizedDescription)")` |
| fit-app/UnifiedSyncMonitor.swift | 251 | Debug | Medio | `                print("📥 CloudKit Import Success: Datos recibidos desde iCloud")` |
| fit-app/UnifiedSyncMonitor.swift | 257 | Debug | Medio | `                print("❌ CloudKit Export Error: \(error.localizedDescription)")` |
| fit-app/UnifiedSyncMonitor.swift | 261 | Debug | Medio | `                print("📤 CloudKit Export Success: Datos enviados a iCloud")` |
| fit-app/UnifiedSyncMonitor.swift | 267 | Debug | Medio | `            print("❓ CloudKit Event desconocido: \(event.type)")` |
| fit-app/UnifiedSyncMonitor.swift | 294 | Debug | Medio | `            print("❌ No se puede sincronizar: Sin conexión a internet")` |
| fit-app/UnifiedSyncMonitor.swift | 298 | Debug | Medio | `        print("🔄 Iniciando sincronización CloudKit...")` |
| fit-app/UnifiedSyncMonitor.swift | 307 | Debug | Medio | `            print("💾 Context guardado - CloudKit sincronizará automáticamente")` |
| fit-app/UnifiedSyncMonitor.swift | 309 | Debug | Medio | `            print("❌ Error al trigger sincronización: \(error.localizedDescription)")` |
| fit-app/UnifiedSyncMonitor.swift | 320 | Debug | Medio | `                    print("🔴 CloudKit Account Error: \(error.localizedDescription)")` |
| fit-app/UnifiedSyncMonitor.swift | 328 | Debug | Medio | `                    print("✅ CloudKit Account: Available")` |
| fit-app/UnifiedSyncMonitor.swift | 331 | Debug | Medio | `                    print("🔴 CloudKit Account: No iCloud account")` |
| fit-app/UnifiedSyncMonitor.swift | 335 | Debug | Medio | `                    print("🔴 CloudKit Account: Restricted")` |
| fit-app/UnifiedSyncMonitor.swift | 338 | Debug | Medio | `                    print("🔴 CloudKit Account: Could not determine")` |
| fit-app/UnifiedSyncMonitor.swift | 341 | Debug | Medio | `                    print("🟡 CloudKit Account: Temporarily unavailable")` |
| fit-app/UnifiedSyncMonitor.swift | 344 | Debug | Medio | `                    print("🔴 CloudKit Account: Unknown status")` |
| fit-app/UnifiedSyncMonitor.swift | 359 | Debug | Medio | `            print("📊 Entrenamientos locales: \(workouts.count)")` |
| fit-app/UnifiedSyncMonitor.swift | 369 | Debug | Medio | `            print("🔴 Error fetching workouts: \(error.localizedDescription)")` |
| fit-app/UnifiedSyncMonitor.swift | 387 | Debug | Medio | `                    print("💾 Entrenamientos pendientes de sync: \(pendingSyncCount)")` |
| fit-app/UnifiedSyncMonitor.swift | 391 | Debug | Medio | `            print("🔄 Guardado online - CloudKit sincronizará automáticamente")` |
| fit-app/UnifiedSyncMonitor.swift | 409 | Debug | Medio | `                print("🔄 Entrenamiento guardado y enviado a CloudKit: \(type)")` |
| fit-app/UnifiedSyncMonitor.swift | 411 | Debug | Medio | `                print("💾 Entrenamiento guardado offline: \(type)")` |
| fit-app/UnifiedSyncMonitor.swift | 417 | Debug | Medio | `            print("❌ Error al guardar entrenamiento: \(error.localizedDescription)")` |
| fit-app/AppleSignInManager.swift | 32 | Debug | Medio | `        print("🍎 Starting Apple Sign In process...")` |
| fit-app/AppleSignInManager.swift | 38 | Debug | Medio | `            print("❌ Apple Sign In is not available on this device/simulator")` |
| fit-app/AppleSignInManager.swift | 59 | Debug | Medio | `        print("🍎 Performing Apple Sign In request...")` |
| fit-app/AppleSignInManager.swift | 66 | Debug | Medio | `        print("📝 Request configured with scopes: \(request.requestedScopes?.map { $0.rawValue } ?? [])")` |
| fit-app/AppleSignInManager.swift | 78 | Debug | Medio | `            print("🚀 Launching authorization controller...")` |
| fit-app/AppleSignInManager.swift | 83 | Debug | Medio | `            print("❌ Failed to perform authorization request: \(error)")` |
| fit-app/AppleSignInManager.swift | 110 | Debug | Medio | `        print("🧪 Simulating Apple Sign In for testing (Simulator)")` |
| fit-app/AppleSignInManager.swift | 123 | Debug | Medio | `            print("📊 Mock Apple ID Credential Data (Simulator):")` |
| fit-app/AppleSignInManager.swift | 124 | Debug | Medio | `            print("   - User ID: \(mockUserIdentifier)")` |
| fit-app/AppleSignInManager.swift | 125 | Debug | Medio | `            print("   - Email: \(mockEmail)")` |
| fit-app/AppleSignInManager.swift | 126 | Debug | Medio | `            print("   - Full Name: Usuario Simulador")` |
| fit-app/AppleSignInManager.swift | 127 | Debug | Medio | `            print("   - Real User Status: Simulated")` |
| fit-app/AppleSignInManager.swift | 128 | Debug | Medio | `            print("   - Authentication Type: Mock/Testing")` |
| fit-app/AppleSignInManager.swift | 144 | Debug | Medio | `            print("✅ Apple Sign In simulation completed successfully")` |
| fit-app/AppleSignInManager.swift | 145 | Debug | Medio | `            print("✅ User should now be authenticated and logged in")` |
| fit-app/AppleSignInManager.swift | 153 | Debug | Medio | `            print("🍎 No stored Apple user identifier")` |
| fit-app/AppleSignInManager.swift | 159 | Debug | Medio | `        print("🍎 Checking Apple Sign In status for user: \(userIdentifier)")` |
| fit-app/AppleSignInManager.swift | 168 | Debug | Medio | `                    print("✅ Apple Sign In status: Authorized")` |
| fit-app/AppleSignInManager.swift | 173 | Debug | Medio | `                    print("🚫 Apple Sign In status: Revoked")` |
| fit-app/AppleSignInManager.swift | 178 | Debug | Medio | `                    print("❓ Apple Sign In status: Not Found")` |
| fit-app/AppleSignInManager.swift | 183 | Debug | Medio | `                    print("🤷‍♂️ Apple Sign In status: Unknown")` |
| fit-app/AppleSignInManager.swift | 193 | Debug | Medio | `        print("🍎 Signing out Apple user...")` |
| fit-app/AppleSignInManager.swift | 215 | Debug | Medio | `        print("✅ Apple user signed out successfully")` |
| fit-app/AppleSignInManager.swift | 223 | Debug | Medio | `        print("🍎 Loading stored Apple user data...")` |
| fit-app/AppleSignInManager.swift | 243 | Debug | Medio | `            print("🍎 Loaded stored Apple user from secure storage:")` |
| fit-app/AppleSignInManager.swift | 244 | Debug | Medio | `            print("   - ID: \(userIdentifier)")` |
| fit-app/AppleSignInManager.swift | 245 | Debug | Medio | `            print("   - Email: \(userEmail.isEmpty ? "Not provided" : "***@***.***")")` |
| fit-app/AppleSignInManager.swift | 246 | Debug | Medio | `            print("   - Name: \(userFullName.isEmpty ? "Not provided" : userFullName)")` |
| fit-app/AppleSignInManager.swift | 257 | Debug | Medio | `        print("🔄 Attempting to migrate legacy Apple user data...")` |
| fit-app/AppleSignInManager.swift | 267 | Debug | Medio | `            print("🔄 Found legacy Apple user data, migrating to secure storage...")` |
| fit-app/AppleSignInManager.swift | 277 | Debug | Medio | `                print("✅ Successfully migrated Apple user data to secure storage")` |
| fit-app/AppleSignInManager.swift | 292 | Debug | Medio | `                print("🗑️ Cleared legacy UserDefaults after migration")` |
| fit-app/AppleSignInManager.swift | 299 | Debug | Medio | `                print("❌ Failed to migrate Apple user data to secure storage")` |
| fit-app/AppleSignInManager.swift | 304 | Debug | Medio | `            print("ℹ️ No legacy Apple user data found to migrate")` |
| fit-app/AppleSignInManager.swift | 325 | Debug | Medio | `            print("🔐 Apple user data saved securely with encryption")` |
| fit-app/AppleSignInManager.swift | 329 | Debug | Medio | `            print("❌ Failed to save Apple user data securely")` |
| fit-app/AppleSignInManager.swift | 344 | Debug | Medio | `        print("✅ Apple user saved successfully:")` |
| fit-app/AppleSignInManager.swift | 345 | Debug | Medio | `        print("   - ID: \(userIdentifier)")` |
| fit-app/AppleSignInManager.swift | 346 | Debug | Medio | `        print("   - Email: \(userEmail.isEmpty ? "Not provided" : "***@***.***")")` |
| fit-app/AppleSignInManager.swift | 347 | Debug | Medio | `        print("   - Name: \(userFullName.isEmpty ? "Not provided" : userFullName)")` |
| fit-app/AppleSignInManager.swift | 353 | Debug | Medio | `        print("❌ Apple Sign In error: \(error.localizedDescription)")` |
| fit-app/AppleSignInManager.swift | 354 | Debug | Medio | `        print("   - Error domain: \(error._domain)")` |
| fit-app/AppleSignInManager.swift | 355 | Debug | Medio | `        print("   - Error code: \(error._code)")` |
| fit-app/AppleSignInManager.swift | 366 | Debug | Medio | `                print("   - Error type: Canceled (User dismissed the dialog)")` |
| fit-app/AppleSignInManager.swift | 371 | Debug | Medio | `                print("   - Error type: Failed (Code 1000 - often occurs in simulator)")` |
| fit-app/AppleSignInManager.swift | 372 | Debug | Medio | `                print("   - Note: This may work on a real device")` |
| fit-app/AppleSignInManager.swift | 377 | Debug | Medio | `                print("   - Error type: Invalid Response")` |
| fit-app/AppleSignInManager.swift | 382 | Debug | Medio | `                print("   - Error type: Not Handled")` |
| fit-app/AppleSignInManager.swift | 387 | Debug | Medio | `                print("   - Error type: Unknown (Code 1000 often indicates simulator limitations)")` |
| fit-app/AppleSignInManager.swift | 392 | Debug | Medio | `                print("   - Error type: Unknown Default")` |
| fit-app/AppleSignInManager.swift | 399 | Debug | Medio | `                print("🔧 Code 1000 Troubleshooting:")` |
| fit-app/AppleSignInManager.swift | 400 | Debug | Medio | `                print("   - This error is common in iOS Simulator")` |
| fit-app/AppleSignInManager.swift | 401 | Debug | Medio | `                print("   - Try testing on a real device")` |
| fit-app/AppleSignInManager.swift | 402 | Debug | Medio | `                print("   - Ensure you're signed into iCloud in Settings")` |
| fit-app/AppleSignInManager.swift | 403 | Debug | Medio | `                print("   - Check that Two-Factor Authentication is enabled")` |
| fit-app/AppleSignInManager.swift | 421 | Debug | Medio | `        print("🍎 Apple Sign In completed successfully")` |
| fit-app/AppleSignInManager.swift | 429 | Debug | Medio | `            print("❌ Failed to get Apple ID credential")` |
| fit-app/AppleSignInManager.swift | 437 | Debug | Medio | `        print("📊 Apple ID Credential Data:")` |
| fit-app/AppleSignInManager.swift | 438 | Debug | Medio | `        print("   - User ID: \(appleIDCredential.user)")` |
| fit-app/AppleSignInManager.swift | 439 | Debug | Medio | `        print("   - Email: \(appleIDCredential.email ?? "Not provided")")` |
| fit-app/AppleSignInManager.swift | 440 | Debug | Medio | `        print("   - Full Name: \(appleIDCredential.fullName?.debugDescription ?? "Not provided")")` |
| fit-app/AppleSignInManager.swift | 441 | Debug | Medio | `        print("   - Real User Status: \(appleIDCredential.realUserStatus.rawValue)")` |
| fit-app/AppleSignInManager.swift | 454 | Debug | Medio | `        print("✅ Apple Sign In process completed successfully")` |
| fit-app/AppleSignInManager.swift | 460 | Debug | Medio | `        print("❌ Apple Sign In failed with error:")` |
| fit-app/AppleSignInManager.swift | 461 | Debug | Medio | `        print("   - Error: \(error)")` |
| fit-app/AppleSignInManager.swift | 468 | Debug | Medio | `                print("🔧 Detected Code 1000 in simulator - activating automatic fallback")` |
| fit-app/AppleSignInManager.swift | 476 | Debug | Medio | `                print("🧪 Starting automatic simulator fallback...")` |
| fit-app/AppleSignInManager.swift | 497 | Debug | Medio | `            print("⚠️ Could not find window for Apple Sign In presentation")` |
| fit-app/AppleSignInManager.swift | 503 | Debug | Medio | `        print("🍎 Presenting Apple Sign In on window: \(window)")` |
| fit-app/SecureAuthService.swift | 79 | Debug | Medio | `        print("🔐 SecureAuth: Input sanitized (length: \(sanitized.count))")` |
| fit-app/SecureAuthService.swift | 89 | Debug | Medio | `        print("🔐 SecureAuth: Email validation result: \(isValid)")` |
| fit-app/SecureAuthService.swift | 96 | Debug | Medio | `            print("🔐 SecureAuth: Password too short")` |
| fit-app/SecureAuthService.swift | 107 | Debug | Medio | `        print("🔐 SecureAuth: Password validation - Length: ✓, Uppercase: \(hasUppercase ? "✓" : "✗"), Number: \(hasNumber ? "✓" : "✗")")` |
| fit-app/SecureAuthService.swift | 121 | Debug | Medio | `        print("🔐 SecureAuth: Password hashed successfully")` |
| fit-app/SecureAuthService.swift | 130 | Debug | Medio | `        print("🔐 SecureAuth: Password verification result: \(isValid)")` |
| fit-app/SecureAuthService.swift | 138 | Debug | Medio | `        print("🔐 SecureAuth: Starting user registration")` |
| fit-app/SecureAuthService.swift | 147 | Debug | Medio | `            print("🔐 SecureAuth: Registration failed - Invalid email format")` |
| fit-app/SecureAuthService.swift | 153 | Debug | Medio | `            print("🔐 SecureAuth: Registration failed - Weak password")` |
| fit-app/SecureAuthService.swift | 159 | Debug | Medio | `            print("🔐 SecureAuth: Registration failed - Password confirmation mismatch")` |
| fit-app/SecureAuthService.swift | 165 | Debug | Medio | `            print("🔐 SecureAuth: Registration failed - User already exists")` |
| fit-app/SecureAuthService.swift | 175 | Debug | Medio | `            print("🔐 SecureAuth: Registration failed - Storage error")` |
| fit-app/SecureAuthService.swift | 179 | Debug | Medio | `        print("🔐 SecureAuth: User registration successful")` |
| fit-app/SecureAuthService.swift | 187 | Debug | Medio | `        print("🔐 SecureAuth: Starting user login")` |
| fit-app/SecureAuthService.swift | 195 | Debug | Medio | `            print("🔐 SecureAuth: Login failed - Invalid email format")` |
| fit-app/SecureAuthService.swift | 201 | Debug | Medio | `            print("🔐 SecureAuth: Login failed - Email not registered")` |
| fit-app/SecureAuthService.swift | 207 | Debug | Medio | `            print("🔐 SecureAuth: Login failed - Could not retrieve user credentials")` |
| fit-app/SecureAuthService.swift | 213 | Debug | Medio | `            print("🔐 SecureAuth: Login failed - Incorrect password")` |
| fit-app/SecureAuthService.swift | 226 | Debug | Medio | `        print("🔐 SecureAuth: User login successful")` |
| fit-app/SecureAuthService.swift | 246 | Debug | Medio | `            print("🔐 SecureAuth: Failed to encode user credentials: \(error)")` |
| fit-app/SecureAuthService.swift | 263 | Debug | Medio | `            print("🔐 SecureAuth: Failed to decode user credentials: \(error)")` |
| fit-app/SecureAuthService.swift | 280 | Debug | Medio | `        print("🔐 SecureAuth: Logging out current user")` |
| fit-app/SecureAuthService.swift | 284 | Debug | Medio | `            print("🔐 SecureAuth: Logout successful")` |
| fit-app/SecureAuthService.swift | 286 | Debug | Medio | `            print("🔐 SecureAuth: Logout failed")` |
| fit-app/WelcomeView.swift | 212 | Debug | Medio | `        print("🎉 User completed welcome flow - marking as seen")` |
| fit-app/AuthViewModel.swift | 26 | Debug | Medio | `        print("🔐 Initializing AuthViewModel...")` |
| fit-app/AuthViewModel.swift | 53 | Debug | Medio | `        print("🔄 Checking for legacy sensitive data to migrate...")` |
| fit-app/AuthViewModel.swift | 61 | Debug | Medio | `            print("🔄 Migrating userName to SecureStorage...")` |
| fit-app/AuthViewModel.swift | 67 | Debug | Medio | `                print("✅ Successfully migrated userName")` |
| fit-app/AuthViewModel.swift | 71 | Debug | Medio | `                print("❌ Failed to migrate userName")` |
| fit-app/AuthViewModel.swift | 79 | Debug | Medio | `            print("🔄 Migrating userIdentifier to SecureStorage...")` |
| fit-app/AuthViewModel.swift | 85 | Debug | Medio | `                print("✅ Successfully migrated userIdentifier")` |
| fit-app/AuthViewModel.swift | 89 | Debug | Medio | `                print("❌ Failed to migrate userIdentifier")` |
| fit-app/AuthViewModel.swift | 97 | Debug | Medio | `            print("🔄 Migrating userFullName to SecureStorage...")` |
| fit-app/AuthViewModel.swift | 103 | Debug | Medio | `                print("✅ Successfully migrated userFullName")` |
| fit-app/AuthViewModel.swift | 107 | Debug | Medio | `                print("❌ Failed to migrate userFullName")` |
| fit-app/AuthViewModel.swift | 114 | Debug | Medio | `            print("✅ Legacy sensitive data migration completed")` |
| fit-app/AuthViewModel.swift | 118 | Debug | Medio | `            print("ℹ️ No legacy sensitive data found to migrate")` |
| fit-app/AuthViewModel.swift | 125 | Debug | Medio | `        print("🔐 AuthViewModel: Starting secure login process")` |
| fit-app/AuthViewModel.swift | 135 | Debug | Medio | `            print("🔐 AuthViewModel: Login successful for user: \(user.email)")` |
| fit-app/AuthViewModel.swift | 143 | Debug | Medio | `            print("🔐 AuthViewModel: Login failed - \(error.localizedDescription)")` |
| fit-app/AuthViewModel.swift | 151 | Debug | Medio | `        print("🔐 AuthViewModel: Starting secure registration process")` |
| fit-app/AuthViewModel.swift | 161 | Debug | Medio | `            print("🔐 AuthViewModel: Registration successful for user: \(user.email)")` |
| fit-app/AuthViewModel.swift | 169 | Debug | Medio | `            print("🔐 AuthViewModel: Registration failed - \(error.localizedDescription)")` |
| fit-app/AuthViewModel.swift | 177 | Debug | Medio | `        print("🚪 Logging out user...")` |
| fit-app/AuthViewModel.swift | 183 | Debug | Medio | `            print("   - Signing out Apple user")` |
| fit-app/AuthViewModel.swift | 216 | Debug | Medio | `        print("✅ User data cleared, showing goodbye screen")` |
| fit-app/AuthViewModel.swift | 227 | Debug | Medio | `        print("🏠 Completing logout process...")` |
| fit-app/AuthViewModel.swift | 232 | Debug | Medio | `        print("✅ User fully logged out, returning to login")` |
| fit-app/AuthViewModel.swift | 241 | Debug | Medio | `        print("🔄 Welcome flag reset - next login will show welcome screen")` |
| fit-app/AuthViewModel.swift | 249 | Debug | Medio | `        print("🔍 Checking for existing authentication...")` |
| fit-app/AuthViewModel.swift | 255 | Debug | Medio | `            print("   - User already authenticated via AppStorage")` |
| fit-app/AuthViewModel.swift | 263 | Debug | Medio | `            print("   - Found existing Apple user credentials")` |
| fit-app/AuthViewModel.swift | 264 | Debug | Medio | `            print("   - User ID: \(appleSignInManager.userIdentifier)")` |
| fit-app/AuthViewModel.swift | 265 | Debug | Medio | `            print("   - Email: \(appleSignInManager.userEmail)")` |
| fit-app/AuthViewModel.swift | 266 | Debug | Medio | `            print("   - Auto-logging in Apple user...")` |
| fit-app/AuthViewModel.swift | 273 | Debug | Medio | `                print("✅ Apple user auto-logged in successfully")` |
| fit-app/AuthViewModel.swift | 280 | Debug | Medio | `                print("   - Found existing secure user session for: \(currentUser)")` |
| fit-app/AuthViewModel.swift | 281 | Debug | Medio | `                print("   - Auto-logging in secure user...")` |
| fit-app/AuthViewModel.swift | 288 | Debug | Medio | `                    print("✅ Secure user auto-logged in successfully")` |
| fit-app/AuthViewModel.swift | 297 | Debug | Medio | `        print("🔍 Checking authentication status...")` |
| fit-app/AuthViewModel.swift | 303 | Debug | Medio | `            print("   - Found existing Apple user, checking status...")` |
| fit-app/AuthViewModel.swift | 309 | Debug | Medio | `        print("   - Current auth status: \(isAuthenticated)")` |
| fit-app/AuthViewModel.swift | 315 | Debug | Medio | `        print("🔗 Setting up Apple authentication listener...")` |
| fit-app/AuthViewModel.swift | 324 | Debug | Medio | `                        print("✅ Apple user authenticated - updating AuthViewModel")` |
| fit-app/AuthViewModel.swift | 331 | Debug | Medio | `                            print("❌ Apple user lost authentication - logging out")` |
| fit-app/AuthViewModel.swift | 343 | Debug | Medio | `        print("🚪 Handling Apple Sign Out...")` |
| fit-app/AuthViewModel.swift | 350 | Debug | Medio | `            print("✅ Apple user logged out from AuthViewModel")` |
| fit-app/EntrenamientoViewModel.swift | 93 | Debug | Medio | `            print("Error loading workouts: \(error.localizedDescription)")` |
| fit-app/SecureStorage.swift | 26 | Debug | Medio | `            print("🔐 SecureStorage: Failed to prepare data for encryption")` |
| fit-app/SecureStorage.swift | 35 | Debug | Medio | `                print("🔐 SecureStorage: Failed to get combined encrypted data")` |
| fit-app/SecureStorage.swift | 42 | Debug | Medio | `            print("🔐 SecureStorage: Successfully encrypted data (length: \(base64Encrypted.count))")` |
| fit-app/SecureStorage.swift | 48 | Debug | Medio | `            print("🔐 SecureStorage: Encryption failed - \(error.localizedDescription)")` |
| fit-app/SecureStorage.swift | 61 | Debug | Medio | `            print("🔐 SecureStorage: Failed to prepare encrypted data for decryption")` |
| fit-app/SecureStorage.swift | 72 | Debug | Medio | `                print("🔐 SecureStorage: Failed to convert decrypted data to string")` |
| fit-app/SecureStorage.swift | 78 | Debug | Medio | `            print("🔐 SecureStorage: Successfully decrypted data")` |
| fit-app/SecureStorage.swift | 84 | Debug | Medio | `            print("🔐 SecureStorage: Decryption failed - \(error.localizedDescription)")` |
| fit-app/SecureStorage.swift | 96 | Debug | Medio | `            print("🔐 SecureStorage: Retrieved existing encryption key")` |
| fit-app/SecureStorage.swift | 108 | Debug | Medio | `            print("🔐 SecureStorage: Generated and stored new encryption key")` |
| fit-app/SecureStorage.swift | 113 | Debug | Medio | `            print("🔐 SecureStorage: Failed to store new encryption key")` |
| fit-app/SecureStorage.swift | 187 | Debug | Medio | `            print("🔐 SecureStorage: Failed to encrypt value for key: \(key)")` |
| fit-app/SecureStorage.swift | 221 | Debug | Medio | `            print("🔐 SecureStorage: Failed to convert value to data for key: \(key)")` |
| fit-app/SecureStorage.swift | 238 | Debug | Medio | `            print("🔐 SecureStorage: Successfully stored data for key: \(key)")` |
| fit-app/SecureStorage.swift | 243 | Debug | Medio | `            print("🔐 SecureStorage: Failed to store data for key: \(key). Status: \(status)")` |
| fit-app/SecureStorage.swift | 269 | Debug | Medio | `            print("🔐 SecureStorage: Successfully retrieved data for key: \(key)")` |
| fit-app/SecureStorage.swift | 275 | Debug | Medio | `                print("🔐 SecureStorage: Failed to retrieve data for key: \(key). Status: \(status)")` |
| fit-app/SecureStorage.swift | 294 | Debug | Medio | `            print("🔐 SecureStorage: Successfully deleted data for key: \(key)")` |
| fit-app/SecureStorage.swift | 299 | Debug | Medio | `            print("🔐 SecureStorage: Failed to delete data for key: \(key). Status: \(status)")` |
| fit-app/SecureStorage.swift | 321 | Debug | Medio | `        print("🔐 SecureStorage: Clearing all stored credentials")` |
| fit-app/SecureStorage.swift | 333 | Debug | Medio | `            print("🔐 SecureStorage: All credentials cleared successfully")` |
| fit-app/SecureStorage.swift | 337 | Debug | Medio | `            print("🔐 SecureStorage: Failed to clear some credentials")` |
| fit-app/SecureStorage.swift | 438 | Debug | Medio | `        print("🧪 Testing SecureStorage functionality...")` |
| fit-app/SecureStorage.swift | 447 | Debug | Medio | `            print("❌ Failed to store encrypted test value")` |
| fit-app/SecureStorage.swift | 456 | Debug | Medio | `            print("❌ Failed to retrieve or validate encrypted test value")` |
| fit-app/SecureStorage.swift | 464 | Debug | Medio | `            print("❌ Failed to delete test value")` |
| fit-app/SecureStorage.swift | 472 | Debug | Medio | `            print("❌ Test value still exists after deletion")` |
| fit-app/SecureStorage.swift | 478 | Debug | Medio | `        print("✅ SecureStorage test passed successfully")` |
| fit-app/SecureStorage.swift | 486 | Debug | Medio | `        print("🔍 Verifying migration status...")` |
| fit-app/SecureStorage.swift | 495 | Debug | Medio | `                print("⚠️ Legacy data still exists in UserDefaults: \(key)")` |
| fit-app/SecureStorage.swift | 503 | Debug | Medio | `                print("✅ Secure data found in Keychain: \(key)")` |
| fit-app/TimerView.swift | 664 | Debug | Medio | `                print("❌ Error loading work sound: \(error.localizedDescription)")` |
| fit-app/TimerView.swift | 675 | Debug | Medio | `                print("❌ Error loading rest sound: \(error.localizedDescription)")` |
| fit-app/TimerView.swift | 684 | Debug | Medio | `            print("❌ Error setting up audio session: \(error.localizedDescription)")` |
| fit-app/UserProfileManager.swift | 21 | Debug | Medio | `        print("👤 Loading current user profile...")` |
| fit-app/UserProfileManager.swift | 34 | Debug | Medio | `                print("✅ Found existing user: \(user.fullName ?? "Unknown")")` |
| fit-app/UserProfileManager.swift | 38 | Debug | Medio | `                print("ℹ️ No active user found")` |
| fit-app/UserProfileManager.swift | 42 | Debug | Medio | `            print("❌ Error loading current user: \(error)")` |
| fit-app/UserProfileManager.swift | 52 | Debug | Medio | `        print("👤 Creating/updating user profile...")` |
| fit-app/UserProfileManager.swift | 53 | Debug | Medio | `        print("   - Name: \(fullName ?? "Not provided")")` |
| fit-app/UserProfileManager.swift | 54 | Debug | Medio | `        print("   - Email: \(email ?? "Not provided")")` |
| fit-app/UserProfileManager.swift | 55 | Debug | Medio | `        print("   - Auth Type: \(authType)")` |
| fit-app/UserProfileManager.swift | 65 | Debug | Medio | `                    print("✅ Updating existing Apple user")` |
| fit-app/UserProfileManager.swift | 70 | Debug | Medio | `                print("❌ Error checking for existing Apple user: \(error)")` |
| fit-app/UserProfileManager.swift | 117 | Debug | Medio | `            print("❌ Error deactivating users: \(error)")` |
| fit-app/UserProfileManager.swift | 134 | Debug | Medio | `                print("✅ User profile saved: \(user.fullName ?? "Unknown")")` |
| fit-app/UserProfileManager.swift | 137 | Debug | Medio | `            print("❌ Error saving user profile: \(error)")` |
| fit-app/UserProfileManager.swift | 144 | Debug | Medio | `        print("🍎 Handling Apple Sign In for user profile...")` |
| fit-app/UserProfileManager.swift | 169 | Debug | Medio | `        print("📧 Handling regular sign in for user profile...")` |
| fit-app/UserProfileManager.swift | 197 | Debug | Medio | `        print("🚪 Signing out user profile...")` |
| fit-app/UserProfileManager.swift | 209 | Debug | Medio | `        print("✅ User signed out successfully")` |
| fit-app/UserProfileManager.swift | 231 | Debug | Medio | `        print("🔄 Starting UserProfile encryption migration...")` |
| fit-app/UserProfileManager.swift | 253 | Debug | Medio | `                print("✅ Successfully migrated \(migratedCount) user profiles to encrypted storage")` |
| fit-app/UserProfileManager.swift | 255 | Debug | Medio | `                print("ℹ️ No user profiles needed encryption migration")` |
| fit-app/UserProfileManager.swift | 259 | Debug | Medio | `            print("❌ Error migrating user profiles to encrypted storage: \(error)")` |
| fit-app/UserProfileManager.swift | 266 | Debug | Medio | `        print("✏️ Updating display name to: \(newName)")` |
| fit-app/UserProfileManager.swift | 278 | Debug | Medio | `                print("✅ Display name updated successfully")` |
| fit-app/UserProfileManager.swift | 280 | Debug | Medio | `                print("❌ Error updating display name: \(error)")` |
| fit-app/CloudKitConflictView.swift | 175 | Debug | Medio | `                    print(report)` |
| fit-app/InicioView.swift | 894 | Debug | Medio | `        print("🔄 Iniciando test de sincronización CloudKit...")` |
| fit-app/InicioView.swift | 903 | Debug | Medio | `                        print("🔴 CloudKit Error: \(error.localizedDescription)")` |
| fit-app/InicioView.swift | 912 | Debug | Medio | `                        print("✅ CloudKit disponible - datos sincronizados")` |
| fit-app/InicioView.swift | 916 | Debug | Medio | `                        print("❌ No hay cuenta iCloud")` |
| fit-app/InicioView.swift | 921 | Debug | Medio | `                        print("⚠️ CloudKit no disponible")` |
| fit-app/InputValidator.swift | 747 | Debug | Medio | `        print("🧪 Running comprehensive validation tests...")` |
| fit-app/InputValidator.swift | 766 | Debug | Medio | `        print("📧 Testing email validation...")` |
| fit-app/InputValidator.swift | 774 | Debug | Medio | `                print("✅ Email test passed: '\(email)' -> \(result.isValid)")` |
| fit-app/InputValidator.swift | 778 | Debug | Medio | `                print("❌ Email test failed: '\(email)' expected \(shouldPass), got \(result.isValid)")` |
| fit-app/InputValidator.swift | 796 | Debug | Medio | `        print("🔒 Testing password validation...")` |
| fit-app/InputValidator.swift | 804 | Debug | Medio | `                print("✅ Password test passed: '\(password.prefix(3))***' -> \(result.isValid)")` |
| fit-app/InputValidator.swift | 808 | Debug | Medio | `                print("❌ Password test failed: '\(password.prefix(3))***' expected \(shouldPass), got \(result.isValid)")` |
| fit-app/InputValidator.swift | 823 | Debug | Medio | `        print("🧽 Testing input sanitization...")` |
| fit-app/InputValidator.swift | 831 | Debug | Medio | `                print("✅ Sanitization test passed: '\(input)' -> '\(result)'")` |
| fit-app/InputValidator.swift | 835 | Debug | Medio | `                print("❌ Sanitization test failed: '\(input)' expected '\(expected)', got '\(result)'")` |
| fit-app/InputValidator.swift | 852 | Debug | Medio | `        print("👤 Testing name validation...")` |
| fit-app/InputValidator.swift | 860 | Debug | Medio | `                print("✅ Name test passed: '\(name)' -> \(result.isValid)")` |
| fit-app/InputValidator.swift | 864 | Debug | Medio | `                print("❌ Name test failed: '\(name)' expected \(shouldPass), got \(result.isValid)")` |
| fit-app/InputValidator.swift | 872 | Debug | Medio | `        print("\n📊 Validation Test Summary:")` |
| fit-app/InputValidator.swift | 873 | Debug | Medio | `        print("✅ Tests passed: \(testsPassedCount)/\(totalTests)")` |
| fit-app/InputValidator.swift | 874 | Debug | Medio | `        print("📈 Success rate: \(String(format: "%.1f", successRate))%")` |
| fit-app/InputValidator.swift | 880 | Debug | Medio | `            print("🎉 All validation tests passed!")` |
| fit-app/InputValidator.swift | 884 | Debug | Medio | `            print("⚠️ Some validation tests failed. Please review implementation.")` |
| fit-app/InputValidator.swift | 899 | Debug | Medio | `        print("🔍 Quick validation test: Email=\(emailTest), Password=\(passwordTest), Name=\(nameTest)")` |
| fit-app/PerfilView.swift | 835 | Debug | Medio | `        print("✅ User name updated to: \(sanitizedName)")` |
| fit-app/PerfilView.swift | 1253 | Debug | Medio | `            print("🏃‍♂️ Nuevo entrenamiento Test CloudKit guardado - iniciando sincronización CloudKit")` |
| fit-app/PerfilView.swift | 1254 | Debug | Medio | `            print("📊 Tipo: Test CloudKit, Duración: \(testWorkout.duration) min")` |
| fit-app/AppleSignInButtonView.swift | 10 | Debug | Medio | `                print("🍎 Apple Sign In button tapped - preparing request...")` |
| fit-app/AppleSignInButtonView.swift | 14 | Debug | Medio | `                print("🍎 Apple Sign In button completion called")` |
| fit-app/AppleSignInButtonView.swift | 19 | Debug | Medio | `                    print("✅ Apple Sign In button reported success")` |
| fit-app/AppleSignInButtonView.swift | 21 | Debug | Medio | `                    print("❌ Apple Sign In button reported failure: \(error.localizedDescription)")` |
| fit-app/DataEncryptionHelper.swift | 28 | Debug | Medio | `            print("🔐 DataEncryption: Failed to serialize workout data: \(error)")` |
| fit-app/DataEncryptionHelper.swift | 42 | Debug | Medio | `            print("🔐 DataEncryption: Failed to convert JSON string to data")` |
| fit-app/DataEncryptionHelper.swift | 49 | Debug | Medio | `            print("🔐 DataEncryption: Failed to deserialize workout data: \(error)")` |
| fit-app/DataEncryptionHelper.swift | 86 | Debug | Medio | `                        print("🔐 DataEncryption: Encrypted field '\(fieldName)' for entity")` |
| fit-app/DataEncryptionHelper.swift | 88 | Debug | Medio | `                        print("❌ DataEncryption: Failed to encrypt field '\(fieldName)'")` |
| fit-app/DataEncryptionHelper.swift | 109 | Debug | Medio | `                    print("🔐 DataEncryption: Decrypted field '\(fieldName)' for entity")` |
| fit-app/DataEncryptionHelper.swift | 111 | Debug | Medio | `                    print("❌ DataEncryption: Failed to decrypt field '\(fieldName)'")` |
| fit-app/DataEncryptionHelper.swift | 142 | Debug | Medio | `            print("🔐 DataEncryption: Failed to encrypt workout metrics: \(error)")` |
| fit-app/DataEncryptionHelper.swift | 152 | Debug | Medio | `            print("🔐 DataEncryption: Failed to decrypt workout data")` |
| fit-app/DataEncryptionHelper.swift | 157 | Debug | Medio | `            print("🔐 DataEncryption: Failed to convert decrypted string to data")` |
| fit-app/DataEncryptionHelper.swift | 169 | Debug | Medio | `                print("🔐 DataEncryption: Failed to parse decrypted workout data")` |
| fit-app/DataEncryptionHelper.swift | 175 | Debug | Medio | `            print("🔐 DataEncryption: Failed to parse workout JSON: \(error)")` |
| fit-app/DataEncryptionHelper.swift | 198 | Debug | Medio | `            print("🔄 DataEncryption: Successfully migrated '\(oldKey)' to encrypted storage")` |
| fit-app/DataEncryptionHelper.swift | 200 | Debug | Medio | `            print("❌ DataEncryption: Failed to migrate '\(oldKey)' to encrypted storage")` |
| fit-app/DataEncryptionHelper.swift | 264 | Debug | Medio | `    ///     print("Workout: \(metrics.type), \(metrics.calories) calories, \(metrics.duration) minutes")` |
| fit-app/AppConstants.swift | 47 | TODO | Bajo | `        MotivationalMessage(text: "Todo bien, puedes volver a empezar", emoji: "🌱", context: .longBreak),` |
| fit-app/AppConstants.swift | 463 | TODO | Bajo | `            "Tu energía positiva transforma todo 🌟",` |
| fit-app/DailySummaryCardView.swift | 317 | TODO | Bajo | `            return "Todo bien, hoy puedes retomar"` |
| fit-app/PerfilView.swift | 397 | TODO | Bajo | `                        Text("Ver todo")` |
| fit-app/MotivationalMessageManager.swift | 47 | TODO | Bajo | `        MotivationalMessage(text: "Todo bien, puedes volver a empezar", emoji: "🌱", context: .longBreak),` |
| fit-app/CloudKitConflictView.swift | 192 | TODO | Bajo | `                        Text("Limpiar Todos los Eventos")` |
| fit-app/HistorialView.swift | 455 | TODO | Bajo | `                    Text("Aquí aparecerán todos tus entrenamientos una vez que comiences tu viaje fitness.")` |
| fit-app/InicioView.swift | 652 | TODO | Bajo | `            return "Todo bien, hoy puedes retomar"` |

## Resumen y Recomendaciones

### Resumen de Hallazgos

- **Alta Severidad:** 35 (Secretos y credenciales expuestas)
- **Media Severidad:** 387 (Código de debug en producción)
- **Baja Severidad:** 8 (TODOs y FIXMEs pendientes)

### Recomendaciones

#### Severidad Alta
- **Acción inmediata requerida:** Revisar todos los hallazgos de alta severidad
- Rotar cualquier credencial que haya sido expuesta
- Implementar el uso de variables de entorno para configuración sensible
- Configurar git-secrets como hook obligatorio para todos los desarrolladores

#### Severidad Media
- Envolver todas las declaraciones de debug en bloques `#if DEBUG ... #endif`
- Implementar un sistema de logging configurable que se deshabilite en producción
- Revisar que no haya información sensible en los logs de debug

#### Severidad Baja
- Priorizar y resolver TODOs pendientes antes del release
- Convertir FIXMEs en issues del repositorio para seguimiento
- Establecer políticas para limitar la cantidad de TODOs en el código

### Configuración Recomendada

```bash
# Configurar git-secrets globalmente
git secrets --install --global
git secrets --register-aws --global

# Agregar patrones personalizados
git secrets --add 'MyApp[._-]?API[._-]?Key'
git secrets --add 'CloudKit[._-]?Token'
```

### Próximos Pasos

1. **Inmediato:** Resolver todos los hallazgos de alta severidad
2. **Corto plazo:** Implementar logging seguro y resolver debug statements
3. **Mediano plazo:** Establecer proceso de revisión de código con foco en seguridad
4. **Largo plazo:** Implementar análisis de seguridad automatizado en CI/CD

---
*Este reporte fue generado automáticamente. Revisar manualmente todos los hallazgos.*

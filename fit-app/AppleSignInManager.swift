import Foundation
import SwiftUI
import AuthenticationServices
import os.log

class AppleSignInManager: NSObject, ObservableObject {
    static let shared = AppleSignInManager()
    
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Apple ID user data
    @Published var userIdentifier: String = ""
    @Published var userEmail: String = ""
    @Published var userFullName: String = ""
    
    // Secure storage reference
    private let secureStorage = SecureStorage.shared
    
    // Keep reference to authorization controller
    private var currentAuthController: ASAuthorizationController?
    
    private override init() {
        super.init()
        loadStoredAppleUser()
    }
    
    // MARK: - Public Methods
    
    func signInWithApple() {
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("🍎 Starting Apple Sign In process...")
        #endif
        #endif
        
        // Check if Apple Sign In is available
        guard isAppleSignInAvailable() else {
            #if DEBUG
            #if DEBUG
            Logger.auth.debug("❌ Apple Sign In is not available on this device/simulator")
            #endif
            #endif
            handleAppleSignInError(NSError(
                domain: "AppleSignIn", 
                code: -2, 
                userInfo: [NSLocalizedDescriptionKey: "Apple Sign In no está disponible en este dispositivo"]
            ))
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Add delay for better UX in simulator
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.performAppleSignInRequest()
        }
    }
    
    private func performAppleSignInRequest() {
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("🍎 Performing Apple Sign In request...")
        #endif
        #endif
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("📝 Request configured with scopes: \(request.requestedScopes?.map { $0.rawValue } ?? [])")
        #endif
        #endif
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        // Store reference to prevent deallocation
        self.currentAuthController = authorizationController
        
        do {
            #if DEBUG
            Logger.auth.debug("🚀 Launching authorization controller...")
            #endif
            authorizationController.performRequests()
        } catch {
            #if DEBUG
            Logger.auth.debug("❌ Failed to perform authorization request: \(error)")
            #endif
            handleAppleSignInError(error)
        }
    }
    
    private func isAppleSignInAvailable() -> Bool {
        // Check if we're on iOS 13+ (should always be true for iOS 16+ target)
        if #available(iOS 13.0, *) {
            return true
        } else {
            return false
        }
    }
    
    private func isRunningInSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    // MARK: - Simulator Fallback
    
    private func simulateAppleSignInForTesting() {
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("🧪 Simulating Apple Sign In for testing (Simulator)")
        #endif
        #endif
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Create mock user data for testing
            let mockUserIdentifier = "000000.mock.user.simulator.test"
            let mockEmail = "test@icloud.com"
            var mockNameComponents = PersonNameComponents()
            mockNameComponents.givenName = "Usuario"
            mockNameComponents.familyName = "Simulador"
            
            #if DEBUG
            #if DEBUG
            Logger.auth.debug("📊 Mock Apple ID Credential Data (Simulator):")
            Logger.auth.debug("   - User ID: \(mockUserIdentifier)")
            Logger.auth.debug("   - Email: \(mockEmail)")
            Logger.auth.debug("   - Full Name: Usuario Simulador")
            Logger.auth.debug("   - Real User Status: Simulated")
            Logger.auth.debug("   - Authentication Type: Mock/Testing")
            #endif
            #endif
            
            // Clear any previous error
            self.errorMessage = nil
            
            // Save mock user data
            self.saveAppleUser(
                identifier: mockUserIdentifier,
                email: mockEmail,
                fullName: mockNameComponents
            )
            
            self.isLoading = false
            
            #if DEBUG
            #if DEBUG
            Logger.auth.debug("✅ Apple Sign In simulation completed successfully")
            Logger.auth.debug("✅ User should now be authenticated and logged in")
            #endif
            #endif
        }
    }
    
    func checkAppleSignInStatus() {
        guard !userIdentifier.isEmpty else {
            #if DEBUG
            #if DEBUG
            Logger.auth.debug("🍎 No stored Apple user identifier")
            #endif
            #endif
            return
        }
        
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("🍎 Checking Apple Sign In status for user: \(userIdentifier)")
        #endif
        #endif
        
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: userIdentifier) { [weak self] credentialState, error in
            DispatchQueue.main.async {
                switch credentialState {
                case .authorized:
                    #if DEBUG
                    #if DEBUG
                    Logger.auth.debug("✅ Apple Sign In status: Authorized")
                    #endif
                    #endif
                    self?.isAuthenticated = true
                case .revoked:
                    #if DEBUG
                    #if DEBUG
                    Logger.auth.debug("🚫 Apple Sign In status: Revoked")
                    #endif
                    #endif
                    self?.signOut()
                case .notFound:
                    #if DEBUG
                    #if DEBUG
                    Logger.auth.debug("❓ Apple Sign In status: Not Found")
                    #endif
                    #endif
                    self?.signOut()
                @unknown default:
                    #if DEBUG
                    #if DEBUG
                    Logger.auth.debug("🤷‍♂️ Apple Sign In status: Unknown")
                    #endif
                    #endif
                    break
                }
            }
        }
    }
    
    func signOut() {
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("🍎 Signing out Apple user...")
        #endif
        #endif
        
        // Clear published properties
        isAuthenticated = false
        userIdentifier = ""
        userEmail = ""
        userFullName = ""
        errorMessage = nil
        
        // Clear encrypted storage
        _ = secureStorage.delete(key: SecureStorage.StorageKeys.appleUserID)
        _ = secureStorage.delete(key: SecureStorage.StorageKeys.appleUserEmail)
        _ = secureStorage.delete(key: SecureStorage.StorageKeys.appleUserName)
        
        // Clear legacy UserDefaults for migration
        UserDefaults.standard.removeObject(forKey: "AppleUserIdentifier")
        UserDefaults.standard.removeObject(forKey: "AppleUserEmail")
        UserDefaults.standard.removeObject(forKey: "AppleUserName")
        UserDefaults.standard.removeObject(forKey: "IsAppleUser")
        
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("✅ Apple user signed out successfully")
        #endif
        #endif
    }
    
    // MARK: - Private Methods
    
    private func loadStoredAppleUser() {
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("🍎 Loading stored Apple user data...")
        #endif
        #endif
        
        // Try to load from secure storage first
        let storedId = secureStorage.retrieveEncrypted(for: SecureStorage.StorageKeys.appleUserID) ?? ""
        let storedEmail = secureStorage.retrieveEncrypted(for: SecureStorage.StorageKeys.appleUserEmail) ?? ""
        let storedName = secureStorage.retrieveEncrypted(for: SecureStorage.StorageKeys.appleUserName) ?? ""
        
        // If secure storage is empty, try to migrate from legacy UserDefaults
        if storedId.isEmpty {
            migrateLegacyAppleUserData()
            return
        }
        
        if !storedId.isEmpty {
            userIdentifier = storedId
            userEmail = storedEmail
            userFullName = storedName
            
            #if DEBUG
            #if DEBUG
            Logger.auth.debug("🍎 Loaded stored Apple user from secure storage:")
            Logger.auth.debug("   - ID: \(userIdentifier)")
            Logger.auth.debug("   - Email: \(userEmail.isEmpty ? "Not provided" : "***@***.***")")
            Logger.auth.debug("   - Name: \(userFullName.isEmpty ? "Not provided" : userFullName)")
            #endif
            #endif
            
            // Check if still authorized with Apple
            checkAppleSignInStatus()
        }
    }
    
    /// Migrate legacy Apple user data from UserDefaults to secure encrypted storage
    private func migrateLegacyAppleUserData() {
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("🔄 Attempting to migrate legacy Apple user data...")
        #endif
        #endif
        
        let legacyId = UserDefaults.standard.string(forKey: "AppleUserIdentifier") ?? ""
        let legacyEmail = UserDefaults.standard.string(forKey: "AppleUserEmail") ?? ""
        let legacyName = UserDefaults.standard.string(forKey: "AppleUserName") ?? ""
        let isAppleUser = UserDefaults.standard.bool(forKey: "IsAppleUser")
        
        if !legacyId.isEmpty && isAppleUser {
            #if DEBUG
            #if DEBUG
            Logger.auth.debug("🔄 Found legacy Apple user data, migrating to secure storage...")
            #endif
            #endif
            
            // Store in secure encrypted storage
            let success = secureStorage.storeEncrypted(legacyId, for: SecureStorage.StorageKeys.appleUserID) &&
                         secureStorage.storeEncrypted(legacyEmail, for: SecureStorage.StorageKeys.appleUserEmail) &&
                         secureStorage.storeEncrypted(legacyName, for: SecureStorage.StorageKeys.appleUserName)
            
            if success {
                #if DEBUG
                #if DEBUG
                Logger.auth.debug("✅ Successfully migrated Apple user data to secure storage")
                #endif
                #endif
                
                // Update current properties
                userIdentifier = legacyId
                userEmail = legacyEmail
                userFullName = legacyName
                
                // Clear legacy UserDefaults after successful migration
                UserDefaults.standard.removeObject(forKey: "AppleUserIdentifier")
                UserDefaults.standard.removeObject(forKey: "AppleUserEmail")
                UserDefaults.standard.removeObject(forKey: "AppleUserName")
                UserDefaults.standard.removeObject(forKey: "IsAppleUser")
                
                #if DEBUG
                #if DEBUG
                Logger.auth.debug("🗑️ Cleared legacy UserDefaults after migration")
                #endif
                #endif
                
                // Check if still authorized with Apple
                checkAppleSignInStatus()
            } else {
                #if DEBUG
                #if DEBUG
                Logger.auth.debug("❌ Failed to migrate Apple user data to secure storage")
                #endif
                #endif
            }
        } else {
            #if DEBUG
            #if DEBUG
            Logger.auth.debug("ℹ️ No legacy Apple user data found to migrate")
            #endif
            #endif
        }
    }
    
    private func saveAppleUser(identifier: String, email: String?, fullName: PersonNameComponents?) {
        userIdentifier = identifier
        userEmail = email ?? ""
        
        // Format full name
        let firstName = fullName?.givenName ?? ""
        let lastName = fullName?.familyName ?? ""
        userFullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        
        // Save to secure encrypted storage
        let success = secureStorage.storeEncrypted(identifier, for: SecureStorage.StorageKeys.appleUserID) &&
                     secureStorage.storeEncrypted(userEmail, for: SecureStorage.StorageKeys.appleUserEmail) &&
                     secureStorage.storeEncrypted(userFullName, for: SecureStorage.StorageKeys.appleUserName)
        
        if success {
            #if DEBUG
            #if DEBUG
            Logger.auth.debug("🔐 Apple user data saved securely with encryption")
            #endif
            #endif
        } else {
            #if DEBUG
            #if DEBUG
            Logger.auth.debug("❌ Failed to save Apple user data securely")
            #endif
            #endif
        }
        
        // Create/Update user profile
        UserProfileManager.shared.handleAppleSignIn(
            userID: identifier,
            fullName: fullName,
            email: email
        )
        
        // Mark as authenticated
        isAuthenticated = true
        
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("✅ Apple user saved successfully:")
        Logger.auth.debug("   - ID: \(userIdentifier)")
        Logger.auth.debug("   - Email: \(userEmail.isEmpty ? "Not provided" : "***@***.***")")
        Logger.auth.debug("   - Name: \(userFullName.isEmpty ? "Not provided" : userFullName)")
        #endif
        #endif
    }
    
    private func handleAppleSignInError(_ error: Error) {
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("❌ Apple Sign In error: \(error.localizedDescription)")
        Logger.auth.debug("   - Error domain: \(error._domain)")
        Logger.auth.debug("   - Error code: \(error._code)")
        #endif
        #endif
        
        // Clear auth controller reference
        currentAuthController = nil
        
        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled:
                errorMessage = "Inicio de sesión cancelado"
                #if DEBUG
                #if DEBUG
                Logger.auth.debug("   - Error type: Canceled (User dismissed the dialog)")
                #endif
                #endif
            case .failed:
                errorMessage = "Simulador no soporta Apple Sign In completamente"
                #if DEBUG
                #if DEBUG
                Logger.auth.debug("   - Error type: Failed (Code 1000 - often occurs in simulator)")
                Logger.auth.debug("   - Note: This may work on a real device")
                #endif
                #endif
            case .invalidResponse:
                errorMessage = "Respuesta inválida de Apple"
                #if DEBUG
                #if DEBUG
                Logger.auth.debug("   - Error type: Invalid Response")
                #endif
                #endif
            case .notHandled:
                errorMessage = "No se pudo procesar la solicitud"
                #if DEBUG
                #if DEBUG
                Logger.auth.debug("   - Error type: Not Handled")
                #endif
                #endif
            case .unknown:
                errorMessage = "Error desconocido (posible problema de simulador)"
                #if DEBUG
                #if DEBUG
                Logger.auth.debug("   - Error type: Unknown (Code 1000 often indicates simulator limitations)")
                #endif
                #endif
            @unknown default:
                errorMessage = "Error inesperado"
                #if DEBUG
                #if DEBUG
                Logger.auth.debug("   - Error type: Unknown Default")
                #endif
                #endif
            }
            
            // Special handling for code 1000 (common in simulator)
            if authError.code.rawValue == 1000 {
                #if DEBUG
                #if DEBUG
                Logger.auth.debug("🔧 Code 1000 Troubleshooting:")
                Logger.auth.debug("   - This error is common in iOS Simulator")
                Logger.auth.debug("   - Try testing on a real device")
                Logger.auth.debug("   - Ensure you're signed into iCloud in Settings")
                Logger.auth.debug("   - Check that Two-Factor Authentication is enabled")
                #endif
                #endif
                errorMessage = "Apple Sign In no disponible en simulador. Prueba en dispositivo real."
            }
        } else {
            errorMessage = "Error al iniciar sesión con Apple: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleSignInManager: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("🍎 Apple Sign In completed successfully")
        #endif
        #endif
        
        // Clear controller reference
        currentAuthController = nil
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            #if DEBUG
            #if DEBUG
            Logger.auth.debug("❌ Failed to get Apple ID credential")
            #endif
            #endif
            handleAppleSignInError(NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get Apple ID credential"]))
            return
        }
        
        // Log received data for validation
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("📊 Apple ID Credential Data:")
        Logger.auth.debug("   - User ID: \(appleIDCredential.user)")
        Logger.auth.debug("   - Email: \(appleIDCredential.email ?? "Not provided")")
        Logger.auth.debug("   - Full Name: \(appleIDCredential.fullName?.debugDescription ?? "Not provided")")
        Logger.auth.debug("   - Real User Status: \(appleIDCredential.realUserStatus.rawValue)")
        #endif
        #endif
        
        // Save user data
        saveAppleUser(
            identifier: appleIDCredential.user,
            email: appleIDCredential.email,
            fullName: appleIDCredential.fullName
        )
        
        isLoading = false
        
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("✅ Apple Sign In process completed successfully")
        #endif
        #endif
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("❌ Apple Sign In failed with error:")
        Logger.auth.debug("   - Error: \(error)")
        #endif
        #endif
        
        // Special handling for simulator - automatic fallback
        if isRunningInSimulator() {
            if let authError = error as? ASAuthorizationError, authError.code.rawValue == 1000 {
                #if DEBUG
                #if DEBUG
                Logger.auth.debug("🔧 Detected Code 1000 in simulator - activating automatic fallback")
                #endif
                #endif
                
                // Clear current controller
                currentAuthController = nil
                
                // Automatically start simulator fallback
                #if DEBUG
                #if DEBUG
                Logger.auth.debug("🧪 Starting automatic simulator fallback...")
                #endif
                #endif
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.simulateAppleSignInForTesting()
                }
                return
            }
        }
        
        handleAppleSignInError(error)
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AppleSignInManager: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            #if DEBUG
            #if DEBUG
            Logger.auth.debug("⚠️ Could not find window for Apple Sign In presentation")
            #endif
            #endif
            return UIWindow()
        }
        
        #if DEBUG
        #if DEBUG
        Logger.auth.debug("🍎 Presenting Apple Sign In on window: \(window)")
        #endif
        #endif
        return window
    }
}

// MARK: - Utility Extensions

extension AppleSignInManager {
    
    var isAppleUser: Bool {
        // Check if we have encrypted Apple user data
        let hasAppleUserID = secureStorage.retrieveEncrypted(for: SecureStorage.StorageKeys.appleUserID) != nil
        
        // Also check legacy UserDefaults for migration
        let hasLegacyAppleUser = UserDefaults.standard.bool(forKey: "IsAppleUser")
        
        return hasAppleUserID || hasLegacyAppleUser
    }
    
    func clearError() {
        errorMessage = nil
    }
}
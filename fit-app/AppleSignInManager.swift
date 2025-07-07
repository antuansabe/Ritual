import Foundation
import SwiftUI
import AuthenticationServices

class AppleSignInManager: NSObject, ObservableObject {
    static let shared = AppleSignInManager()
    
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Apple ID user data
    @Published var userIdentifier: String = ""
    @Published var userEmail: String = ""
    @Published var userFullName: String = ""
    
    // UserDefaults keys
    private let appleUserIdKey = "AppleUserIdentifier"
    private let appleUserEmailKey = "AppleUserEmail"
    private let appleUserNameKey = "AppleUserName"
    private let isAppleUserKey = "IsAppleUser"
    
    // Keep reference to authorization controller
    private var currentAuthController: ASAuthorizationController?
    
    private override init() {
        super.init()
        loadStoredAppleUser()
    }
    
    // MARK: - Public Methods
    
    func signInWithApple() {
        print("🍎 Starting Apple Sign In process...")
        
        // Check if Apple Sign In is available
        guard isAppleSignInAvailable() else {
            print("❌ Apple Sign In is not available on this device/simulator")
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
        print("🍎 Performing Apple Sign In request...")
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        print("📝 Request configured with scopes: \(request.requestedScopes?.map { $0.rawValue } ?? [])")
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        // Store reference to prevent deallocation
        self.currentAuthController = authorizationController
        
        do {
            print("🚀 Launching authorization controller...")
            authorizationController.performRequests()
        } catch {
            print("❌ Failed to perform authorization request: \(error)")
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
        print("🧪 Simulating Apple Sign In for testing (Simulator)")
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Create mock user data for testing
            let mockUserIdentifier = "000000.mock.user.simulator.test"
            let mockEmail = "test@icloud.com"
            var mockNameComponents = PersonNameComponents()
            mockNameComponents.givenName = "Usuario"
            mockNameComponents.familyName = "Simulador"
            
            print("📊 Mock Apple ID Credential Data (Simulator):")
            print("   - User ID: \(mockUserIdentifier)")
            print("   - Email: \(mockEmail)")
            print("   - Full Name: Usuario Simulador")
            print("   - Real User Status: Simulated")
            print("   - Authentication Type: Mock/Testing")
            
            // Clear any previous error
            self.errorMessage = nil
            
            // Save mock user data
            self.saveAppleUser(
                identifier: mockUserIdentifier,
                email: mockEmail,
                fullName: mockNameComponents
            )
            
            self.isLoading = false
            
            print("✅ Apple Sign In simulation completed successfully")
            print("✅ User should now be authenticated and logged in")
        }
    }
    
    func checkAppleSignInStatus() {
        guard !userIdentifier.isEmpty else {
            print("🍎 No stored Apple user identifier")
            return
        }
        
        print("🍎 Checking Apple Sign In status for user: \(userIdentifier)")
        
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: userIdentifier) { [weak self] credentialState, error in
            DispatchQueue.main.async {
                switch credentialState {
                case .authorized:
                    print("✅ Apple Sign In status: Authorized")
                    self?.isAuthenticated = true
                case .revoked:
                    print("🚫 Apple Sign In status: Revoked")
                    self?.signOut()
                case .notFound:
                    print("❓ Apple Sign In status: Not Found")
                    self?.signOut()
                @unknown default:
                    print("🤷‍♂️ Apple Sign In status: Unknown")
                    break
                }
            }
        }
    }
    
    func signOut() {
        print("🍎 Signing out Apple user...")
        
        // Clear published properties
        isAuthenticated = false
        userIdentifier = ""
        userEmail = ""
        userFullName = ""
        errorMessage = nil
        
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: appleUserIdKey)
        UserDefaults.standard.removeObject(forKey: appleUserEmailKey)
        UserDefaults.standard.removeObject(forKey: appleUserNameKey)
        UserDefaults.standard.removeObject(forKey: isAppleUserKey)
        
        print("✅ Apple user signed out successfully")
    }
    
    // MARK: - Private Methods
    
    private func loadStoredAppleUser() {
        let storedId = UserDefaults.standard.string(forKey: appleUserIdKey) ?? ""
        let storedEmail = UserDefaults.standard.string(forKey: appleUserEmailKey) ?? ""
        let storedName = UserDefaults.standard.string(forKey: appleUserNameKey) ?? ""
        let isAppleUser = UserDefaults.standard.bool(forKey: isAppleUserKey)
        
        if !storedId.isEmpty && isAppleUser {
            userIdentifier = storedId
            userEmail = storedEmail
            userFullName = storedName
            
            print("🍎 Loaded stored Apple user:")
            print("   - ID: \(userIdentifier)")
            print("   - Email: \(userEmail)")
            print("   - Name: \(userFullName)")
            
            // Check if still authorized with Apple
            checkAppleSignInStatus()
        }
    }
    
    private func saveAppleUser(identifier: String, email: String?, fullName: PersonNameComponents?) {
        userIdentifier = identifier
        userEmail = email ?? ""
        
        // Format full name
        let firstName = fullName?.givenName ?? ""
        let lastName = fullName?.familyName ?? ""
        userFullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        
        // Save to UserDefaults
        UserDefaults.standard.set(identifier, forKey: appleUserIdKey)
        UserDefaults.standard.set(userEmail, forKey: appleUserEmailKey)
        UserDefaults.standard.set(userFullName, forKey: appleUserNameKey)
        UserDefaults.standard.set(true, forKey: isAppleUserKey)
        
        // Create/Update user profile
        UserProfileManager.shared.handleAppleSignIn(
            userID: identifier,
            fullName: fullName,
            email: email
        )
        
        // Mark as authenticated
        isAuthenticated = true
        
        print("✅ Apple user saved successfully:")
        print("   - ID: \(userIdentifier)")
        print("   - Email: \(userEmail)")
        print("   - Name: \(userFullName)")
    }
    
    private func handleAppleSignInError(_ error: Error) {
        print("❌ Apple Sign In error: \(error.localizedDescription)")
        print("   - Error domain: \(error._domain)")
        print("   - Error code: \(error._code)")
        
        // Clear auth controller reference
        currentAuthController = nil
        
        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled:
                errorMessage = "Inicio de sesión cancelado"
                print("   - Error type: Canceled (User dismissed the dialog)")
            case .failed:
                errorMessage = "Simulador no soporta Apple Sign In completamente"
                print("   - Error type: Failed (Code 1000 - often occurs in simulator)")
                print("   - Note: This may work on a real device")
            case .invalidResponse:
                errorMessage = "Respuesta inválida de Apple"
                print("   - Error type: Invalid Response")
            case .notHandled:
                errorMessage = "No se pudo procesar la solicitud"
                print("   - Error type: Not Handled")
            case .unknown:
                errorMessage = "Error desconocido (posible problema de simulador)"
                print("   - Error type: Unknown (Code 1000 often indicates simulator limitations)")
            @unknown default:
                errorMessage = "Error inesperado"
                print("   - Error type: Unknown Default")
            }
            
            // Special handling for code 1000 (common in simulator)
            if authError.code.rawValue == 1000 {
                print("🔧 Code 1000 Troubleshooting:")
                print("   - This error is common in iOS Simulator")
                print("   - Try testing on a real device")
                print("   - Ensure you're signed into iCloud in Settings")
                print("   - Check that Two-Factor Authentication is enabled")
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
        print("🍎 Apple Sign In completed successfully")
        
        // Clear controller reference
        currentAuthController = nil
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("❌ Failed to get Apple ID credential")
            handleAppleSignInError(NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get Apple ID credential"]))
            return
        }
        
        // Log received data for validation
        print("📊 Apple ID Credential Data:")
        print("   - User ID: \(appleIDCredential.user)")
        print("   - Email: \(appleIDCredential.email ?? "Not provided")")
        print("   - Full Name: \(appleIDCredential.fullName?.debugDescription ?? "Not provided")")
        print("   - Real User Status: \(appleIDCredential.realUserStatus.rawValue)")
        
        // Save user data
        saveAppleUser(
            identifier: appleIDCredential.user,
            email: appleIDCredential.email,
            fullName: appleIDCredential.fullName
        )
        
        isLoading = false
        
        print("✅ Apple Sign In process completed successfully")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Apple Sign In failed with error:")
        print("   - Error: \(error)")
        
        // Special handling for simulator - automatic fallback
        if isRunningInSimulator() {
            if let authError = error as? ASAuthorizationError, authError.code.rawValue == 1000 {
                print("🔧 Detected Code 1000 in simulator - activating automatic fallback")
                
                // Clear current controller
                currentAuthController = nil
                
                // Automatically start simulator fallback
                print("🧪 Starting automatic simulator fallback...")
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
            print("⚠️ Could not find window for Apple Sign In presentation")
            return UIWindow()
        }
        
        print("🍎 Presenting Apple Sign In on window: \(window)")
        return window
    }
}

// MARK: - Utility Extensions

extension AppleSignInManager {
    
    var isAppleUser: Bool {
        return UserDefaults.standard.bool(forKey: isAppleUserKey)
    }
    
    func clearError() {
        errorMessage = nil
    }
}
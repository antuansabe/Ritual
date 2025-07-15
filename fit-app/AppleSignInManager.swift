import Foundation
import SwiftUI
import AuthenticationServices
import os.log

class Lx00e402Z63gwc4vKEC97NhbZVDDCOfA: NSObject, ObservableObject {
    static let shared = Lx00e402Z63gwc4vKEC97NhbZVDDCOfA()
    
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Apple ID user data
    @Published var userIdentifier: String = ""
    @Published var userEmail: String = ""
    @Published var userFullName: String = ""
    
    // Secure storage reference
    private let secureStorage = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    // Keep reference to authorization controller
    private var currentAuthController: ASAuthorizationController?
    
    private override init() {
        super.init()
        yXb22uS13udUW2PzcqogePMDosGbx9QK()
    }
    
    // MARK: - Public Methods
    
    func jniddSZKEoGcms9So9T3uUpuM55PjT8X() {
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🍎 Starting Apple Sign In process...")
        #endif
        #endif
        
        // Check if Apple Sign In is available
        guard Brc76BXiWTpRMUCW64HYAghVdLwqpJX6() else {
            #if DEBUG
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("❌ Apple Sign In is not available on this device/simulator")
            #endif
            #endif
            M7SJqOUyVtGoqiEIEqMakhaDSxSFtzeQ(NSError(
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
            self.xSgtC9nrv1YtDcduZrTMwT9uuoJAWiW1()
        }
    }
    
    private func xSgtC9nrv1YtDcduZrTMwT9uuoJAWiW1() {
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🍎 Performing Apple Sign In request...")
        #endif
        #endif
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("📝 Request configured with scopes: \(request.requestedScopes?.map { $0.rawValue } ?? [])")
        #endif
        #endif
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        // Store reference to prevent deallocation
        self.currentAuthController = authorizationController
        
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🚀 Launching authorization controller...")
        #endif
        authorizationController.performRequests()
    }
    
    private func Brc76BXiWTpRMUCW64HYAghVdLwqpJX6() -> Bool {
        // Check if we're on iOS 13+ (should always be true for iOS 16+ target)
        if #available(iOS 13.0, *) {
            return true
        } else {
            return false
        }
    }
    
    private func xFKJmvFu18IS5KkkklUOat1lgqW9c7QX() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    // MARK: - Simulator Fallback
    
    private func fACAmbuTfkXKBEH3lLX7tqVg4DDOxUmu() {
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🧪 Simulating Apple Sign In for testing (Simulator)")
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
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("📊 Mock Apple ID Credential Data (Simulator):")
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - User ID: \(mockUserIdentifier)")
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Email: \(mockEmail)")
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Full Name: Usuario Simulador")
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Real User Status: Simulated")
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Authentication Type: Mock/Testing")
            #endif
            #endif
            
            // Clear any previous error
            self.errorMessage = nil
            
            // Save mock user data
            self.vIjmSSoKAxgRnJX3xmt3p4pZxE2V5RO7(
                identifier: mockUserIdentifier,
                email: mockEmail,
                fullName: mockNameComponents
            )
            
            self.isLoading = false
            
            #if DEBUG
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("✅ Apple Sign In simulation completed successfully")
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("✅ User should now be authenticated and logged in")
            #endif
            #endif
        }
    }
    
    func kvGFwCUlCmaJEUnAj1QJ2rdHtxiCBZeK() {
        guard !userIdentifier.isEmpty else {
            #if DEBUG
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🍎 No stored Apple user identifier")
            #endif
            #endif
            return
        }
        
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🍎 Checking Apple Sign In status for user: \(self.userIdentifier)")
        #endif
        #endif
        
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: userIdentifier) { [weak self] credentialState, error in
            DispatchQueue.main.async {
                switch credentialState {
                case .authorized:
                    #if DEBUG
                    #if DEBUG
                    Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("✅ Apple Sign In status: Authorized")
                    #endif
                    #endif
                    self?.isAuthenticated = true
                case .revoked:
                    #if DEBUG
                    #if DEBUG
                    Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🚫 Apple Sign In status: Revoked")
                    #endif
                    #endif
                    self?.xeZsiWBAd5pwKDqJFItOs5ErVipoJw0y()
                case .notFound:
                    #if DEBUG
                    #if DEBUG
                    Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("❓ Apple Sign In status: Not Found")
                    #endif
                    #endif
                    self?.xeZsiWBAd5pwKDqJFItOs5ErVipoJw0y()
                case .transferred:
                    #if DEBUG
                    #if DEBUG
                    Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔄 Apple Sign In status: Transferred")
                    #endif
                    #endif
                    self?.xeZsiWBAd5pwKDqJFItOs5ErVipoJw0y()
                @unknown default:
                    #if DEBUG
                    #if DEBUG
                    Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🤷‍♂️ Apple Sign In status: Unknown")
                    #endif
                    #endif
                    self?.xeZsiWBAd5pwKDqJFItOs5ErVipoJw0y()
                }
            }
        }
    }
    
    func xeZsiWBAd5pwKDqJFItOs5ErVipoJw0y() {
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🍎 Signing out Apple user...")
        #endif
        #endif
        
        // Clear published properties
        isAuthenticated = false
        userIdentifier = ""
        userEmail = ""
        userFullName = ""
        errorMessage = nil
        
        // Clear encrypted storage
        _ = secureStorage.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.NUWvelGURmEPxQVMA0XDK9YtVRsHFwPH)
        _ = secureStorage.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.OTpc1Uok1024oD57HxGmCgPZPXMSpvUT)
        _ = secureStorage.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.nJPxwctQXEypC5Lb9QpHK6jFZFwXzoAh)
        
        // Clear legacy UserDefaults for migration
        UserDefaults.standard.removeObject(forKey: "AppleUserIdentifier")
        UserDefaults.standard.removeObject(forKey: "AppleUserEmail")
        UserDefaults.standard.removeObject(forKey: "AppleUserName")
        UserDefaults.standard.removeObject(forKey: "IsAppleUser")
        
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("✅ Apple user signed out successfully")
        #endif
        #endif
    }
    
    // MARK: - Private Methods
    
    private func yXb22uS13udUW2PzcqogePMDosGbx9QK() {
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🍎 Loading stored Apple user data...")
        #endif
        #endif
        
        // Try to load from secure storage first
        let storedId = secureStorage.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.NUWvelGURmEPxQVMA0XDK9YtVRsHFwPH) ?? ""
        let storedEmail = secureStorage.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.OTpc1Uok1024oD57HxGmCgPZPXMSpvUT) ?? ""
        let storedName = secureStorage.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.nJPxwctQXEypC5Lb9QpHK6jFZFwXzoAh) ?? ""
        
        // If secure storage is empty, try to migrate from legacy UserDefaults
        if storedId.isEmpty {
            OTPZS8TtrF7MQnN2kGhob5senyl2sqnc()
            return
        }
        
        if !storedId.isEmpty {
            userIdentifier = storedId
            userEmail = storedEmail
            userFullName = storedName
            
            #if DEBUG
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🍎 Loaded stored Apple user from secure storage:")
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - ID: \(self.userIdentifier)")
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Email: \(self.userEmail.isEmpty ? "Not provided" : "***@***.***")")
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Name: \(self.userFullName.isEmpty ? "Not provided" : self.userFullName)")
            #endif
            #endif
            
            // Check if still authorized with Apple
            kvGFwCUlCmaJEUnAj1QJ2rdHtxiCBZeK()
        }
    }
    
    /// Migrate legacy Apple user data from UserDefaults to secure encrypted storage
    private func OTPZS8TtrF7MQnN2kGhob5senyl2sqnc() {
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔄 Attempting to migrate legacy Apple user data...")
        #endif
        #endif
        
        let legacyId = UserDefaults.standard.string(forKey: "AppleUserIdentifier") ?? ""
        let legacyEmail = UserDefaults.standard.string(forKey: "AppleUserEmail") ?? ""
        let legacyName = UserDefaults.standard.string(forKey: "AppleUserName") ?? ""
        let isAppleUser = UserDefaults.standard.bool(forKey: "IsAppleUser")
        
        if !legacyId.isEmpty && isAppleUser {
            #if DEBUG
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔄 Found legacy Apple user data, migrating to secure storage...")
            #endif
            #endif
            
            // Store in secure encrypted storage
            let success = secureStorage.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(legacyId, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.NUWvelGURmEPxQVMA0XDK9YtVRsHFwPH) &&
                         secureStorage.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(legacyEmail, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.OTpc1Uok1024oD57HxGmCgPZPXMSpvUT) &&
                         secureStorage.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(legacyName, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.nJPxwctQXEypC5Lb9QpHK6jFZFwXzoAh)
            
            if success {
                #if DEBUG
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("✅ Successfully migrated Apple user data to secure storage")
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
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🗑️ Cleared legacy UserDefaults after migration")
                #endif
                #endif
                
                // Check if still authorized with Apple
                kvGFwCUlCmaJEUnAj1QJ2rdHtxiCBZeK()
            } else {
                #if DEBUG
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("❌ Failed to migrate Apple user data to secure storage")
                #endif
                #endif
            }
        } else {
            #if DEBUG
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("ℹ️ No legacy Apple user data found to migrate")
            #endif
            #endif
        }
    }
    
    private func vIjmSSoKAxgRnJX3xmt3p4pZxE2V5RO7(identifier: String, email: String?, fullName: PersonNameComponents?) {
        userIdentifier = identifier
        userEmail = email ?? ""
        
        // Format full name
        let firstName = fullName?.givenName ?? ""
        let lastName = fullName?.familyName ?? ""
        userFullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        
        // Save to secure encrypted storage
        let success = secureStorage.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(identifier, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.NUWvelGURmEPxQVMA0XDK9YtVRsHFwPH) &&
                     secureStorage.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(userEmail, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.OTpc1Uok1024oD57HxGmCgPZPXMSpvUT) &&
                     secureStorage.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(userFullName, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.nJPxwctQXEypC5Lb9QpHK6jFZFwXzoAh)
        
        if success {
            #if DEBUG
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔐 Apple user data saved securely with encryption")
            #endif
            #endif
        } else {
            #if DEBUG
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("❌ Failed to save Apple user data securely")
            #endif
            #endif
        }
        
        // Create/Update user profile
        gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.XLsAtoDzYFzjbxLIJRLTXbnfXX8oyrg8(
            userID: identifier,
            fullName: fullName,
            email: email
        )
        
        // Mark as authenticated
        isAuthenticated = true
        
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("✅ Apple user saved successfully:")
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - ID: \(self.userIdentifier)")
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Email: \(self.userEmail.isEmpty ? "Not provided" : "***@***.***")")
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Name: \(self.userFullName.isEmpty ? "Not provided" : self.userFullName)")
        #endif
        #endif
    }
    
    private func M7SJqOUyVtGoqiEIEqMakhaDSxSFtzeQ(_ error: Error) {
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("❌ Apple Sign In error: \(error.localizedDescription)")
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Error domain: \(error._domain)")
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Error code: \(error._code)")
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
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Error type: Canceled (User dismissed the dialog)")
                #endif
                #endif
            case .failed:
                errorMessage = "Simulador no soporta Apple Sign In completamente"
                #if DEBUG
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Error type: Failed (Code 1000 - often occurs in simulator)")
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Note: This may work on a real device")
                #endif
                #endif
            case .invalidResponse:
                errorMessage = "Respuesta inválida de Apple"
                #if DEBUG
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Error type: Invalid Response")
                #endif
                #endif
            case .notHandled:
                errorMessage = "No se pudo procesar la solicitud"
                #if DEBUG
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Error type: Not Handled")
                #endif
                #endif
            case .unknown:
                errorMessage = "Error desconocido (posible problema de simulador)"
                #if DEBUG
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Error type: Unknown (Code 1000 often indicates simulator limitations)")
                #endif
                #endif
            case .notInteractive:
                errorMessage = "Sesión no interactiva"
                #if DEBUG
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Error type: Not Interactive")
                #endif
                #endif
            @unknown default:
                errorMessage = "Error inesperado"
                #if DEBUG
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Error type: Unknown Default")
                #endif
                #endif
            }
            
            // Special handling for code 1000 (common in simulator)
            if authError.code.rawValue == 1000 {
                #if DEBUG
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔧 Code 1000 Troubleshooting:")
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - This error is common in iOS Simulator")
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Try testing on a real device")
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Ensure you're signed into iCloud in Settings")
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Check that Two-Factor Authentication is enabled")
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

extension Lx00e402Z63gwc4vKEC97NhbZVDDCOfA: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🍎 Apple Sign In completed successfully")
        #endif
        #endif
        
        // Clear controller reference
        currentAuthController = nil
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            #if DEBUG
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("❌ Failed to get Apple ID credential")
            #endif
            #endif
            M7SJqOUyVtGoqiEIEqMakhaDSxSFtzeQ(NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get Apple ID credential"]))
            return
        }
        
        // Log received data for validation
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("📊 Apple ID Credential Data:")
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - User ID: \(appleIDCredential.user)")
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Email: \(appleIDCredential.email ?? "Not provided")")
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Full Name: \(appleIDCredential.fullName?.debugDescription ?? "Not provided")")
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Real User Status: \(appleIDCredential.realUserStatus.rawValue)")
        #endif
        #endif
        
        // Save user data
        vIjmSSoKAxgRnJX3xmt3p4pZxE2V5RO7(
            identifier: appleIDCredential.user,
            email: appleIDCredential.email,
            fullName: appleIDCredential.fullName
        )
        
        isLoading = false
        
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("✅ Apple Sign In process completed successfully")
        #endif
        #endif
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("❌ Apple Sign In failed with error:")
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("   - Error: \(error)")
        #endif
        #endif
        
        // Special handling for simulator - automatic fallback
        if xFKJmvFu18IS5KkkklUOat1lgqW9c7QX() {
            if let authError = error as? ASAuthorizationError, authError.code.rawValue == 1000 {
                #if DEBUG
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔧 Detected Code 1000 in simulator - activating automatic fallback")
                #endif
                #endif
                
                // Clear current controller
                currentAuthController = nil
                
                // Automatically start simulator fallback
                #if DEBUG
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🧪 Starting automatic simulator fallback...")
                #endif
                #endif
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.fACAmbuTfkXKBEH3lLX7tqVg4DDOxUmu()
                }
                return
            }
        }
        
        M7SJqOUyVtGoqiEIEqMakhaDSxSFtzeQ(error)
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension Lx00e402Z63gwc4vKEC97NhbZVDDCOfA: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            #if DEBUG
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("⚠️ Could not find window for Apple Sign In presentation")
            #endif
            #endif
            return UIWindow()
        }
        
        #if DEBUG
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🍎 Presenting Apple Sign In on window: \(window)")
        #endif
        #endif
        return window
    }
}

// MARK: - Utility Extensions

extension Lx00e402Z63gwc4vKEC97NhbZVDDCOfA {
    
    var U8E3vjZfnjwYRfkJUZx1CI7vi5s2E9z0: Bool {
        // Check if we have encrypted Apple user data
        let hasAppleUserID = secureStorage.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.NUWvelGURmEPxQVMA0XDK9YtVRsHFwPH) != nil
        
        // Also check legacy UserDefaults for migration
        let hasLegacyAppleUser = UserDefaults.standard.bool(forKey: "IsAppleUser")
        
        return hasAppleUserID || hasLegacyAppleUser
    }
    
    func EYA1lT4kx4ae526Okh9jsZgBxFHUOAsZ() {
        errorMessage = nil
    }
}
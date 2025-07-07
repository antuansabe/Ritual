import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    
    // Apple Sign In Manager
    @ObservedObject private var appleSignInManager = AppleSignInManager.shared
    
    // Dummy credentials
    private let dummyEmail = "test@test.com"
    private let dummyPassword = "123456"
    
    init() {
        // Check both authentication methods on init
        checkAuthenticationStatus()
        
        // Always listen to Apple authentication changes (even for new users)
        setupAppleAuthListener()
    }
    
    func login() {
        errorMessage = nil
        
        if email == dummyEmail && password == dummyPassword {
            isAuthenticated = true
        } else {
            errorMessage = "Email o contraseña incorrectos"
        }
    }
    
    func register() {
        errorMessage = nil
        
        if email.isEmpty {
            errorMessage = "El email no puede estar vacío"
            return
        }
        
        if password != confirmPassword {
            errorMessage = "Las contraseñas no coinciden"
            return
        }
        
        // Simulate successful registration
        isAuthenticated = true
    }
    
    func logout() {
        print("🚪 Logging out user...")
        
        // Check if user is signed in with Apple and sign them out
        if appleSignInManager.isAppleUser {
            print("   - Signing out Apple user")
            appleSignInManager.signOut()
        }
        
        // Clear regular authentication
        isAuthenticated = false
        email = ""
        password = ""
        confirmPassword = ""
        errorMessage = nil
        
        print("✅ User logged out successfully")
    }
    
    // MARK: - Authentication Status Check
    
    private func checkAuthenticationStatus() {
        print("🔍 Checking authentication status...")
        
        // Check Apple Sign In status for existing users
        if appleSignInManager.isAppleUser && !appleSignInManager.userIdentifier.isEmpty {
            print("   - Found existing Apple user, checking status...")
            appleSignInManager.checkAppleSignInStatus()
        }
        
        print("   - Current auth status: \(isAuthenticated)")
    }
    
    private func setupAppleAuthListener() {
        print("🔗 Setting up Apple authentication listener...")
        
        // Listen to Apple authentication changes (for both existing and new users)
        appleSignInManager.$isAuthenticated
            .sink { [weak self] isAppleAuthenticated in
                DispatchQueue.main.async {
                    if isAppleAuthenticated {
                        print("✅ Apple user authenticated - updating AuthViewModel")
                        self?.isAuthenticated = true
                    } else {
                        print("❌ Apple user not authenticated")
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()
}

import Combine
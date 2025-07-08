import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var showingGoodbye: Bool = false
    
    // Apple Sign In Manager
    @ObservedObject private var appleSignInManager = AppleSignInManager.shared
    
    // User Profile Manager
    @ObservedObject private var userProfileManager = UserProfileManager.shared
    
    // Secure Authentication Service
    private let secureAuth = SecureAuthService.shared
    
    init() {
        print("🔐 Initializing AuthViewModel...")
        
        // Check for existing authentication first
        checkForExistingAuthentication()
        
        // Check both authentication methods on init
        checkAuthenticationStatus()
        
        // Always listen to Apple authentication changes (even for new users)
        setupAppleAuthListener()
    }
    
    func login() {
        print("🔐 AuthViewModel: Starting secure login process")
        errorMessage = nil
        
        // Use secure authentication service
        let result = secureAuth.login(email: email, password: password)
        
        switch result {
        case .success(let user):
            print("🔐 AuthViewModel: Login successful for user: \(user.email)")
            isAuthenticated = true
            // Create user profile for secure login
            userProfileManager.handleRegularSignIn(email: user.email)
            
        case .failure(let error):
            print("🔐 AuthViewModel: Login failed - \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
    
    func register() {
        print("🔐 AuthViewModel: Starting secure registration process")
        errorMessage = nil
        
        // Use secure authentication service for registration
        let result = secureAuth.register(email: email, password: password, confirmPassword: confirmPassword)
        
        switch result {
        case .success(let user):
            print("🔐 AuthViewModel: Registration successful for user: \(user.email)")
            isAuthenticated = true
            // Create user profile for new registration
            userProfileManager.handleRegularSignIn(email: user.email)
            
        case .failure(let error):
            print("🔐 AuthViewModel: Registration failed - \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
    
    func logout() {
        print("🚪 Logging out user...")
        
        // Check if user is signed in with Apple and sign them out
        if appleSignInManager.isAppleUser {
            print("   - Signing out Apple user")
            appleSignInManager.signOut()
        } else {
            // Use secure authentication service for regular logout
            _ = secureAuth.logout()
        }
        
        // Sign out user profile
        userProfileManager.signOut()
        
        // Clear UserDefaults (for legacy data) - but preserve welcome flag
        UserDefaults.standard.removeObject(forKey: "userIdentifier")
        UserDefaults.standard.removeObject(forKey: "userFullName")
        UserDefaults.standard.removeObject(forKey: "userName")
        // Note: We intentionally keep "hasSeenWelcome" so returning users don't see welcome again
        
        // Instead of going directly to login, show goodbye screen first
        showingGoodbye = true
        
        // Clear authentication state but keep user logged in until goodbye is dismissed
        email = ""
        password = ""
        confirmPassword = ""
        errorMessage = nil
        
        print("✅ User data cleared, showing goodbye screen")
    }
    
    func signOut() {
        // Alias for logout to match the prompt requirements
        logout()
    }
    
    func completeLogout() {
        print("🏠 Completing logout process...")
        isAuthenticated = false
        showingGoodbye = false
        print("✅ User fully logged out, returning to login")
    }
    
    // MARK: - Welcome Flow Management
    
    func resetWelcomeFlag() {
        UserDefaults.standard.removeObject(forKey: "hasSeenWelcome")
        print("🔄 Welcome flag reset - next login will show welcome screen")
    }
    
    // MARK: - Authentication Status Check
    
    private func checkForExistingAuthentication() {
        print("🔍 Checking for existing authentication...")
        
        // Check if user is already authenticated via AppStorage
        if isAuthenticated {
            print("   - User already authenticated via AppStorage")
            return
        }
        
        // Check for Apple Sign In auto-login
        if appleSignInManager.isAppleUser && !appleSignInManager.userIdentifier.isEmpty {
            print("   - Found existing Apple user credentials")
            print("   - User ID: \(appleSignInManager.userIdentifier)")
            print("   - Email: \(appleSignInManager.userEmail)")
            print("   - Auto-logging in Apple user...")
            
            // Auto-login the Apple user
            DispatchQueue.main.async {
                self.isAuthenticated = true
                print("✅ Apple user auto-logged in successfully")
            }
        } else if secureAuth.isUserLoggedIn() {
            // Check for secure authentication session
            if let currentUser = secureAuth.getCurrentUser() {
                print("   - Found existing secure user session for: \(currentUser)")
                print("   - Auto-logging in secure user...")
                
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    self.email = currentUser
                    print("✅ Secure user auto-logged in successfully")
                }
            }
        }
    }
    
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
                        // Only log out if this was an Apple user previously
                        if self?.appleSignInManager.isAppleUser == true {
                            print("❌ Apple user lost authentication - logging out")
                            self?.handleAppleSignOut()
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleAppleSignOut() {
        print("🚪 Handling Apple Sign Out...")
        
        // Only clear authentication if user was logged in via Apple
        if appleSignInManager.isAppleUser {
            isAuthenticated = false
            print("✅ Apple user logged out from AuthViewModel")
        }
    }
    
    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()
}

import Combine
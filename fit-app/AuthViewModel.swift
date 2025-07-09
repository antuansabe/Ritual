import Foundation
import SwiftUI
import os.log

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
    
    // Secure Storage for sensitive data
    private let secureStorage = SecureStorage.shared
    
    init() {
        #if DEBUG
        print("🔐 Initializing AuthViewModel...")
        #endif
        
        // Check for existing authentication first
        checkForExistingAuthentication()
        
        // Check both authentication methods on init
        checkAuthenticationStatus()
        
        // Always listen to Apple authentication changes (even for new users)
        setupAppleAuthListener()
        
        // Migrate any legacy sensitive data to secure storage
        migrateLegacySensitiveData()
        
        // Test and verify secure storage (development)
        #if DEBUG
        _ = secureStorage.testSecureStorage()
        secureStorage.verifyMigrationStatus()
        #endif
    }
    
    // MARK: - Legacy Data Migration
    
    /// Migrate sensitive data from UserDefaults to SecureStorage
    private func migrateLegacySensitiveData() {
        #if DEBUG
        print("🔄 Checking for legacy sensitive data to migrate...")
        #endif
        
        var migrationOccurred = false
        
        // Migrate userName if it exists
        if let userName = UserDefaults.standard.string(forKey: "userName"), !userName.isEmpty {
            #if DEBUG
            print("🔄 Migrating userName to SecureStorage...")
            #endif
            if secureStorage.storeEncrypted(userName, for: SecureStorage.StorageKeys.userDisplayName) {
                UserDefaults.standard.removeObject(forKey: "userName")
                migrationOccurred = true
                #if DEBUG
                print("✅ Successfully migrated userName")
                #endif
            } else {
                #if DEBUG
                print("❌ Failed to migrate userName")
                #endif
            }
        }
        
        // Migrate userIdentifier if it exists
        if let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier"), !userIdentifier.isEmpty {
            #if DEBUG
            print("🔄 Migrating userIdentifier to SecureStorage...")
            #endif
            if secureStorage.storeEncrypted(userIdentifier, for: "user_identifier") {
                UserDefaults.standard.removeObject(forKey: "userIdentifier")
                migrationOccurred = true
                #if DEBUG
                print("✅ Successfully migrated userIdentifier")
                #endif
            } else {
                #if DEBUG
                print("❌ Failed to migrate userIdentifier")
                #endif
            }
        }
        
        // Migrate userFullName if it exists
        if let userFullName = UserDefaults.standard.string(forKey: "userFullName"), !userFullName.isEmpty {
            #if DEBUG
            print("🔄 Migrating userFullName to SecureStorage...")
            #endif
            if secureStorage.storeEncrypted(userFullName, for: SecureStorage.StorageKeys.userFullName) {
                UserDefaults.standard.removeObject(forKey: "userFullName")
                migrationOccurred = true
                #if DEBUG
                print("✅ Successfully migrated userFullName")
                #endif
            } else {
                #if DEBUG
                print("❌ Failed to migrate userFullName")
                #endif
            }
        }
        
        if migrationOccurred {
            #if DEBUG
            print("✅ Legacy sensitive data migration completed")
            #endif
        } else {
            #if DEBUG
            print("ℹ️ No legacy sensitive data found to migrate")
            #endif
        }
    }
    
    func login() {
        #if DEBUG
        print("🔐 AuthViewModel: Starting secure login process")
        #endif
        errorMessage = nil
        
        // Use secure authentication service
        let result = secureAuth.login(email: email, password: password)
        
        switch result {
        case .success(let user):
            #if DEBUG
            print("🔐 AuthViewModel: Login successful for user: \(user.email)")
            #endif
            isAuthenticated = true
            // Create user profile for secure login
            userProfileManager.handleRegularSignIn(email: user.email)
            
        case .failure(let error):
            #if DEBUG
            print("🔐 AuthViewModel: Login failed - \(error.localizedDescription)")
            #endif
            errorMessage = error.localizedDescription
        }
    }
    
    func register() {
        #if DEBUG
        print("🔐 AuthViewModel: Starting secure registration process")
        #endif
        errorMessage = nil
        
        // Use secure authentication service for registration
        let result = secureAuth.register(email: email, password: password, confirmPassword: confirmPassword)
        
        switch result {
        case .success(let user):
            #if DEBUG
            print("🔐 AuthViewModel: Registration successful for user: \(user.email)")
            #endif
            isAuthenticated = true
            // Create user profile for new registration
            userProfileManager.handleRegularSignIn(email: user.email)
            
        case .failure(let error):
            #if DEBUG
            print("🔐 AuthViewModel: Registration failed - \(error.localizedDescription)")
            #endif
            errorMessage = error.localizedDescription
        }
    }
    
    func logout() {
        #if DEBUG
        print("🚪 Logging out user...")
        #endif
        
        // Check if user is signed in with Apple and sign them out
        if appleSignInManager.isAppleUser {
            #if DEBUG
            print("   - Signing out Apple user")
            #endif
            appleSignInManager.signOut()
        } else {
            // Use secure authentication service for regular logout
            _ = secureAuth.logout()
        }
        
        // Sign out user profile
        userProfileManager.signOut()
        
        // Clear sensitive data from SecureStorage
        _ = secureStorage.delete(key: SecureStorage.StorageKeys.userFullName)
        _ = secureStorage.delete(key: SecureStorage.StorageKeys.userDisplayName)
        _ = secureStorage.delete(key: SecureStorage.StorageKeys.userEmail)
        _ = secureStorage.delete(key: SecureStorage.StorageKeys.userToken)
        
        // Clear legacy UserDefaults for migration (but preserve welcome flag)
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
        
        #if DEBUG
        print("✅ User data cleared, showing goodbye screen")
        #endif
    }
    
    func signOut() {
        // Alias for logout to match the prompt requirements
        logout()
    }
    
    func completeLogout() {
        #if DEBUG
        print("🏠 Completing logout process...")
        #endif
        isAuthenticated = false
        showingGoodbye = false
        #if DEBUG
        print("✅ User fully logged out, returning to login")
        #endif
    }
    
    // MARK: - Welcome Flow Management
    
    func resetWelcomeFlag() {
        UserDefaults.standard.removeObject(forKey: "hasSeenWelcome")
        #if DEBUG
        print("🔄 Welcome flag reset - next login will show welcome screen")
        #endif
    }
    
    // MARK: - Authentication Status Check
    
    private func checkForExistingAuthentication() {
        #if DEBUG
        print("🔍 Checking for existing authentication...")
        #endif
        
        // Check if user is already authenticated via AppStorage
        if isAuthenticated {
            #if DEBUG
            print("   - User already authenticated via AppStorage")
            #endif
            return
        }
        
        // Check for Apple Sign In auto-login
        if appleSignInManager.isAppleUser && !appleSignInManager.userIdentifier.isEmpty {
            #if DEBUG
            print("   - Found existing Apple user credentials")
            print("   - User ID: \(appleSignInManager.userIdentifier)")
            print("   - Email: \(appleSignInManager.userEmail)")
            print("   - Auto-logging in Apple user...")
            #endif
            
            // Auto-login the Apple user
            DispatchQueue.main.async {
                self.isAuthenticated = true
                #if DEBUG
                print("✅ Apple user auto-logged in successfully")
                #endif
            }
        } else if secureAuth.isUserLoggedIn() {
            // Check for secure authentication session
            if let currentUser = secureAuth.getCurrentUser() {
                #if DEBUG
                print("   - Found existing secure user session for: \(currentUser)")
                print("   - Auto-logging in secure user...")
                #endif
                
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    self.email = currentUser
                    #if DEBUG
                    print("✅ Secure user auto-logged in successfully")
                    #endif
                }
            }
        }
    }
    
    private func checkAuthenticationStatus() {
        #if DEBUG
        print("🔍 Checking authentication status...")
        #endif
        
        // Check Apple Sign In status for existing users
        if appleSignInManager.isAppleUser && !appleSignInManager.userIdentifier.isEmpty {
            #if DEBUG
            print("   - Found existing Apple user, checking status...")
            #endif
            appleSignInManager.checkAppleSignInStatus()
        }
        
        #if DEBUG
        print("   - Current auth status: \(isAuthenticated)")
        #endif
    }
    
    private func setupAppleAuthListener() {
        #if DEBUG
        print("🔗 Setting up Apple authentication listener...")
        #endif
        
        // Listen to Apple authentication changes (for both existing and new users)
        appleSignInManager.$isAuthenticated
            .sink { [weak self] isAppleAuthenticated in
                DispatchQueue.main.async {
                    if isAppleAuthenticated {
                        #if DEBUG
                        print("✅ Apple user authenticated - updating AuthViewModel")
                        #endif
                        self?.isAuthenticated = true
                    } else {
                        // Only log out if this was an Apple user previously
                        if self?.appleSignInManager.isAppleUser == true {
                            #if DEBUG
                            print("❌ Apple user lost authentication - logging out")
                            #endif
                            self?.handleAppleSignOut()
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleAppleSignOut() {
        #if DEBUG
        print("🚪 Handling Apple Sign Out...")
        #endif
        
        // Only clear authentication if user was logged in via Apple
        if appleSignInManager.isAppleUser {
            isAuthenticated = false
            #if DEBUG
            print("✅ Apple user logged out from AuthViewModel")
            #endif
        }
    }
    
    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()
}

import Combine
import Foundation
import SwiftUI
import AuthenticationServices
import Combine
import os.log

class M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // User info from Apple ID
    @Published var currentUserID: String = ""
    @Published var currentUserEmail: String = ""
    @Published var currentUserName: String = ""
    
    // MARK: - Private Properties
    
    private let appleSignInManager = Lx00e402Z63gwc4vKEC97NhbZVDDCOfA.shared
    private let secureStorage = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    private let userProfileManager = gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Storage Keys
    
    private struct StorageKeys {
        static let userAppleID = "userAppleID"
        static let userEmail = "userEmail" 
        static let userName = "userName"
        static let isLoggedIn = "isLoggedIn"
    }
    
    // MARK: - Initialization
    
    init() {
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔐 Initializing AuthViewModel for Apple ID only")
        #endif
        
        setupAppleSignInObservation()
        checkExistingAuthentication()
    }
    
    // MARK: - Public Methods
    
    /// Signs in with Apple ID
    func jniddSZKEoGcms9So9T3uUpuM55PjT8X() {
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🍎 Starting Apple Sign In")
        #endif
        
        isLoading = true
        errorMessage = nil
        
        appleSignInManager.jniddSZKEoGcms9So9T3uUpuM55PjT8X()
    }
    
    /// Signs out the current user
    func xeZsiWBAd5pwKDqJFItOs5ErVipoJw0y() {
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🚪 Signing out user")
        #endif
        
        Task { @MainActor in
            // Clear stored authentication data
            await clearAuthenticationData()
            
            // Sign out from Apple Sign In Manager
            appleSignInManager.xeZsiWBAd5pwKDqJFItOs5ErVipoJw0y()
            
            // Update UI state
            isLoggedIn = false
            currentUserID = ""
            currentUserEmail = ""
            currentUserName = ""
            errorMessage = nil
            
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("✅ User signed out successfully")
            #endif
        }
    }
    
    /// Clears error message
    func clearError() {
        errorMessage = nil
    }
    
    /// Resets welcome state for testing
    func ztuC6ouObpK3d02zNnL26mSYTqqAWYcM() {
        UserDefaults.standard.removeObject(forKey: "hasShownWelcome")
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔄 Welcome state reset for testing")
        #endif
    }
    
    // MARK: - Private Methods
    
    /// Sets up observation of Apple Sign In Manager state changes
    private func setupAppleSignInObservation() {
        // Observe Apple Sign In authentication state
        appleSignInManager.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                self?.handleAppleAuthenticationChange(isAuthenticated)
            }
            .store(in: &cancellables)
        
        // Observe Apple Sign In loading state
        appleSignInManager.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.isLoading = isLoading
            }
            .store(in: &cancellables)
        
        // Observe Apple Sign In errors
        appleSignInManager.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let error = errorMessage {
                    self?.errorMessage = error
                    self?.isLoading = false
                }
            }
            .store(in: &cancellables)
        
        // Observe user data changes
        appleSignInManager.$userIdentifier
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userID in
                if !userID.isEmpty {
                    self?.currentUserID = userID
                    self?.saveUserData()
                }
            }
            .store(in: &cancellables)
        
        appleSignInManager.$userEmail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] email in
                self?.currentUserEmail = email
                self?.saveUserData()
            }
            .store(in: &cancellables)
        
        appleSignInManager.$userFullName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fullName in
                self?.currentUserName = fullName
                self?.saveUserData()
            }
            .store(in: &cancellables)
    }
    
    /// Handles Apple authentication state changes
    private func handleAppleAuthenticationChange(_ isAuthenticated: Bool) {
        #if DEBUG
        Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🍎 Apple authentication changed: \(isAuthenticated)")
        #endif
        
        Task { @MainActor in
            if isAuthenticated {
                // User successfully authenticated
                await saveAuthenticationState(true)
                isLoggedIn = true
                errorMessage = nil
                
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("✅ User authenticated successfully")
                #endif
            } else {
                // Authentication lost or failed
                await clearAuthenticationData()
                isLoggedIn = false
                
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("❌ User authentication lost")
                #endif
            }
            
            isLoading = false
        }
    }
    
    /// Checks for existing authentication on app launch
    private func checkExistingAuthentication() {
        Task { @MainActor in
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🔍 Checking existing authentication")
            #endif
            
            // Load stored authentication state
            let storedLoggedIn = await loadAuthenticationState()
            let storedUserID = await loadUserData()
            
            if storedLoggedIn && !storedUserID.isEmpty {
                // Check if Apple ID is still valid
                appleSignInManager.kvGFwCUlCmaJEUnAj1QJ2rdHtxiCBZeK()
                
                // Load user data
                currentUserID = storedUserID
                currentUserEmail = await loadStoredValue(StorageKeys.userEmail) ?? ""
                currentUserName = await loadStoredValue(StorageKeys.userName) ?? ""
                
                isLoggedIn = true
                
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("✅ Existing authentication found for user: \(storedUserID)")
                #endif
            } else {
                isLoggedIn = false
                
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("ℹ️ No existing authentication found")
                #endif
            }
        }
    }
    
    /// Saves authentication state to secure storage
    private func saveAuthenticationState(_ isAuthenticated: Bool) async {
        do {
            try secureStorage.r0AqoYxLhfNYCN9Nib0HLfzhDAmXp8ry(
                isAuthenticated ? "true" : "false",
                for: StorageKeys.isLoggedIn
            )
            
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("💾 Authentication state saved: \(isAuthenticated)")
            #endif
        } catch {
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.error("❌ Failed to save authentication state: \(error.localizedDescription)")
            #endif
        }
    }
    
    /// Loads authentication state from secure storage
    private func loadAuthenticationState() async -> Bool {
        do {
            let storedValue = try secureStorage.eXGEhDZR5F3a9M8RnmLQbPuTTK0QyTsR(StorageKeys.isLoggedIn)
            return storedValue == "true"
        } catch {
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("ℹ️ No stored authentication state found")
            #endif
            return false
        }
    }
    
    /// Saves user data to secure storage
    private func saveUserData() {
        Task {
            do {
                // Save Apple ID (most critical)
                if !currentUserID.isEmpty {
                    try secureStorage.r0AqoYxLhfNYCN9Nib0HLfzhDAmXp8ry(currentUserID, for: StorageKeys.userAppleID)
                }
                
                // Save email if available
                if !currentUserEmail.isEmpty {
                    try secureStorage.r0AqoYxLhfNYCN9Nib0HLfzhDAmXp8ry(currentUserEmail, for: StorageKeys.userEmail)
                }
                
                // Save name if available
                if !currentUserName.isEmpty {
                    try secureStorage.r0AqoYxLhfNYCN9Nib0HLfzhDAmXp8ry(currentUserName, for: StorageKeys.userName)
                }
                
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("💾 User data saved to secure storage")
                #endif
            } catch {
                #if DEBUG
                Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.error("❌ Failed to save user data: \(error.localizedDescription)")
                #endif
            }
        }
    }
    
    /// Loads user data from secure storage
    private func loadUserData() async -> String {
        do {
            return try secureStorage.eXGEhDZR5F3a9M8RnmLQbPuTTK0QyTsR(StorageKeys.userAppleID) ?? ""
        } catch {
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("ℹ️ No stored user ID found")
            #endif
            return ""
        }
    }
    
    /// Loads a specific stored value
    private func loadStoredValue(_ key: String) async -> String? {
        do {
            return try secureStorage.eXGEhDZR5F3a9M8RnmLQbPuTTK0QyTsR(key)
        } catch {
            return nil
        }
    }
    
    /// Clears all authentication data
    func clearAuthenticationData() async {
        do {
            try secureStorage.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(StorageKeys.userAppleID)
            try secureStorage.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(StorageKeys.userEmail)
            try secureStorage.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(StorageKeys.userName)
            try secureStorage.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(StorageKeys.isLoggedIn)
            
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("🗑️ Authentication data cleared from secure storage")
            #endif
        } catch {
            #if DEBUG
            Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3.debug("ℹ️ Some authentication data may not have existed")
            #endif
        }
    }
}
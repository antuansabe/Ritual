import Foundation
import CoreData
import SwiftUI

class UserProfileManager: ObservableObject {
    static let shared = UserProfileManager()
    
    @Published var currentUser: UserProfile?
    @Published var displayName: String = "Atleta"
    
    private let context = PersistenceController.shared.container.viewContext
    private let encryptionHelper = DataEncryptionHelper.shared
    
    private init() {
        loadCurrentUser()
    }
    
    // MARK: - User Profile Management
    
    func loadCurrentUser() {
        print("[U+1F464] Loading current user profile...")
        
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        request.predicate = NSPredicate(format: "isActive == YES")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \UserProfile.lastUpdated, ascending: false)]
        request.fetchLimit = 1
        
        do {
            let users = try context.fetch(request)
            if let user = users.first {
                // Decrypt sensitive fields after fetching
                decryptUserProfileFields(user)
                
                print("[OK] Found existing user: \(user.fullName ?? "Unknown")")
                currentUser = user
                displayName = user.fullName ?? "Atleta"
            } else {
                print("ℹ️ No active user found")
                // Don't create default user here - wait for authentication
            }
        } catch {
            print("[ERR] Error loading current user: \(error)")
        }
    }
    
    func createOrUpdateUserProfile(
        fullName: String?,
        email: String?,
        appleUserID: String? = nil,
        authType: String = "email"
    ) {
        print("[U+1F464] Creating/updating user profile...")
        print("   - Name: \(fullName ?? "Not provided")")
        print("   - Email: \(email ?? "Not provided")")
        print("   - Auth Type: \(authType)")
        
        // Check if user already exists (for Apple ID users)
        if let appleID = appleUserID, !appleID.isEmpty {
            let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
            request.predicate = NSPredicate(format: "appleUserID == %@", appleID)
            
            do {
                let existingUsers = try context.fetch(request)
                if let existingUser = existingUsers.first {
                    print("[OK] Updating existing Apple user")
                    updateExistingUser(existingUser, fullName: fullName, email: email)
                    return
                }
            } catch {
                print("[ERR] Error checking for existing Apple user: \(error)")
            }
        }
        
        // Deactivate previous users
        deactivateAllUsers()
        
        // Create new user
        let newUser = UserProfile(context: context)
        newUser.id = UUID()
        newUser.fullName = fullName ?? ""
        newUser.email = email ?? ""
        newUser.appleUserID = appleUserID
        newUser.authType = authType
        newUser.isActive = true
        newUser.createdDate = Date()
        newUser.lastUpdated = Date()
        
        saveUserProfile(newUser)
    }
    
    private func updateExistingUser(_ user: UserProfile, fullName: String?, email: String?) {
        // Update user info if provided
        if let name = fullName, !name.isEmpty {
            user.fullName = name
        }
        if let userEmail = email, !userEmail.isEmpty {
            user.email = userEmail
        }
        
        // Reactivate and update timestamp
        user.isActive = true
        user.lastUpdated = Date()
        
        saveUserProfile(user)
    }
    
    private func deactivateAllUsers() {
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        request.predicate = NSPredicate(format: "isActive == YES")
        
        do {
            let activeUsers = try context.fetch(request)
            for user in activeUsers {
                user.isActive = false
            }
        } catch {
            print("[ERR] Error deactivating users: \(error)")
        }
    }
    
    private func saveUserProfile(_ user: UserProfile) {
        // Encrypt sensitive fields before saving
        encryptUserProfileFields(user)
        
        do {
            try context.save()
            
            // Decrypt fields again for immediate use
            decryptUserProfileFields(user)
            
            DispatchQueue.main.async {
                self.currentUser = user
                self.displayName = user.fullName ?? "Atleta"
                print("[OK] User profile saved: \(user.fullName ?? "Unknown")")
            }
        } catch {
            print("[ERR] Error saving user profile: \(error)")
        }
    }
    
    // MARK: - Apple Sign In Integration
    
    func handleAppleSignIn(userID: String, fullName: PersonNameComponents?, email: String?) {
        print("[U+1F34E] Handling Apple Sign In for user profile...")
        
        let name = formatAppleFullName(fullName)
        
        createOrUpdateUserProfile(
            fullName: name,
            email: email,
            appleUserID: userID,
            authType: "apple"
        )
    }
    
    private func formatAppleFullName(_ nameComponents: PersonNameComponents?) -> String? {
        guard let nameComponents = nameComponents else { return nil }
        
        let firstName = nameComponents.givenName ?? ""
        let lastName = nameComponents.familyName ?? ""
        let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        
        return fullName.isEmpty ? nil : fullName
    }
    
    // MARK: - Regular Authentication Integration
    
    func handleRegularSignIn(email: String) {
        print("[U+1F4E7] Handling regular sign in for user profile...")
        
        // Extract name from email or use default
        let name = extractNameFromEmail(email)
        
        createOrUpdateUserProfile(
            fullName: name,
            email: email,
            authType: "email"
        )
    }
    
    private func extractNameFromEmail(_ email: String) -> String {
        // Simple name extraction from email
        let components = email.components(separatedBy: "@")
        guard let username = components.first else { return "Usuario" }
        
        // Capitalize first letter and clean up
        let cleanUsername = username.replacingOccurrences(of: ".", with: " ")
                                  .replacingOccurrences(of: "_", with: " ")
                                  .replacingOccurrences(of: "-", with: " ")
        
        return cleanUsername.capitalized
    }
    
    // MARK: - User Management
    
    func signOut() {
        print("[U+1F6AA] Signing out user profile...")
        
        if let user = currentUser {
            user.isActive = false
            try? context.save()
        }
        
        DispatchQueue.main.async {
            self.currentUser = nil
            self.displayName = "Atleta"
        }
        
        print("[OK] User signed out successfully")
    }
    
    // MARK: - Data Encryption Methods
    
    /// Encrypt sensitive UserProfile fields before saving to Core Data
    /// Fields encrypted: email, fullName, appleUserID
    private func encryptUserProfileFields(_ user: UserProfile) {
        let sensitiveFields = ["email", "fullName", "appleUserID"]
        encryptionHelper.encryptEntityFields(user, sensitiveFields: sensitiveFields)
    }
    
    /// Decrypt sensitive UserProfile fields after fetching from Core Data
    /// Fields decrypted: email, fullName, appleUserID
    private func decryptUserProfileFields(_ user: UserProfile) {
        let sensitiveFields = ["email", "fullName", "appleUserID"]
        encryptionHelper.decryptEntityFields(user, sensitiveFields: sensitiveFields)
    }
    
    /// Migrate existing unencrypted user profiles to encrypted storage
    /// Call this method during app updates to encrypt existing data
    func migrateUserProfilesToEncrypted() {
        print("[SYNC] Starting UserProfile encryption migration...")
        
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        
        do {
            let allUsers = try context.fetch(request)
            var migratedCount = 0
            
            for user in allUsers {
                // Check if any field needs encryption (not already prefixed with "encrypted_")
                let needsEncryption = (user.email?.hasPrefix("encrypted_") == false && !user.email!.isEmpty) ||
                                     (user.fullName?.hasPrefix("encrypted_") == false && !user.fullName!.isEmpty) ||
                                     (user.appleUserID?.hasPrefix("encrypted_") == false && !user.appleUserID!.isEmpty)
                
                if needsEncryption {
                    encryptUserProfileFields(user)
                    migratedCount += 1
                }
            }
            
            if migratedCount > 0 {
                try context.save()
                print("[OK] Successfully migrated \(migratedCount) user profiles to encrypted storage")
            } else {
                print("ℹ️ No user profiles needed encryption migration")
            }
            
        } catch {
            print("[ERR] Error migrating user profiles to encrypted storage: \(error)")
        }
    }
    
    // MARK: - Name Management
    
    func updateDisplayName(_ newName: String) {
        print("✏️ Updating display name to: \(newName)")
        
        // Update current user if exists
        if let user = currentUser {
            user.fullName = newName
            user.lastUpdated = Date()
            
            do {
                try context.save()
                DispatchQueue.main.async {
                    self.displayName = newName
                }
                print("[OK] Display name updated successfully")
            } catch {
                print("[ERR] Error updating display name: \(error)")
            }
        } else {
            // If no current user, just update the display name locally
            DispatchQueue.main.async {
                self.displayName = newName
            }
        }
    }
    
    // MARK: - Utility Methods
    
    var formattedDisplayName: String {
        if displayName.isEmpty || displayName == "Atleta" {
            return "Atleta"
        }
        
        // Return first name only for cleaner display
        let components = displayName.components(separatedBy: " ")
        return components.first ?? displayName
    }
    
    var hasValidUser: Bool {
        return currentUser != nil && !displayName.isEmpty && displayName != "Atleta"
    }
}
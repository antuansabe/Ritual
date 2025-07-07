import Foundation
import CoreData
import SwiftUI

class UserProfileManager: ObservableObject {
    static let shared = UserProfileManager()
    
    @Published var currentUser: UserProfile?
    @Published var displayName: String = "Atleta"
    
    private let context = PersistenceController.shared.container.viewContext
    
    private init() {
        loadCurrentUser()
    }
    
    // MARK: - User Profile Management
    
    func loadCurrentUser() {
        print("👤 Loading current user profile...")
        
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        request.predicate = NSPredicate(format: "isActive == YES")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \UserProfile.lastUpdated, ascending: false)]
        request.fetchLimit = 1
        
        do {
            let users = try context.fetch(request)
            if let user = users.first {
                print("✅ Found existing user: \(user.fullName ?? "Unknown")")
                currentUser = user
                displayName = user.fullName ?? "Atleta"
            } else {
                print("ℹ️ No active user found")
                // Don't create default user here - wait for authentication
            }
        } catch {
            print("❌ Error loading current user: \(error)")
        }
    }
    
    func createOrUpdateUserProfile(
        fullName: String?,
        email: String?,
        appleUserID: String? = nil,
        authType: String = "email"
    ) {
        print("👤 Creating/updating user profile...")
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
                    print("✅ Updating existing Apple user")
                    updateExistingUser(existingUser, fullName: fullName, email: email)
                    return
                }
            } catch {
                print("❌ Error checking for existing Apple user: \(error)")
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
            print("❌ Error deactivating users: \(error)")
        }
    }
    
    private func saveUserProfile(_ user: UserProfile) {
        do {
            try context.save()
            
            DispatchQueue.main.async {
                self.currentUser = user
                self.displayName = user.fullName ?? "Atleta"
                print("✅ User profile saved: \(user.fullName ?? "Unknown")")
            }
        } catch {
            print("❌ Error saving user profile: \(error)")
        }
    }
    
    // MARK: - Apple Sign In Integration
    
    func handleAppleSignIn(userID: String, fullName: PersonNameComponents?, email: String?) {
        print("🍎 Handling Apple Sign In for user profile...")
        
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
        print("📧 Handling regular sign in for user profile...")
        
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
        print("🚪 Signing out user profile...")
        
        if let user = currentUser {
            user.isActive = false
            try? context.save()
        }
        
        DispatchQueue.main.async {
            self.currentUser = nil
            self.displayName = "Atleta"
        }
        
        print("✅ User signed out successfully")
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
                print("✅ Display name updated successfully")
            } catch {
                print("❌ Error updating display name: \(error)")
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
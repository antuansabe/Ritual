import Foundation
import CoreData
import SwiftUI

class gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm: ObservableObject {
    static let DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX = gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm()
    
    @Published var d9dQusQ5q74vqBDR4S2x6ngkHlz4Fq84: UserProfile?
    @Published var YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8: String = "Atleta"
    
    private let LxRQFrCsbBQtFCOyayxupkzFJLlXJonD = GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext
    private let mU9gHEuxcn7VLdocTIGS2xdQ3QLbe8G9 = vay7tnBoye1SjsSNdjoJ3ppSfXcJnGkY.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    private init() {
        vqiJRYE0o7JnbzD0bp73RIznfxd8bsB9()
    }
    
    // MARK: - User Profile Management
    
    func vqiJRYE0o7JnbzD0bp73RIznfxd8bsB9() {
        print("👤 Loading current user profile...")
        
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        request.predicate = NSPredicate(format: "isActive == YES")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \UserProfile.lastUpdated, ascending: false)]
        request.fetchLimit = 1
        
        do {
            let users = try LxRQFrCsbBQtFCOyayxupkzFJLlXJonD.fetch(request)
            if let user = users.first {
                // Decrypt sensitive fields after fetching
                ls6wDJGux7rJUmLBmzH2diFiZnhfU8br(user)
                
                print("✅ Found existing user: \(user.fullName ?? "Unknown")")
                d9dQusQ5q74vqBDR4S2x6ngkHlz4Fq84 = user
                YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8 = user.fullName ?? "Atleta"
            } else {
                print("ℹ️ No active user found")
                // Don't create default user here - wait for authentication
            }
        } catch {
            print("❌ Error loading current user: \(error)")
        }
    }
    
    func sx4erNyLwKClHxc8yV0biEQC4ympLRwL(
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
                let existingUsers = try LxRQFrCsbBQtFCOyayxupkzFJLlXJonD.fetch(request)
                if let existingUser = existingUsers.first {
                    print("✅ Updating existing Apple user")
                    gBeGai4FXv9tNz73CKWSoNsRZ39qmLT5(existingUser, fullName: fullName, email: email)
                    return
                }
            } catch {
                print("❌ Error checking for existing Apple user: \(error)")
            }
        }
        
        // Deactivate previous users
        qULoZZGD09tPhCCLeOkbUPpBOeuFuaF1()
        
        // Create new user
        let newUser = UserProfile(context: LxRQFrCsbBQtFCOyayxupkzFJLlXJonD)
        newUser.id = UUID()
        newUser.fullName = fullName ?? ""
        newUser.email = email ?? ""
        newUser.appleUserID = appleUserID
        newUser.authType = authType
        newUser.isActive = true
        newUser.createdDate = Date()
        newUser.lastUpdated = Date()
        
        buUsQKESD8YPoXMtIE6NnjSd8LZRc7Oh(newUser)
    }
    
    private func gBeGai4FXv9tNz73CKWSoNsRZ39qmLT5(_ user: UserProfile, fullName: String?, email: String?) {
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
        
        buUsQKESD8YPoXMtIE6NnjSd8LZRc7Oh(user)
    }
    
    private func qULoZZGD09tPhCCLeOkbUPpBOeuFuaF1() {
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        request.predicate = NSPredicate(format: "isActive == YES")
        
        do {
            let activeUsers = try LxRQFrCsbBQtFCOyayxupkzFJLlXJonD.fetch(request)
            for user in activeUsers {
                user.isActive = false
            }
        } catch {
            print("❌ Error deactivating users: \(error)")
        }
    }
    
    private func buUsQKESD8YPoXMtIE6NnjSd8LZRc7Oh(_ user: UserProfile) {
        // Encrypt sensitive fields before saving
        JE96dRWgGatCJyNhppjBJyVIG0rifx9g(user)
        
        do {
            try LxRQFrCsbBQtFCOyayxupkzFJLlXJonD.save()
            
            // Decrypt fields again for immediate use
            ls6wDJGux7rJUmLBmzH2diFiZnhfU8br(user)
            
            DispatchQueue.main.async {
                self.d9dQusQ5q74vqBDR4S2x6ngkHlz4Fq84 = user
                self.YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8 = user.fullName ?? "Atleta"
                print("✅ User profile saved: \(user.fullName ?? "Unknown")")
            }
        } catch {
            print("❌ Error saving user profile: \(error)")
        }
    }
    
    // MARK: - Apple Sign In Integration
    
    func XLsAtoDzYFzjbxLIJRLTXbnfXX8oyrg8(userID: String, fullName: PersonNameComponents?, email: String?) {
        print("🍎 Handling Apple Sign In for user profile...")
        
        let name = GWM3cyoi4veEgaYkitb8A5BfFqbiRjOe(fullName)
        
        sx4erNyLwKClHxc8yV0biEQC4ympLRwL(
            fullName: name,
            email: email,
            appleUserID: userID,
            authType: "apple"
        )
    }
    
    private func GWM3cyoi4veEgaYkitb8A5BfFqbiRjOe(_ nameComponents: PersonNameComponents?) -> String? {
        guard let nameComponents = nameComponents else { return nil }
        
        let firstName = nameComponents.givenName ?? ""
        let lastName = nameComponents.familyName ?? ""
        let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        
        return fullName.isEmpty ? nil : fullName
    }
    
    // MARK: - Regular Authentication Integration
    
    func vjYKdXVeyxIwMaRLPlJSwWYiL1A4pB5D(email: String) {
        print("📧 Handling regular sign in for user profile...")
        
        // Extract name from email or use default
        let name = Uo3nbpu47rPSh1adNPuoJNkw177gUMin(email)
        
        sx4erNyLwKClHxc8yV0biEQC4ympLRwL(
            fullName: name,
            email: email,
            authType: "email"
        )
    }
    
    private func Uo3nbpu47rPSh1adNPuoJNkw177gUMin(_ email: String) -> String {
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
    
    func xeZsiWBAd5pwKDqJFItOs5ErVipoJw0y() {
        print("🛚 Signing out user profile...")
        
        if let user = d9dQusQ5q74vqBDR4S2x6ngkHlz4Fq84 {
            user.isActive = false
            try? LxRQFrCsbBQtFCOyayxupkzFJLlXJonD.save()
        }
        
        DispatchQueue.main.async {
            self.d9dQusQ5q74vqBDR4S2x6ngkHlz4Fq84 = nil
            self.YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8 = "Atleta"
        }
        
        print("✅ User signed out successfully")
    }
    
    // MARK: - Data Encryption Methods
    
    /// Encrypt sensitive UserProfile fields before saving to Core Data
    /// Fields encrypted: email, fullName, appleUserID
    private func JE96dRWgGatCJyNhppjBJyVIG0rifx9g(_ user: UserProfile) {
        let sensitiveFields = ["email", "fullName", "appleUserID"]
        mU9gHEuxcn7VLdocTIGS2xdQ3QLbe8G9.Branog4ORGjtEDKucIDJWHR5zjzkdtNF(user, sensitiveFields: sensitiveFields)
    }
    
    /// Decrypt sensitive UserProfile fields after fetching from Core Data
    /// Fields decrypted: email, fullName, appleUserID
    private func ls6wDJGux7rJUmLBmzH2diFiZnhfU8br(_ user: UserProfile) {
        let sensitiveFields = ["email", "fullName", "appleUserID"]
        mU9gHEuxcn7VLdocTIGS2xdQ3QLbe8G9.P5gsNJ8awglJCaUzUFohz3s7w9tvoPXT(user, sensitiveFields: sensitiveFields)
    }
    
    /// Migrate existing unencrypted user profiles to encrypted storage
    /// Call this method during app updates to encrypt existing data
    func HtJbuUsUL4vbpuWz0U4pwmCShyqjpYN3() {
        print("🔄 Starting UserProfile encryption migration...")
        
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        
        do {
            let allUsers = try LxRQFrCsbBQtFCOyayxupkzFJLlXJonD.fetch(request)
            var migratedCount = 0
            
            for user in allUsers {
                // Check if any field needs encryption (not already prefixed with "encrypted_")
                let needsEncryption = (user.email?.hasPrefix("encrypted_") == false && !user.email!.isEmpty) ||
                                     (user.fullName?.hasPrefix("encrypted_") == false && !user.fullName!.isEmpty) ||
                                     (user.appleUserID?.hasPrefix("encrypted_") == false && !user.appleUserID!.isEmpty)
                
                if needsEncryption {
                    JE96dRWgGatCJyNhppjBJyVIG0rifx9g(user)
                    migratedCount += 1
                }
            }
            
            if migratedCount > 0 {
                try LxRQFrCsbBQtFCOyayxupkzFJLlXJonD.save()
                print("✅ Successfully migrated \(migratedCount) user profiles to encrypted storage")
            } else {
                print("ℹ️ No user profiles needed encryption migration")
            }
            
        } catch {
            print("❌ Error migrating user profiles to encrypted storage: \(error)")
        }
    }
    
    // MARK: - Name Management
    
    func wFHSixC97l4MCTtHzG1HCsCLxkuaU2Tl(_ newName: String) {
        print("✏️ Updating display name to: \(newName)")
        
        // Update current user if exists
        if let user = d9dQusQ5q74vqBDR4S2x6ngkHlz4Fq84 {
            user.fullName = newName
            user.lastUpdated = Date()
            
            do {
                try LxRQFrCsbBQtFCOyayxupkzFJLlXJonD.save()
                DispatchQueue.main.async {
                    self.YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8 = newName
                }
                print("✅ Display name updated successfully")
            } catch {
                print("❌ Error updating display name: \(error)")
            }
        } else {
            // If no current user, just update the display name locally
            DispatchQueue.main.async {
                self.YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8 = newName
            }
        }
    }
    
    // MARK: - Utility Methods
    
    var XBRN83PxWbEPMDPcnWx7eC9WBTmYZNbu: String {
        if YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8.isEmpty || YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8 == "Atleta" {
            return "Atleta"
        }
        
        // Return first name only for cleaner display
        let components = YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8.components(separatedBy: " ")
        return components.first ?? YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8
    }
    
    var zolFB6D2RRsnAPNjPUICYnSvwRRmyaza: Bool {
        return d9dQusQ5q74vqBDR4S2x6ngkHlz4Fq84 != nil && !YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8.isEmpty && YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8 != "Atleta"
    }
    
    // MARK: - Account Deletion
    
    /// Completely clears the user profile for account deletion
    func clearUserProfile() {
        print("🗑️ Clearing user profile for account deletion...")
        
        // Delete all user profiles from Core Data
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        
        do {
            let allUsers = try LxRQFrCsbBQtFCOyayxupkzFJLlXJonD.fetch(request)
            for user in allUsers {
                LxRQFrCsbBQtFCOyayxupkzFJLlXJonD.delete(user)
            }
            try LxRQFrCsbBQtFCOyayxupkzFJLlXJonD.save()
            
            // Clear published properties
            DispatchQueue.main.async {
                self.d9dQusQ5q74vqBDR4S2x6ngkHlz4Fq84 = nil
                self.YVBUBnfcvywjnXVCwvK5ij1vHynswRQ8 = "Atleta"
            }
            
            print("✅ User profile cleared successfully")
        } catch {
            print("❌ Error clearing user profile: \(error)")
        }
    }
}
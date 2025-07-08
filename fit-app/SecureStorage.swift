import Foundation
import Security

// MARK: - Secure Storage Service using Keychain
class SecureStorage {
    static let shared = SecureStorage()
    
    private let service = "com.antonio.fit-app"
    
    private init() {}
    
    // MARK: - Keychain Operations
    
    /// Securely store a value in Keychain
    func store(_ value: String, for key: String) -> Bool {
        // Delete any existing item first
        delete(key: key)
        
        guard let data = value.data(using: .utf8) else {
            print("🔐 SecureStorage: Failed to convert value to data for key: \(key)")
            return false
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("🔐 SecureStorage: Successfully stored data for key: \(key)")
            return true
        } else {
            print("🔐 SecureStorage: Failed to store data for key: \(key). Status: \(status)")
            return false
        }
    }
    
    /// Securely retrieve a value from Keychain
    func retrieve(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess,
           let data = result as? Data,
           let value = String(data: data, encoding: .utf8) {
            print("🔐 SecureStorage: Successfully retrieved data for key: \(key)")
            return value
        } else {
            if status != errSecItemNotFound {
                print("🔐 SecureStorage: Failed to retrieve data for key: \(key). Status: \(status)")
            }
            return nil
        }
    }
    
    /// Delete a value from Keychain
    func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess || status == errSecItemNotFound {
            print("🔐 SecureStorage: Successfully deleted data for key: \(key)")
            return true
        } else {
            print("🔐 SecureStorage: Failed to delete data for key: \(key). Status: \(status)")
            return false
        }
    }
    
    /// Check if a key exists in Keychain
    func exists(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: false
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Clear all stored credentials (for logout)
    func clearAllCredentials() -> Bool {
        print("🔐 SecureStorage: Clearing all stored credentials")
        
        let success = delete(key: StorageKeys.userEmail) &&
                     delete(key: StorageKeys.hashedPassword) &&
                     delete(key: StorageKeys.userToken)
        
        if success {
            print("🔐 SecureStorage: All credentials cleared successfully")
        } else {
            print("🔐 SecureStorage: Failed to clear some credentials")
        }
        
        return success
    }
}

// MARK: - Storage Keys
extension SecureStorage {
    struct StorageKeys {
        static let userEmail = "user_email"
        static let hashedPassword = "user_password_hash"
        static let userToken = "user_auth_token"
        static let registeredUsers = "registered_users"
    }
}
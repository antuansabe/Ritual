import Foundation
import Security
import CryptoKit

// MARK: - Secure Storage Service using Keychain with AES.GCM Encryption
class SecureStorage {
    static let shared = SecureStorage()
    
    private let service = "com.antonio.fit-app"
    private let encryptionKeyAlias = "encryption_master_key"
    
    private init() {
        // Ensure encryption key exists on first launch
        _ = getOrCreateEncryptionKey()
    }
    
    // MARK: - AES.GCM Encryption/Decryption
    
    /// Encrypt a string value using AES.GCM
    /// - Parameter value: The plain text value to encrypt
    /// - Returns: Base64 encoded encrypted data with nonce, or nil if encryption fails
    func encrypt(value: String) -> String? {
        guard let masterKey = getOrCreateEncryptionKey(),
              let data = value.data(using: .utf8) else {
            print("🔐 SecureStorage: Failed to prepare data for encryption")
            return nil
        }
        
        do {
            let sealedBox = try AES.GCM.seal(data, using: masterKey)
            guard let encryptedData = sealedBox.combined else {
                print("🔐 SecureStorage: Failed to get combined encrypted data")
                return nil
            }
            
            let base64Encrypted = encryptedData.base64EncodedString()
            print("🔐 SecureStorage: Successfully encrypted data (length: \(base64Encrypted.count))")
            return base64Encrypted
            
        } catch {
            print("🔐 SecureStorage: Encryption failed - \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Decrypt a Base64 encoded encrypted string using AES.GCM
    /// - Parameter encryptedValue: Base64 encoded encrypted data
    /// - Returns: Decrypted plain text string, or nil if decryption fails
    func decrypt(value encryptedValue: String) -> String? {
        guard let masterKey = getOrCreateEncryptionKey(),
              let encryptedData = Data(base64Encoded: encryptedValue) else {
            print("🔐 SecureStorage: Failed to prepare encrypted data for decryption")
            return nil
        }
        
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
            let decryptedData = try AES.GCM.open(sealedBox, using: masterKey)
            
            guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
                print("🔐 SecureStorage: Failed to convert decrypted data to string")
                return nil
            }
            
            print("🔐 SecureStorage: Successfully decrypted data")
            return decryptedString
            
        } catch {
            print("🔐 SecureStorage: Decryption failed - \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Get or create a master encryption key stored securely in Keychain
    /// - Returns: SymmetricKey for AES encryption, or nil if key generation/retrieval fails
    private func getOrCreateEncryptionKey() -> SymmetricKey? {
        // Try to retrieve existing key
        if let existingKeyData = retrieveRawKeyData(for: encryptionKeyAlias) {
            print("🔐 SecureStorage: Retrieved existing encryption key")
            return SymmetricKey(data: existingKeyData)
        }
        
        // Generate new 256-bit key for AES.GCM
        let newKey = SymmetricKey(size: .bits256)
        let keyData = newKey.withUnsafeBytes { Data($0) }
        
        // Store the new key securely in Keychain
        if storeRawKeyData(keyData, for: encryptionKeyAlias) {
            print("🔐 SecureStorage: Generated and stored new encryption key")
            return newKey
        } else {
            print("🔐 SecureStorage: Failed to store new encryption key")
            return nil
        }
    }
    
    /// Store raw key data in Keychain with highest security level
    /// - Parameters:
    ///   - keyData: Raw key data to store
    ///   - key: Keychain key identifier
    /// - Returns: True if successful, false otherwise
    private func storeRawKeyData(_ keyData: Data, for key: String) -> Bool {
        // Delete any existing key first
        deleteRawKeyData(for: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: keyData,
            // Highest security: requires device unlock + this device only
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Retrieve raw key data from Keychain
    /// - Parameter key: Keychain key identifier
    /// - Returns: Raw key data if found, nil otherwise
    private func retrieveRawKeyData(for key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let keyData = result as? Data {
            return keyData
        }
        return nil
    }
    
    /// Delete raw key data from Keychain
    /// - Parameter key: Keychain key identifier
    /// - Returns: True if successful or key didn't exist, false otherwise
    private func deleteRawKeyData(for key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
    
    // MARK: - High-Level Encrypted Storage Methods
    
    /// Store a value with AES.GCM encryption in Keychain
    /// This method should be used for all sensitive data storage
    /// - Parameters:
    ///   - value: Plain text value to encrypt and store
    ///   - key: Storage key identifier
    /// - Returns: True if successful, false otherwise
    func storeEncrypted(_ value: String, for key: String) -> Bool {
        guard let encryptedValue = encrypt(value: value) else {
            print("🔐 SecureStorage: Failed to encrypt value for key: \(key)")
            return false
        }
        
        return storeRaw(encryptedValue, for: key)
    }
    
    /// Retrieve and decrypt a value from Keychain
    /// This method should be used for all sensitive data retrieval
    /// - Parameter key: Storage key identifier
    /// - Returns: Decrypted plain text value, or nil if not found or decryption fails
    func retrieveEncrypted(for key: String) -> String? {
        guard let encryptedValue = retrieveRaw(for: key) else {
            return nil
        }
        
        return decrypt(value: encryptedValue)
    }
    
    // MARK: - Raw Keychain Operations (for non-sensitive data)
    
    /// Securely store a value in Keychain without additional encryption
    /// Use storeEncrypted() for sensitive data instead
    /// - Parameters:
    ///   - value: Value to store
    ///   - key: Storage key identifier
    /// - Returns: True if successful, false otherwise
    func storeRaw(_ value: String, for key: String) -> Bool {
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
    
    /// Securely retrieve a value from Keychain without decryption
    /// Use retrieveEncrypted() for sensitive data instead
    /// - Parameter key: Storage key identifier
    /// - Returns: Raw stored value, or nil if not found
    func retrieveRaw(for key: String) -> String? {
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
                     delete(key: StorageKeys.userToken) &&
                     delete(key: StorageKeys.appleUserID) &&
                     delete(key: StorageKeys.appleUserEmail) &&
                     delete(key: StorageKeys.appleUserName)
        
        if success {
            print("🔐 SecureStorage: All credentials cleared successfully")
        } else {
            print("🔐 SecureStorage: Failed to clear some credentials")
        }
        
        return success
    }
    
    // MARK: - Compatibility Methods
    
    /// Legacy method for backward compatibility - automatically encrypts sensitive data
    /// - Parameters:
    ///   - value: Value to store
    ///   - key: Storage key identifier
    /// - Returns: True if successful, false otherwise
    func store(_ value: String, for key: String) -> Bool {
        // Automatically encrypt sensitive data based on key patterns
        if StorageKeys.isSensitiveKey(key) {
            return storeEncrypted(value, for: key)
        } else {
            return storeRaw(value, for: key)
        }
    }
    
    /// Legacy method for backward compatibility - automatically decrypts sensitive data
    /// - Parameter key: Storage key identifier
    /// - Returns: Decrypted value for sensitive keys, raw value for others
    func retrieve(for key: String) -> String? {
        // Automatically decrypt sensitive data based on key patterns
        if StorageKeys.isSensitiveKey(key) {
            return retrieveEncrypted(for: key)
        } else {
            return retrieveRaw(for: key)
        }
    }
}

// MARK: - Storage Keys
extension SecureStorage {
    struct StorageKeys {
        // Authentication - Sensitive (automatically encrypted)
        static let userEmail = "user_email"
        static let hashedPassword = "user_password_hash"
        static let userToken = "user_auth_token"
        static let registeredUsers = "registered_users"
        
        // Apple Sign In - Sensitive (automatically encrypted)
        static let appleUserID = "apple_user_id"
        static let appleUserEmail = "apple_user_email"
        static let appleUserName = "apple_user_name"
        
        // User Profile - Sensitive (automatically encrypted)
        static let userFullName = "user_full_name"
        static let userDisplayName = "user_display_name"
        
        // Workout Data - Sensitive (for UserDefaults backup)
        static let workoutCalories = "workout_calories"
        static let workoutDuration = "workout_duration"
        static let workoutType = "workout_type"
        
        // Session Data - Sensitive
        static let sessionToken = "session_token"
        static let sessionExpiry = "session_expiry"
        
        // Non-sensitive keys (stored without encryption)
        static let hasSeenWelcome = "has_seen_welcome"
        static let isAuthenticated = "is_authenticated"
        static let appPreferences = "app_preferences"
        static let weeklyGoal = "weekly_goal"
        
        /// Check if a key should be encrypted automatically
        /// - Parameter key: The storage key to check
        /// - Returns: True if the key contains sensitive data that should be encrypted
        static func isSensitiveKey(_ key: String) -> Bool {
            let sensitiveKeyPrefixes = [
                "user_email", "user_password", "user_auth", "user_full", "user_display",
                "apple_user", "session_", "workout_", "auth_token", "registered_users"
            ]
            
            return sensitiveKeyPrefixes.contains { key.hasPrefix($0) }
        }
        
        /// Get all sensitive keys for cleanup operations
        /// - Returns: Array of all sensitive storage keys
        static func getAllSensitiveKeys() -> [String] {
            return [
                userEmail, hashedPassword, userToken, registeredUsers,
                appleUserID, appleUserEmail, appleUserName,
                userFullName, userDisplayName,
                workoutCalories, workoutDuration, workoutType,
                sessionToken, sessionExpiry
            ]
        }
    }
}

// MARK: - Migration and Testing Helpers
extension SecureStorage {
    
    /// Test secure storage functionality (for development/debugging)
    func testSecureStorage() -> Bool {
        print("🧪 Testing SecureStorage functionality...")
        
        let testKey = "test_secure_key"
        let testValue = "test_secure_value_12345"
        
        // Test encryption storage
        guard storeEncrypted(testValue, for: testKey) else {
            print("❌ Failed to store encrypted test value")
            return false
        }
        
        // Test encryption retrieval
        guard let retrievedValue = retrieveEncrypted(for: testKey),
              retrievedValue == testValue else {
            print("❌ Failed to retrieve or validate encrypted test value")
            return false
        }
        
        // Test deletion
        guard delete(key: testKey) else {
            print("❌ Failed to delete test value")
            return false
        }
        
        // Verify deletion
        if retrieveEncrypted(for: testKey) != nil {
            print("❌ Test value still exists after deletion")
            return false
        }
        
        print("✅ SecureStorage test passed successfully")
        return true
    }
    
    /// Verify migration status for sensitive keys
    func verifyMigrationStatus() {
        print("🔍 Verifying migration status...")
        
        let legacyKeys = ["userName", "userIdentifier", "userFullName", "AppleUserIdentifier", "AppleUserEmail", "AppleUserName"]
        let secureKeys = [StorageKeys.userDisplayName, StorageKeys.userFullName, StorageKeys.appleUserID, StorageKeys.appleUserEmail, StorageKeys.appleUserName]
        
        for key in legacyKeys {
            if UserDefaults.standard.string(forKey: key) != nil {
                print("⚠️ Legacy data still exists in UserDefaults: \(key)")
            }
        }
        
        for key in secureKeys {
            if exists(key: key) {
                print("✅ Secure data found in Keychain: \(key)")
            }
        }
    }
}

// MARK: - Core Data Encryption Helpers
extension SecureStorage {
    
    /// Encrypt JSON data for Core Data storage
    /// Use this for encrypting sensitive Core Data fields before persistence
    /// - Parameter jsonString: JSON string to encrypt
    /// - Returns: Encrypted JSON string, or nil if encryption fails
    func encryptForCoreData(_ jsonString: String) -> String? {
        return encrypt(value: jsonString)
    }
    
    /// Decrypt JSON data from Core Data storage
    /// Use this for decrypting sensitive Core Data fields after retrieval
    /// - Parameter encryptedJsonString: Encrypted JSON string
    /// - Returns: Decrypted JSON string, or nil if decryption fails
    func decryptFromCoreData(_ encryptedJsonString: String) -> String? {
        return decrypt(value: encryptedJsonString)
    }
    
    /// EXTENSION GUIDE FOR OTHER MODELS:
    /// 
    /// 1. For new sensitive data in Core Data:
    ///    - Store as String type in Core Data model
    ///    - Use encryptForCoreData() before saving
    ///    - Use decryptFromCoreData() after fetching
    ///
    /// 2. For UserDefaults sensitive data:
    ///    - Add key to StorageKeys struct
    ///    - Use storeEncrypted() and retrieveEncrypted()
    ///    - Or rely on automatic encryption via store()/retrieve()
    ///
    /// 3. Example implementation:
    ///    ```swift
    ///    // Saving to Core Data
    ///    let sensitiveData = "user's private info"
    ///    entity.encryptedField = SecureStorage.shared.encryptForCoreData(sensitiveData)
    ///    
    ///    // Loading from Core Data
    ///    if let encryptedField = entity.encryptedField,
    ///       let decryptedData = SecureStorage.shared.decryptFromCoreData(encryptedField) {
    ///        // Use decryptedData
    ///    }
    ///    ```
}
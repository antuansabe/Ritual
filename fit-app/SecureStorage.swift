import Foundation
import Security
import CryptoKit
import os.log

// MARK: - KeychainAccess-like API Implementation
/// A simplified KeychainAccess-like implementation for better ergonomics
class c6g46bzrfBBW1mHmJeHLIRT9Bt9YB7y5 {
    private let rOkXSKjo3gh0Aumx2oHhWQjHD9oewvfx: String
    private let cOPI2KDIBBVwLbfPzP2HYdj5nfQfame2: String?
    
    init(service: String, accessGroup: String? = nil) {
        self.rOkXSKjo3gh0Aumx2oHhWQjHD9oewvfx = service
        self.cOPI2KDIBBVwLbfPzP2HYdj5nfQfame2 = accessGroup
    }
    
    /// Set a value for a key with AES-GCM encryption
    func r0AqoYxLhfNYCN9Nib0HLfzhDAmXp8ry(_ value: String, for key: String) throws {
        guard !value.isEmpty else {
            throw ozq9F5EacJWWaKwdh5GWD0LiZUxAn3zm.G3tmvRrMmZtHf386y0DZzrdBl7nxfnce
        }
        
        let success = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(value, for: key)
        if !success {
            throw ozq9F5EacJWWaKwdh5GWD0LiZUxAn3zm.wQmQPp19GT2KApfuQKvtGBClrvltliht(status: errSecAllocate)
        }
    }
    
    /// Get a value for a key with AES-GCM decryption
    func eXGEhDZR5F3a9M8RnmLQbPuTTK0QyTsR(_ key: String) throws -> String? {
        return HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: key)
    }
    
    /// Delete a value for a key
    func NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(_ key: String) throws {
        let success = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: key)
        if !success {
            throw ozq9F5EacJWWaKwdh5GWD0LiZUxAn3zm.wQmQPp19GT2KApfuQKvtGBClrvltliht(status: errSecItemNotFound)
        }
    }
    
    /// Set accessibility level for keychain items
    func EudvKycJjYnRLaBuyVFCeNrfoHmb9i4K(_ accessibility: tVQk028Np7aLSfp0p6vMHfHJKNqU7ElT) -> c6g46bzrfBBW1mHmJeHLIRT9Bt9YB7y5 {
        // This implementation already uses kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        // Return self for chaining
        return self
    }
}

// MARK: - Keychain Errors
enum ozq9F5EacJWWaKwdh5GWD0LiZUxAn3zm: Error, CustomStringConvertible {
    case G3tmvRrMmZtHf386y0DZzrdBl7nxfnce
    case g8IWyJORM1FffC5lZjfZs24SMrYfHgsS
    case BKQ8y3kNEAvG3eHpZgcwksXJnWOnTFFq
    case wQmQPp19GT2KApfuQKvtGBClrvltliht(status: OSStatus)
    
    var description: String {
        switch self {
        case .G3tmvRrMmZtHf386y0DZzrdBl7nxfnce:
            return "Invalid data provided"
        case .g8IWyJORM1FffC5lZjfZs24SMrYfHgsS:
            return "Item not found in keychain"
        case .BKQ8y3kNEAvG3eHpZgcwksXJnWOnTFFq:
            return "Duplicate item in keychain"
        case .wQmQPp19GT2KApfuQKvtGBClrvltliht(let status):
            return "Unhandled keychain error: \(status)"
        }
    }
}

// MARK: - Accessibility Options
enum tVQk028Np7aLSfp0p6vMHfHJKNqU7ElT {
    case x5maP3D69DDztUcSglXR02pLHfQgrsEP
    case ttyc7ziAULPCl7aXMp7wSfWfGjHNSkJ1
    case q8LTYj6uO2vb4HQL4mTuIcbRJsFydhCb
    case SNmui29YN5nWTf3GtNFHa1Tr7OMlyTSB
    
    var d1JtTjuSjzU0mA3YFvpCkaRIQOJt1sPX: CFString {
        switch self {
        case .x5maP3D69DDztUcSglXR02pLHfQgrsEP:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        case .ttyc7ziAULPCl7aXMp7wSfWfGjHNSkJ1:
            return kSecAttrAccessibleWhenUnlocked
        case .q8LTYj6uO2vb4HQL4mTuIcbRJsFydhCb:
            return kSecAttrAccessibleAfterFirstUnlock
        case .SNmui29YN5nWTf3GtNFHa1Tr7OMlyTSB:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        }
    }
}

// MARK: - Secure Storage Service using Keychain with AES.GCM Encryption
class HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow {
    static let DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow()
    
    private let rOkXSKjo3gh0Aumx2oHhWQjHD9oewvfx = "com.antonio.fit-app"
    private let lNNtgqzJ13KEdFEURzIkTrkmVTZLGPYy = "encryption_master_key"
    
    // MARK: - KeychainAccess-like API
    /// KeychainAccess-like instance for improved ergonomics
    lazy var B5jww6HEiUpSxpxg9S5LoTuIaIlr4kNO = c6g46bzrfBBW1mHmJeHLIRT9Bt9YB7y5(service: rOkXSKjo3gh0Aumx2oHhWQjHD9oewvfx).EudvKycJjYnRLaBuyVFCeNrfoHmb9i4K(.x5maP3D69DDztUcSglXR02pLHfQgrsEP)
    
    private init() {
        // Ensure encryption key exists on first launch
        _ = nWfCc2JPsckzdnZjgDnizpvFUp1BwFjx()
    }
    
    // MARK: - New Simplified API (KeychainAccess-like)
    
    /// Store a value with automatic AES-GCM encryption
    /// - Parameters:
    ///   - value: String value to encrypt and store
    ///   - key: Storage key identifier
    /// - Throws: KeychainError if storage fails
    func r0AqoYxLhfNYCN9Nib0HLfzhDAmXp8ry(_ value: String, for key: String) throws {
        try B5jww6HEiUpSxpxg9S5LoTuIaIlr4kNO.r0AqoYxLhfNYCN9Nib0HLfzhDAmXp8ry(value, for: key)
    }
    
    /// Retrieve and decrypt a value
    /// - Parameter key: Storage key identifier
    /// - Returns: Decrypted string value, or nil if not found
    /// - Throws: KeychainError if retrieval fails
    func eXGEhDZR5F3a9M8RnmLQbPuTTK0QyTsR(_ key: String) throws -> String? {
        return try B5jww6HEiUpSxpxg9S5LoTuIaIlr4kNO.eXGEhDZR5F3a9M8RnmLQbPuTTK0QyTsR(key)
    }
    
    /// Delete a value from secure storage
    /// - Parameter key: Storage key identifier
    /// - Throws: KeychainError if deletion fails
    func NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(_ key: String) throws {
        try B5jww6HEiUpSxpxg9S5LoTuIaIlr4kNO.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key)
    }
    
    // MARK: - AES.GCM Encryption/Decryption
    
    /// Encrypt a string value using AES.GCM
    /// - Parameter value: The plain text value to encrypt
    /// - Returns: Base64 encoded encrypted data with nonce, or nil if encryption fails
    func GYcaHjFewiT2OY5w1kUcxdgQFRsFYxgp(value: String) -> String? {
        guard let masterKey = nWfCc2JPsckzdnZjgDnizpvFUp1BwFjx(),
              let data = value.data(using: .utf8) else {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Failed to prepare data for encryption")
            #endif
            #endif
            return nil
        }
        
        do {
            let sealedBox = try AES.GCM.seal(data, using: masterKey)
            guard let encryptedData = sealedBox.combined else {
                #if DEBUG
                #if DEBUG
                Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Failed to get combined encrypted data")
                #endif
                #endif
                return nil
            }
            
            let base64Encrypted = encryptedData.base64EncodedString()
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Successfully encrypted data (length: \(base64Encrypted.count))")
            #endif
            #endif
            return base64Encrypted
            
        } catch {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Encryption failed - \(error.localizedDescription)")
            #endif
            #endif
            return nil
        }
    }
    
    /// Decrypt a Base64 encoded encrypted string using AES.GCM
    /// - Parameter encryptedValue: Base64 encoded encrypted data
    /// - Returns: Decrypted plain text string, or nil if decryption fails
    func S3EssNUBAI8hl4Mnae1AGtxUIXkLDdrN(value encryptedValue: String) -> String? {
        guard let masterKey = nWfCc2JPsckzdnZjgDnizpvFUp1BwFjx(),
              let encryptedData = Data(base64Encoded: encryptedValue) else {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Failed to prepare encrypted data for decryption")
            #endif
            #endif
            return nil
        }
        
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
            let decryptedData = try AES.GCM.open(sealedBox, using: masterKey)
            
            guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
                #if DEBUG
                #if DEBUG
                Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Failed to convert decrypted data to string")
                #endif
                #endif
                return nil
            }
            
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Successfully decrypted data")
            #endif
            #endif
            return decryptedString
            
        } catch {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Decryption failed - \(error.localizedDescription)")
            #endif
            #endif
            return nil
        }
    }
    
    /// Get or create a master encryption key stored securely in Keychain
    /// - Returns: SymmetricKey for AES encryption, or nil if key generation/retrieval fails
    private func nWfCc2JPsckzdnZjgDnizpvFUp1BwFjx() -> SymmetricKey? {
        // Try to retrieve existing key
        if let existingKeyData = Gw8Vt7im7gEmbOKRHqXmNh1UH2Qo2HYq(for: lNNtgqzJ13KEdFEURzIkTrkmVTZLGPYy) {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Retrieved existing encryption key")
            #endif
            #endif
            return SymmetricKey(data: existingKeyData)
        }
        
        // Generate new 256-bit key for AES.GCM
        let newKey = SymmetricKey(size: .bits256)
        let keyData = newKey.withUnsafeBytes { Data($0) }
        
        // Store the new key securely in Keychain
        if Z5hw73WlQzeRQt1obKOWBz9ghA4wenS3(keyData, for: lNNtgqzJ13KEdFEURzIkTrkmVTZLGPYy) {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Generated and stored new encryption key")
            #endif
            #endif
            return newKey
        } else {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Failed to store new encryption key")
            #endif
            #endif
            return nil
        }
    }
    
    /// Store raw key data in Keychain with highest security level
    /// - Parameters:
    ///   - keyData: Raw key data to store
    ///   - key: Keychain key identifier
    /// - Returns: True if successful, false otherwise
    private func Z5hw73WlQzeRQt1obKOWBz9ghA4wenS3(_ keyData: Data, for key: String) -> Bool {
        // Delete any existing key first
        px9X6eTxIKwtDzyDvpVH9pTYh9pWFLYy(for: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: rOkXSKjo3gh0Aumx2oHhWQjHD9oewvfx,
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
    private func Gw8Vt7im7gEmbOKRHqXmNh1UH2Qo2HYq(for key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: rOkXSKjo3gh0Aumx2oHhWQjHD9oewvfx,
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
    private func px9X6eTxIKwtDzyDvpVH9pTYh9pWFLYy(for key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: rOkXSKjo3gh0Aumx2oHhWQjHD9oewvfx,
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
    func GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(_ value: String, for key: String) -> Bool {
        guard let encryptedValue = GYcaHjFewiT2OY5w1kUcxdgQFRsFYxgp(value: value) else {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Failed to encrypt value for key: \(key)")
            #endif
            #endif
            return false
        }
        
        return TxBVFgZQXcAiGSpe5Bj4cWX37pRpzhmy(encryptedValue, for: key)
    }
    
    /// Retrieve and decrypt a value from Keychain
    /// This method should be used for all sensitive data retrieval
    /// - Parameter key: Storage key identifier
    /// - Returns: Decrypted plain text value, or nil if not found or decryption fails
    func UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for key: String) -> String? {
        guard let encryptedValue = kDKvq00aGCveS0U5tzMkjQOKoyS8ZeRg(for: key) else {
            return nil
        }
        
        return S3EssNUBAI8hl4Mnae1AGtxUIXkLDdrN(value: encryptedValue)
    }
    
    // MARK: - Raw Keychain Operations (for non-sensitive data)
    
    /// Securely store a value in Keychain without additional encryption
    /// Use storeEncrypted() for sensitive data instead
    /// - Parameters:
    ///   - value: Value to store
    ///   - key: Storage key identifier
    /// - Returns: True if successful, false otherwise
    func TxBVFgZQXcAiGSpe5Bj4cWX37pRpzhmy(_ value: String, for key: String) -> Bool {
        // Delete any existing item first
        NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: key)
        
        guard let data = value.data(using: .utf8) else {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Failed to convert value to data for key: \(key)")
            #endif
            #endif
            return false
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: rOkXSKjo3gh0Aumx2oHhWQjHD9oewvfx,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Successfully stored data for key: \(key)")
            #endif
            #endif
            return true
        } else {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Failed to store data for key: \(key). Status: \(status)")
            #endif
            #endif
            return false
        }
    }
    
    /// Securely retrieve a value from Keychain without decryption
    /// Use retrieveEncrypted() for sensitive data instead
    /// - Parameter key: Storage key identifier
    /// - Returns: Raw stored value, or nil if not found
    func kDKvq00aGCveS0U5tzMkjQOKoyS8ZeRg(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: rOkXSKjo3gh0Aumx2oHhWQjHD9oewvfx,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess,
           let data = result as? Data,
           let value = String(data: data, encoding: .utf8) {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Successfully retrieved data for key: \(key)")
            #endif
            #endif
            return value
        } else {
            if status != errSecItemNotFound {
                #if DEBUG
                #if DEBUG
                Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Failed to retrieve data for key: \(key). Status: \(status)")
                #endif
                #endif
            }
            return nil
        }
    }
    
    /// Delete a value from Keychain
    func NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: rOkXSKjo3gh0Aumx2oHhWQjHD9oewvfx,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess || status == errSecItemNotFound {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Successfully deleted data for key: \(key)")
            #endif
            #endif
            return true
        } else {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Failed to delete data for key: \(key). Status: \(status)")
            #endif
            #endif
            return false
        }
    }
    
    /// Check if a key exists in Keychain
    func Rfa9dPTHxbyr5OOvdWL7QgTlwPmUm5qc(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: rOkXSKjo3gh0Aumx2oHhWQjHD9oewvfx,
            kSecAttrAccount as String: key,
            kSecReturnData as String: false
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Clear all stored credentials (for logout)
    func ahdJT6VjC55m9Zgn6rFCtDW2XNR2vbFP() -> Bool {
        #if DEBUG
        #if DEBUG
        Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Clearing all stored credentials")
        #endif
        #endif
        
        let success = NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.an8EQdG4sbWLiCnAmX9GlribmSjMTM7A) &&
                     NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.IRID9yUZ0XPhucZUA3oPDrTCVgrJMi3J) &&
                     NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.QPcT4AroqypAx0yzycrRs5zbG3JqOqXm) &&
                     NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.NUWvelGURmEPxQVMA0XDK9YtVRsHFwPH) &&
                     NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.OTpc1Uok1024oD57HxGmCgPZPXMSpvUT) &&
                     NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.nJPxwctQXEypC5Lb9QpHK6jFZFwXzoAh)
        
        if success {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: All credentials cleared successfully")
            #endif
            #endif
        } else {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔐 SecureStorage: Failed to clear some credentials")
            #endif
            #endif
        }
        
        return success
    }
    
    // MARK: - Compatibility Methods
    
    /// Legacy method for backward compatibility - automatically encrypts sensitive data
    /// - Parameters:
    ///   - value: Value to store
    ///   - key: Storage key identifier
    /// - Returns: True if successful, false otherwise
    func L3aNv2EXMf2StoJwD9r2Ata22nuTocvV(_ value: String, for key: String) -> Bool {
        // Automatically encrypt sensitive data based on key patterns
        if JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.MTcvjyCDZ1xOLDp8wf93LYHGVqR5kylY(key) {
            return GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(value, for: key)
        } else {
            return TxBVFgZQXcAiGSpe5Bj4cWX37pRpzhmy(value, for: key)
        }
    }
    
    /// Legacy method for backward compatibility - automatically decrypts sensitive data
    /// - Parameter key: Storage key identifier
    /// - Returns: Decrypted value for sensitive keys, raw value for others
    func F6caM4VleW2aDmwL8SXPiOf7lsgAGpxv(for key: String) -> String? {
        // Automatically decrypt sensitive data based on key patterns
        if JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.MTcvjyCDZ1xOLDp8wf93LYHGVqR5kylY(key) {
            return UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: key)
        } else {
            return kDKvq00aGCveS0U5tzMkjQOKoyS8ZeRg(for: key)
        }
    }
}

// MARK: - Storage Keys
extension HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow {
    struct JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB {
        // Authentication - Sensitive (automatically encrypted)
        static let an8EQdG4sbWLiCnAmX9GlribmSjMTM7A = "user_email"
        static let IRID9yUZ0XPhucZUA3oPDrTCVgrJMi3J = "user_password_hash"
        static let QPcT4AroqypAx0yzycrRs5zbG3JqOqXm = "user_auth_token"
        static let lBiBlJK3X2zmpLvtcgw3xT0bOjwUZBq1 = "registered_users"
        
        // Apple Sign In - Sensitive (automatically encrypted)
        static let NUWvelGURmEPxQVMA0XDK9YtVRsHFwPH = "apple_user_id"
        static let OTpc1Uok1024oD57HxGmCgPZPXMSpvUT = "apple_user_email"
        static let nJPxwctQXEypC5Lb9QpHK6jFZFwXzoAh = "apple_user_name"
        
        // User Profile - Sensitive (automatically encrypted)
        static let gZQjJBUcdNVueyu0ArJZi8U47vNe5Kqi = "user_full_name"
        static let YhyL54l7qYGd78Z7egtPFzCWzLff1uDd = "user_display_name"
        
        // Workout Data - Sensitive (for UserDefaults backup)
        static let ksg0gX6JpSwyKmNwUULZ771FjtwVW1i9 = "workout_calories"
        static let d9opZFSKUIuIIwTHr2H5YqQ4sykZ2f3Y = "workout_duration"
        static let UEDsHZzUh0u1JhoiIKWCSC9DdmgtusbE = "workout_type"
        
        // Session Data - Sensitive
        static let YnlVbpGHp2yzRwF7GJdxc8CUlHtrfiI1 = "session_token"
        static let kqXmLsPvI88zvm1S1hAerEQeXHTrSAPP = "session_expiry"
        
        // Non-sensitive keys (stored without encryption)
        static let Eipluq8LD9geJrV1Io29kimcg2nhUc0k = "has_seen_welcome"
        static let exTCxBz8yvnNYRQqFWC1W0Yh5tEaeJAH = "is_authenticated"
        static let ItpoXbcZkjSuDpx9dICTA5L9xGlKZvo4 = "app_preferences"
        static let z4O9osa4t51DJPhWJjpsb5QhRrWPn666 = "weekly_goal"
        
        /// Check if a key should be encrypted automatically
        /// - Parameter key: The storage key to check
        /// - Returns: True if the key contains sensitive data that should be encrypted
        static func MTcvjyCDZ1xOLDp8wf93LYHGVqR5kylY(_ key: String) -> Bool {
            let sensitiveKeyPrefixes = [
                "user_email", "user_password", "user_auth", "user_full", "user_display",
                "apple_user", "session_", "workout_", "auth_token", "registered_users"
            ]
            
            return sensitiveKeyPrefixes.contains { key.hasPrefix($0) }
        }
        
        /// Get all sensitive keys for cleanup operations
        /// - Returns: Array of all sensitive storage keys
        static func oNjaXUpQu7YAMHsCno5Hl9001gBMTD1h() -> [String] {
            return [
                an8EQdG4sbWLiCnAmX9GlribmSjMTM7A, IRID9yUZ0XPhucZUA3oPDrTCVgrJMi3J, QPcT4AroqypAx0yzycrRs5zbG3JqOqXm, lBiBlJK3X2zmpLvtcgw3xT0bOjwUZBq1,
                NUWvelGURmEPxQVMA0XDK9YtVRsHFwPH, OTpc1Uok1024oD57HxGmCgPZPXMSpvUT, nJPxwctQXEypC5Lb9QpHK6jFZFwXzoAh,
                gZQjJBUcdNVueyu0ArJZi8U47vNe5Kqi, YhyL54l7qYGd78Z7egtPFzCWzLff1uDd,
                ksg0gX6JpSwyKmNwUULZ771FjtwVW1i9, d9opZFSKUIuIIwTHr2H5YqQ4sykZ2f3Y, UEDsHZzUh0u1JhoiIKWCSC9DdmgtusbE,
                YnlVbpGHp2yzRwF7GJdxc8CUlHtrfiI1, kqXmLsPvI88zvm1S1hAerEQeXHTrSAPP
            ]
        }
    }
}

// MARK: - Migration and Testing Helpers
extension HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow {
    
    /// Test secure storage functionality (for development/debugging)
    func OvUBVQaLf4h3wpAtwsbuysyReR8ohfyV() -> Bool {
        #if DEBUG
        #if DEBUG
        Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🧪 Testing SecureStorage functionality...")
        #endif
        #endif
        
        let testKey = "test_secure_key"
        let testValue = "test_secure_value_12345"
        
        // Test encryption storage
        guard GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(testValue, for: testKey) else {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("[ERR] Failed to store encrypted test value")
            #endif
            #endif
            return false
        }
        
        // Test encryption retrieval
        guard let retrievedValue = UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: testKey),
              retrievedValue == testValue else {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("[ERR] Failed to retrieve or validate encrypted test value")
            #endif
            #endif
            return false
        }
        
        // Test deletion
        guard NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: testKey) else {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("[ERR] Failed to delete test value")
            #endif
            #endif
            return false
        }
        
        // Verify deletion
        if UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: testKey) != nil {
            #if DEBUG
            #if DEBUG
            Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("[ERR] Test value still exists after deletion")
            #endif
            #endif
            return false
        }
        
        #if DEBUG
        #if DEBUG
        Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("[OK] SecureStorage test passed successfully")
        #endif
        #endif
        return true
    }
    
    /// Verify migration status for sensitive keys
    func MrsQoTWHY45Peb8czR6H2yrUb89wDjub() {
        #if DEBUG
        #if DEBUG
        Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("🔍 Verifying migration status...")
        #endif
        #endif
        
        let legacyKeys = ["userName", "userIdentifier", "userFullName", "AppleUserIdentifier", "AppleUserEmail", "AppleUserName"]
        let secureKeys = [JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd, JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.gZQjJBUcdNVueyu0ArJZi8U47vNe5Kqi, JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.NUWvelGURmEPxQVMA0XDK9YtVRsHFwPH, JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.OTpc1Uok1024oD57HxGmCgPZPXMSpvUT, JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.nJPxwctQXEypC5Lb9QpHK6jFZFwXzoAh]
        
        for key in legacyKeys {
            if UserDefaults.standard.string(forKey: key) != nil {
                #if DEBUG
                #if DEBUG
                Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("[WARN]️ Legacy data still exists in UserDefaults: \(key)")
                #endif
                #endif
            }
        }
        
        for key in secureKeys {
            if Rfa9dPTHxbyr5OOvdWL7QgTlwPmUm5qc(key: key) {
                #if DEBUG
                #if DEBUG
                Logger.ZjlZ7mjaEwb57I6IL6l0j9QboITfuhsr.debug("[OK] Secure data found in Keychain: \(key)")
                #endif
                #endif
            }
        }
    }
}

// MARK: - Core Data Encryption Helpers
extension HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow {
    
    /// Encrypt JSON data for Core Data storage
    /// Use this for encrypting sensitive Core Data fields before persistence
    /// - Parameter jsonString: JSON string to encrypt
    /// - Returns: Encrypted JSON string, or nil if encryption fails
    func Eqc2ql0IVtWbFTAKElgtPqpbsawqmIKR(_ jsonString: String) -> String? {
        return GYcaHjFewiT2OY5w1kUcxdgQFRsFYxgp(value: jsonString)
    }
    
    /// Decrypt JSON data from Core Data storage
    /// Use this for decrypting sensitive Core Data fields after retrieval
    /// - Parameter encryptedJsonString: Encrypted JSON string
    /// - Returns: Decrypted JSON string, or nil if decryption fails
    func eaHJWTTic72DUmLgYtENJocDbVc9Jkvy(_ encryptedJsonString: String) -> String? {
        return S3EssNUBAI8hl4Mnae1AGtxUIXkLDdrN(value: encryptedJsonString)
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
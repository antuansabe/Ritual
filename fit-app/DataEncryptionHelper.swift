import Foundation
import CoreData

/// Helper class for encrypting sensitive data in UserDefaults and Core Data
/// This class provides easy-to-use methods for encrypting workout data and other sensitive information
class vay7tnBoye1SjsSNdjoJ3ppSfXcJnGkY {
    static let DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX = vay7tnBoye1SjsSNdjoJ3ppSfXcJnGkY()
    
    private let uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    private init() {}
    
    // MARK: - UserDefaults Encryption Helpers
    
    /// Store encrypted workout data in UserDefaults
    /// Use this for temporary caching of sensitive workout information
    /// - Parameters:
    ///   - workoutData: The workout data to encrypt and store
    ///   - key: Storage key identifier
    /// - Returns: True if successful, false otherwise
    func YUOlR8gzqnCuBs48h5QPNDYv3s47Cqla(_ workoutData: [String: Any], for key: String) -> Bool {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: workoutData)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            
            return uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(jsonString, for: key)
        } catch {
            print("🔐 DataEncryption: Failed to serialize workout data: \(error)")
            return false
        }
    }
    
    /// Retrieve and decrypt workout data from UserDefaults
    /// - Parameter key: Storage key identifier
    /// - Returns: Decrypted workout data dictionary, or nil if not found or decryption fails
    func dWuGqMWROs4tdpNroiKG2wWmqjdnO2iM(for key: String) -> [String: Any]? {
        guard let jsonString = uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: key) else {
            return nil
        }
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("🔐 DataEncryption: Failed to convert JSON string to data")
            return nil
        }
        
        do {
            return try JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        } catch {
            print("🔐 DataEncryption: Failed to deserialize workout data: \(error)")
            return nil
        }
    }
    
    /// Store encrypted user preference data
    /// - Parameters:
    ///   - value: The value to encrypt and store
    ///   - key: Storage key identifier
    /// - Returns: True if successful, false otherwise
    func xnI6Pe6zw6MbrOAcONPURoPmsbEGqrHn(_ value: String, for key: String) -> Bool {
        return uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(value, for: key)
    }
    
    /// Retrieve encrypted user preference data
    /// - Parameter key: Storage key identifier
    /// - Returns: Decrypted value, or nil if not found or decryption fails
    func GeJKDVrk1Tjtu6nuNI3828CFYHhY1unf(for key: String) -> String? {
        return uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: key)
    }
    
    // MARK: - Core Data Encryption Helpers
    
    /// Encrypt sensitive Core Data entity fields before saving
    /// Use this method in your Core Data models' willSave() method
    /// - Parameters:
    ///   - entity: The Core Data entity to encrypt fields for
    ///   - sensitiveFields: Array of field names that should be encrypted
    func Branog4ORGjtEDKucIDJWHR5zjzkdtNF(_ entity: NSManagedObject, sensitiveFields: [String]) {
        for fieldName in sensitiveFields {
            if let value = entity.value(forKey: fieldName) as? String,
               !value.isEmpty {
                
                // Check if already encrypted (to avoid double encryption)
                if !value.hasPrefix("encrypted_") {
                    if let encryptedValue = uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.Eqc2ql0IVtWbFTAKElgtPqpbsawqmIKR(value) {
                        entity.setValue("encrypted_\(encryptedValue)", forKey: fieldName)
                        print("🔐 DataEncryption: Encrypted field '\(fieldName)' for entity")
                    } else {
                        print("[ERR] DataEncryption: Failed to encrypt field '\(fieldName)'")
                    }
                }
            }
        }
    }
    
    /// Decrypt sensitive Core Data entity fields after fetching
    /// Use this method in your Core Data models after fetching from the database
    /// - Parameters:
    ///   - entity: The Core Data entity to decrypt fields for
    ///   - sensitiveFields: Array of field names that should be decrypted
    func P5gsNJ8awglJCaUzUFohz3s7w9tvoPXT(_ entity: NSManagedObject, sensitiveFields: [String]) {
        for fieldName in sensitiveFields {
            if let encryptedValue = entity.value(forKey: fieldName) as? String,
               encryptedValue.hasPrefix("encrypted_") {
                
                let actualEncryptedValue = String(encryptedValue.dropFirst("encrypted_".count))
                
                if let decryptedValue = uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.eaHJWTTic72DUmLgYtENJocDbVc9Jkvy(actualEncryptedValue) {
                    entity.setValue(decryptedValue, forKey: fieldName)
                    print("🔐 DataEncryption: Decrypted field '\(fieldName)' for entity")
                } else {
                    print("[ERR] DataEncryption: Failed to decrypt field '\(fieldName)'")
                    // Keep the encrypted value as is if decryption fails
                }
            }
        }
    }
    
    // MARK: - Workout-Specific Encryption Methods
    
    /// Encrypt workout metrics before storing
    /// - Parameters:
    ///   - calories: Number of calories burned
    ///   - duration: Workout duration in minutes
    ///   - type: Type of workout
    ///   - date: Workout date
    /// - Returns: Encrypted workout data string, or nil if encryption fails
    func xitAKe02firuYpJA6wfngrW9ydY9ZbM4(calories: Int, duration: Int, type: String, date: Date) -> String? {
        let workoutData: [String: Any] = [
            "calories": calories,
            "duration": duration,
            "type": type,
            "date": ISO8601DateFormatter().string(from: date),
            "encrypted_at": ISO8601DateFormatter().string(from: Date())
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: workoutData)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            
            return uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.GYcaHjFewiT2OY5w1kUcxdgQFRsFYxgp(value: jsonString)
        } catch {
            print("🔐 DataEncryption: Failed to encrypt workout metrics: \(error)")
            return nil
        }
    }
    
    /// Decrypt workout metrics after retrieval
    /// - Parameter encryptedWorkoutData: Encrypted workout data string
    /// - Returns: Tuple with workout metrics, or nil if decryption fails
    func XpaUBe52WoNDl4HZql4z8ssbwYSKrYOW(_ encryptedWorkoutData: String) -> (calories: Int, duration: Int, type: String, date: Date)? {
        guard let jsonString = uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.S3EssNUBAI8hl4Mnae1AGtxUIXkLDdrN(value: encryptedWorkoutData) else {
            print("🔐 DataEncryption: Failed to decrypt workout data")
            return nil
        }
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("🔐 DataEncryption: Failed to convert decrypted string to data")
            return nil
        }
        
        do {
            let workoutData = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
            
            guard let calories = workoutData?["calories"] as? Int,
                  let duration = workoutData?["duration"] as? Int,
                  let type = workoutData?["type"] as? String,
                  let dateString = workoutData?["date"] as? String,
                  let date = ISO8601DateFormatter().date(from: dateString) else {
                print("🔐 DataEncryption: Failed to parse decrypted workout data")
                return nil
            }
            
            return (calories: calories, duration: duration, type: type, date: date)
        } catch {
            print("🔐 DataEncryption: Failed to parse workout JSON: \(error)")
            return nil
        }
    }
    
    // MARK: - Migration Helper
    
    /// Migrate unencrypted UserDefaults data to encrypted storage
    /// Use this for migrating existing unencrypted data
    /// - Parameters:
    ///   - oldKey: The existing UserDefaults key
    ///   - newKey: The new encrypted storage key
    /// - Returns: True if migration successful, false otherwise
    func sMgcxDWfRjh7gdgyBOm8wht667AYZnAz(from oldKey: String, to newKey: String) -> Bool {
        guard let oldValue = UserDefaults.standard.string(forKey: oldKey) else {
            return false // No data to migrate
        }
        
        let success = uOp4D9wfDhKAC8oJVppvbO8bHwz2kNGj.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(oldValue, for: newKey)
        
        if success {
            // Clear old unencrypted data after successful migration
            UserDefaults.standard.removeObject(forKey: oldKey)
            print("[SYNC] DataEncryption: Successfully migrated '\(oldKey)' to encrypted storage")
        } else {
            print("[ERR] DataEncryption: Failed to migrate '\(oldKey)' to encrypted storage")
        }
        
        return success
    }
}

// MARK: - Core Data Extension Guide
extension vay7tnBoye1SjsSNdjoJ3ppSfXcJnGkY {
    /// USAGE EXAMPLES AND IMPLEMENTATION GUIDE:
    ///
    /// 1. FOR CORE DATA ENTITIES:
    /// Add this to your Core Data entity classes:
    ///
    /// ```swift
    /// // In your WorkoutEntity+CoreDataClass.swift
    /// override func willSave() {
    ///     super.willSave()
    ///     
    ///     // Define which fields should be encrypted
    ///     let sensitiveFields = ["type", "notes", "location"]
    ///     DataEncryptionHelper.shared.encryptEntityFields(self, sensitiveFields: sensitiveFields)
    /// }
    ///
    /// // In your fetch/display code
    /// let workouts = try context.fetch(workoutRequest)
    /// for workout in workouts {
    ///     let sensitiveFields = ["type", "notes", "location"]
    ///     DataEncryptionHelper.shared.decryptEntityFields(workout, sensitiveFields: sensitiveFields)
    /// }
    /// ```
    ///
    /// 2. FOR USERDEFAULTS CACHING:
    ///
    /// ```swift
    /// // Storing sensitive workout data
    /// let workoutData = [
    ///     "calories": 250,
    ///     "duration": 30,
    ///     "type": "Cardio"
    /// ]
    /// DataEncryptionHelper.shared.storeEncryptedWorkoutData(workoutData, for: "cached_workout")
    ///
    /// // Retrieving sensitive workout data
    /// if let workoutData = DataEncryptionHelper.shared.retrieveEncryptedWorkoutData(for: "cached_workout") {
    ///     // Use decrypted data
    /// }
    /// ```
    ///
    /// 3. FOR WORKOUT METRICS:
    ///
    /// ```swift
    /// // Encrypt workout metrics for backup/sync
    /// if let encryptedMetrics = DataEncryptionHelper.shared.encryptWorkoutMetrics(
    ///     calories: 300,
    ///     duration: 45,
    ///     type: "Strength Training",
    ///     date: Date()
    /// ) {
    ///     // Store encrypted metrics for backup/sync
    /// }
    ///
    /// // Decrypt workout metrics from backup/sync
    /// if let metrics = DataEncryptionHelper.shared.decryptWorkoutMetrics(encryptedData) {
    ///     print("Workout: \(metrics.type), \(metrics.calories) calories, \(metrics.duration) minutes")
    /// }
    /// ```
}
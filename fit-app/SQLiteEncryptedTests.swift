import XCTest
import CoreData
@testable import fit_app

class SQLiteEncryptedTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    
    override func setUp() {
        super.setUp()
        // Create a test persistence controller
        persistenceController = PersistenceController(inMemory: false)
    }
    
    override func tearDown() {
        persistenceController = nil
        super.tearDown()
    }
    
    func testSQLiteFileIsEncrypted() throws {
        // GIVEN: A Core Data stack with FileProtectionType.complete
        let context = persistenceController.container.viewContext
        
        // WHEN: Creating and saving a workout
        let workout = WorkoutEntity(context: context)
        workout.id = UUID()
        workout.name = "Test Workout Encryption"
        workout.type = "strength"
        workout.duration = 1800
        workout.caloriesBurned = 250
        workout.date = Date()
        workout.isCompleted = true
        workout.notes = "Testing encryption"
        
        try context.save()
        
        // Force write to disk
        context.refreshAllObjects()
        try context.save()
        
        // THEN: Get the SQLite file path
        guard let storeURL = persistenceController.container.persistentStoreDescriptions.first?.url else {
            XCTFail("Could not get store URL")
            return
        }
        
        // Wait a moment for file system operations
        Thread.sleep(forTimeInterval: 0.5)
        
        // Read the first 16 bytes of the SQLite file
        let fileData = try Data(contentsOf: storeURL)
        let headerData = fileData.prefix(16)
        
        // Convert to string to check for SQLite header
        let headerString = String(data: headerData, encoding: .utf8) ?? ""
        
        // VERIFY: The file should NOT contain the plain SQLite header
        XCTAssertFalse(headerString.contains("SQLite format 3"),
                      "SQLite file header should be encrypted and not contain 'SQLite format 3'")
        
        // Additional check: the file should exist and have content
        XCTAssertTrue(FileManager.default.fileExists(atPath: storeURL.path),
                     "SQLite file should exist")
        XCTAssertGreaterThan(fileData.count, 0,
                           "SQLite file should have content")
        
        print("✅ SQLite file is encrypted. Header bytes: \(headerData.map { String(format: "%02x", $0) }.joined())")
    }
    
    func testEncryptionKeyGeneration() throws {
        // GIVEN: SecureStorage instance
        let secureStorage = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
        
        // WHEN: Generating encryption key
        let key1 = secureStorage.encryptionKey()
        let key2 = secureStorage.encryptionKey()
        
        // THEN: Keys should be consistent
        XCTAssertEqual(key1, key2, "Encryption key should be persistent")
        XCTAssertFalse(key1.isEmpty, "Encryption key should not be empty")
        
        // Verify key is base64 encoded
        XCTAssertNotNil(Data(base64Encoded: key1), "Key should be valid base64")
        
        // Verify key length (32 bytes = 44 chars in base64 with padding)
        let keyData = Data(base64Encoded: key1)!
        XCTAssertEqual(keyData.count, 32, "Key should be 32 bytes for AES-256")
        
        print("✅ Encryption key generated successfully: \(key1.prefix(10))...")
    }
}
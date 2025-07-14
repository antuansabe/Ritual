import XCTest
@testable import fit_app

class ManifestCopyTests: XCTestCase {
    
    func testPrivacyManifestIsCopiedToBundle() throws {
        // GIVEN: The app bundle
        let bundle = Bundle.main
        
        // WHEN: Looking for privacy-manifest.json
        let manifestURL = bundle.url(forResource: "privacy-manifest", withExtension: "json")
        
        // THEN: The file should exist in the bundle
        XCTAssertNotNil(manifestURL, "privacy-manifest.json should be copied to app bundle")
        
        if let url = manifestURL {
            // Verify the file exists
            XCTAssertTrue(FileManager.default.fileExists(atPath: url.path),
                         "privacy-manifest.json file should exist at bundle path")
            
            // Verify we can read the content
            let data = try Data(contentsOf: url)
            XCTAssertGreaterThan(data.count, 0, "privacy-manifest.json should have content")
            
            // Verify it's valid JSON
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            XCTAssertNotNil(json, "privacy-manifest.json should be valid JSON")
            
            // Verify expected structure
            if let jsonDict = json as? [String: Any] {
                XCTAssertNotNil(jsonDict["purposeStrings"], "JSON should contain purposeStrings")
                XCTAssertNotNil(jsonDict["categories"], "JSON should contain categories")
                XCTAssertNotNil(jsonDict["tracking"], "JSON should contain tracking")
                
                // Verify specific values
                if let purposeStrings = jsonDict["purposeStrings"] as? [String: String] {
                    XCTAssertEqual(purposeStrings["NSHealthShareUsageDescription"],
                                 "Ritmia usa tus entrenamientos para mostrar progreso.",
                                 "Purpose string should match expected value")
                }
                
                if let categories = jsonDict["categories"] as? [String] {
                    XCTAssertTrue(categories.contains("userID"), "Categories should include userID")
                    XCTAssertTrue(categories.contains("fitness"), "Categories should include fitness")
                }
                
                if let tracking = jsonDict["tracking"] as? Bool {
                    XCTAssertFalse(tracking, "Tracking should be false")
                }
            }
            
            print("✅ Privacy manifest found at: \(url.path)")
            print("✅ File size: \(data.count) bytes")
        }
    }
    
    func testInfoPlistContainsEncryptionKey() throws {
        // GIVEN: The Info.plist
        let bundle = Bundle.main
        
        // WHEN: Reading ITSAppUsesNonExemptEncryption key
        let encryptionExempt = bundle.object(forInfoDictionaryKey: "ITSAppUsesNonExemptEncryption") as? Bool
        
        // THEN: The key should exist and be false
        XCTAssertNotNil(encryptionExempt, "Info.plist should contain ITSAppUsesNonExemptEncryption key")
        XCTAssertEqual(encryptionExempt, false, "ITSAppUsesNonExemptEncryption should be false")
        
        print("✅ ITSAppUsesNonExemptEncryption = \(encryptionExempt ?? false)")
    }
}
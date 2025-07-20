import XCTest
@testable import fit_app

final class LegalDocsTests: XCTestCase {
    
    func testLegalDocsExist() {
        // Test that both legal documents exist in the bundle
        XCTAssertNotNil(
            Bundle.main.url(forResource: "privacy-policy", withExtension: "md"),
            "privacy-policy.md should exist in the bundle"
        )
        
        XCTAssertNotNil(
            Bundle.main.url(forResource: "terms-of-service", withExtension: "md"),
            "terms-of-service.md should exist in the bundle"
        )
    }
    
    func testLegalDocsContent() {
        // Test that documents have content and are not just placeholders
        guard let privacyURL = Bundle.main.url(forResource: "privacy-policy", withExtension: "md"),
              let privacyContent = try? String(contentsOf: privacyURL) else {
            XCTFail("privacy-policy.md should be readable")
            return
        }
        
        guard let termsURL = Bundle.main.url(forResource: "terms-of-service", withExtension: "md"),
              let termsContent = try? String(contentsOf: termsURL) else {
            XCTFail("terms-of-service.md should be readable")
            return
        }
        
        // Verify these are not placeholder documents
        XCTAssertFalse(privacyContent.contains("lorem ipsum"), "Privacy policy should not contain placeholder text")
        XCTAssertFalse(termsContent.contains("lorem ipsum"), "Terms of service should not contain placeholder text")
        
        // Verify they contain Spanish legal content
        XCTAssertTrue(privacyContent.contains("Ritmia"), "Privacy policy should mention the app name")
        XCTAssertTrue(termsContent.contains("Ritmia"), "Terms of service should mention the app name")
        
        // Verify minimum length (real legal docs should be substantial)
        XCTAssertGreaterThan(privacyContent.count, 1000, "Privacy policy should be substantial")
        XCTAssertGreaterThan(termsContent.count, 1000, "Terms of service should be substantial")
    }
    
    func testLegalViewEnum() {
        // Test that the enum works correctly
        XCTAssertEqual(LegalDoc.privacy.rawValue, "privacy-policy")
        XCTAssertEqual(LegalDoc.terms.rawValue, "terms-of-service")
        
        XCTAssertEqual(LegalDoc.privacy.title, "Política de Privacidad")
        XCTAssertEqual(LegalDoc.terms.title, "Términos de Servicio")
    }
    
    func testDebugConfiguration() {
        // In tests, we should verify the debug flag is configured properly
        #if DEBUG
        XCTAssertTrue(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.isDebug, "Debug flag should be true in DEBUG builds")
        #else
        XCTAssertFalse(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.isDebug, "Debug flag should be false in Release builds")
        #endif
    }
}
import XCTest
@testable import fit_app

final class LegalDocsTests: XCTestCase {
    
    func testLegalHTMLDocsExist() {
        // Test that both HTML legal documents exist in the bundle (primary files)
        XCTAssertNotNil(
            Bundle.main.url(forResource: "PrivacyPolicy", withExtension: "html"),
            "PrivacyPolicy.html should exist in the bundle"
        )
        
        XCTAssertNotNil(
            Bundle.main.url(forResource: "TermsOfService", withExtension: "html"),
            "TermsOfService.html should exist in the bundle"
        )
    }
    
    func testLegalMarkdownDocsExist() {
        // Test that both Markdown legal documents exist in the bundle (fallback files)
        XCTAssertNotNil(
            Bundle.main.url(forResource: "privacy-policy", withExtension: "md"),
            "privacy-policy.md should exist in the bundle"
        )
        
        XCTAssertNotNil(
            Bundle.main.url(forResource: "terms-of-service", withExtension: "md"),
            "terms-of-service.md should exist in the bundle"
        )
    }
    
    func testHTMLDocsContentClean() {
        // Test that HTML documents are clean and don't contain placeholder text
        guard let privacyURL = Bundle.main.url(forResource: "PrivacyPolicy", withExtension: "html"),
              let privacyContent = try? String(contentsOf: privacyURL) else {
            XCTFail("PrivacyPolicy.html should be readable")
            return
        }
        
        guard let termsURL = Bundle.main.url(forResource: "TermsOfService", withExtension: "html"),
              let termsContent = try? String(contentsOf: termsURL) else {
            XCTFail("TermsOfService.html should be readable")
            return
        }
        
        // CRITICAL: Verify NO lorem ipsum placeholder text
        XCTAssertFalse(privacyContent.contains("lorem ipsum"), "Privacy policy should not contain lorem ipsum")
        XCTAssertFalse(privacyContent.contains("Lorem ipsum"), "Privacy policy should not contain Lorem ipsum")
        XCTAssertFalse(privacyContent.contains("Sed ut perspiciatis"), "Privacy policy should not contain Sed ut perspiciatis")
        XCTAssertFalse(privacyContent.contains("Nam libero tempore"), "Privacy policy should not contain Nam libero tempore")
        
        XCTAssertFalse(termsContent.contains("lorem ipsum"), "Terms of service should not contain lorem ipsum")
        XCTAssertFalse(termsContent.contains("Lorem ipsum"), "Terms of service should not contain Lorem ipsum")
        XCTAssertFalse(termsContent.contains("Sed ut perspiciatis"), "Terms of service should not contain Sed ut perspiciatis")
        XCTAssertFalse(termsContent.contains("Nam libero tempore"), "Terms of service should not contain Nam libero tempore")
        
        // Verify they contain real Spanish legal content
        XCTAssertTrue(privacyContent.contains("Ritmia"), "Privacy policy should mention the app name")
        XCTAssertTrue(termsContent.contains("Ritmia"), "Terms of service should mention the app name")
        XCTAssertTrue(privacyContent.contains("Antonio Fernández"), "Privacy policy should mention the developer")
        XCTAssertTrue(termsContent.contains("Antonio Fernández"), "Terms of service should mention the developer")
        
        // Verify minimum length (real legal docs should be substantial)
        XCTAssertGreaterThan(privacyContent.count, 2000, "Privacy policy HTML should be substantial")
        XCTAssertGreaterThan(termsContent.count, 2000, "Terms of service HTML should be substantial")
    }
    
    func testMarkdownDocsContent() {
        // Test that Markdown documents have content and are not just placeholders
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
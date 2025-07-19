import XCTest
@testable import fit_app

final class LegalResourcesTests: XCTestCase {
    
    func testHTMLResourcesExist() {
        // Test that Privacy Policy HTML file exists in bundle
        let privacyPolicyURL = Bundle.main.url(forResource: "PrivacyPolicy", withExtension: "html")
        XCTAssertNotNil(privacyPolicyURL, "PrivacyPolicy.html should be included in app bundle")
        
        // Test that Terms of Service HTML file exists in bundle
        let termsURL = Bundle.main.url(forResource: "TermsOfService", withExtension: "html")
        XCTAssertNotNil(termsURL, "TermsOfService.html should be included in app bundle")
    }
    
    func testHTMLFilesAreReadable() {
        // Test Privacy Policy file is readable
        if let privacyPolicyURL = Bundle.main.url(forResource: "PrivacyPolicy", withExtension: "html") {
            XCTAssertNoThrow(try String(contentsOf: privacyPolicyURL), "PrivacyPolicy.html should be readable")
            
            let content = try? String(contentsOf: privacyPolicyURL)
            XCTAssertTrue(content?.isEmpty == false, "PrivacyPolicy.html should not be empty")
        }
        
        // Test Terms of Service file is readable
        if let termsURL = Bundle.main.url(forResource: "TermsOfService", withExtension: "html") {
            XCTAssertNoThrow(try String(contentsOf: termsURL), "TermsOfService.html should be readable")
            
            let content = try? String(contentsOf: termsURL)
            XCTAssertTrue(content?.isEmpty == false, "TermsOfService.html should not be empty")
        }
    }
}
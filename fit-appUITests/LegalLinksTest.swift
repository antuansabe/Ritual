import XCTest
import WebKit

final class LegalLinksTest: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testPrivacyPolicyLink() throws {
        // Navigate to Profile tab
        let perfilTab = app.tabBars.buttons["Perfil"]
        XCTAssertTrue(perfilTab.waitForExistence(timeout: 5), "Profile tab should exist")
        perfilTab.tap()
        
        // Find and tap Privacy Policy link
        let privacyPolicyButton = app.buttons["Política de privacidad"]
        XCTAssertTrue(privacyPolicyButton.waitForExistence(timeout: 5), "Privacy policy button should exist")
        privacyPolicyButton.tap()
        
        // Wait for WebView to load
        let webView = app.webViews.firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 10), "WebView should appear")
        
        // Verify that the privacy policy content is loaded
        let privacyTitle = app.staticTexts["Política de Privacidad"]
        XCTAssertTrue(privacyTitle.waitForExistence(timeout: 5), "Privacy policy title should be visible")
        
        // Go back
        if app.navigationBars.buttons.firstMatch.exists {
            app.navigationBars.buttons.firstMatch.tap()
        }
    }
    
    func testTermsOfServiceLink() throws {
        // Navigate to Profile tab
        let perfilTab = app.tabBars.buttons["Perfil"]
        XCTAssertTrue(perfilTab.waitForExistence(timeout: 5), "Profile tab should exist")
        perfilTab.tap()
        
        // Find and tap Terms of Service link
        let termsOfServiceButton = app.buttons["Términos de servicio"]
        XCTAssertTrue(termsOfServiceButton.waitForExistence(timeout: 5), "Terms of service button should exist")
        termsOfServiceButton.tap()
        
        // Wait for WebView to load
        let webView = app.webViews.firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 10), "WebView should appear")
        
        // Verify that the terms of service content is loaded
        let termsTitle = app.staticTexts["Términos de Servicio"]
        XCTAssertTrue(termsTitle.waitForExistence(timeout: 5), "Terms of service title should be visible")
        
        // Go back
        if app.navigationBars.buttons.firstMatch.exists {
            app.navigationBars.buttons.firstMatch.tap()
        }
    }
    
    func testLegalLinksExistInProfile() throws {
        // Navigate to Profile tab
        let perfilTab = app.tabBars.buttons["Perfil"]
        XCTAssertTrue(perfilTab.waitForExistence(timeout: 5), "Profile tab should exist")
        perfilTab.tap()
        
        // Scroll down to find legal links
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            scrollView.swipeUp()
        }
        
        // Verify both legal links exist
        let privacyPolicyButton = app.buttons["Política de privacidad"]
        let termsOfServiceButton = app.buttons["Términos de servicio"]
        
        XCTAssertTrue(privacyPolicyButton.exists, "Privacy policy button should exist")
        XCTAssertTrue(termsOfServiceButton.exists, "Terms of service button should exist")
        
        // Verify accessibility
        XCTAssertTrue(privacyPolicyButton.isHittable, "Privacy policy button should be tappable")
        XCTAssertTrue(termsOfServiceButton.isHittable, "Terms of service button should be tappable")
    }
    
    func testWebViewContentLoading() throws {
        // Navigate to Profile tab
        let perfilTab = app.tabBars.buttons["Perfil"]
        XCTAssertTrue(perfilTab.waitForExistence(timeout: 5), "Profile tab should exist")
        perfilTab.tap()
        
        // Test Privacy Policy WebView content
        let privacyPolicyButton = app.buttons["Política de privacidad"]
        XCTAssertTrue(privacyPolicyButton.waitForExistence(timeout: 5), "Privacy policy button should exist")
        privacyPolicyButton.tap()
        
        // Wait for WebView to fully load
        let webView = app.webViews.firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 10), "WebView should appear")
        
        // Wait a bit more for content to load
        sleep(2)
        
        // Verify WebView exists and is interactive
        XCTAssertTrue(webView.exists, "WebView should exist")
        
        // Try to scroll in the WebView to verify it's functional
        if webView.exists {
            webView.swipeUp()
            webView.swipeDown()
        }
        
        // Navigate back
        if app.navigationBars.buttons.firstMatch.exists {
            app.navigationBars.buttons.firstMatch.tap()
        }
    }
}
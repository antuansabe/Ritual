import XCTest
@testable import fit_app

class LocalizationKeyTests: XCTestCase {
    
    // Important keys that should exist in both Spanish and English
    private let criticalKeys = [
        "ONB_TITLE_1", "ONB_SUB_1",
        "ONB_TITLE_2", "ONB_SUB_2", 
        "ONB_TITLE_3", "ONB_SUB_3",
        "START_BTN", "SKIP_BTN",
        "GENERIC_ERROR", "NETWORK_ERROR", "AUTH_ERROR",
        "LOADING", "SAVING", "SYNCING",
        "OK", "CANCEL", "RETRY", "CLOSE",
        "HOME", "REGISTER", "TIMER", "HISTORY", "PROFILE"
    ]
    
    func testSpanishLocalizationKeysExist() {
        // Test that all critical keys exist in Spanish localization
        for key in criticalKeys {
            let localizedString = NSLocalizedString(key, bundle: Bundle.main, comment: "")
            XCTAssertNotEqual(localizedString, key, 
                             "Spanish localization missing for key: '\(key)'")
            XCTAssertFalse(localizedString.isEmpty, 
                          "Spanish localization is empty for key: '\(key)'")
        }
    }
    
    func testEnglishLocalizationKeysExist() {
        // Test that all critical keys exist in English localization
        let englishBundle = Bundle.main.path(forResource: "en", ofType: "lproj")
            .flatMap { Bundle(path: $0) } ?? Bundle.main
        
        for key in criticalKeys {
            let localizedString = NSLocalizedString(key, bundle: englishBundle, comment: "")
            XCTAssertNotEqual(localizedString, key, 
                             "English localization missing for key: '\(key)'")
            XCTAssertFalse(localizedString.isEmpty, 
                          "English localization is empty for key: '\(key)'")
        }
    }
    
    func testLocalizationStringExtension() {
        // Test the .t extension works correctly
        let localizedStart = "START_BTN".t
        let directLocalization = NSLocalizedString("START_BTN", comment: "")
        
        XCTAssertEqual(localizedStart, directLocalization, 
                      "String extension .t should return same result as NSLocalizedString")
        XCTAssertNotEqual(localizedStart, "START_BTN", 
                         "Localized string should not equal the key")
    }
    
    func testOnboardingKeysNotEmpty() {
        // Specific test for onboarding keys since they're critical for UX
        let onboardingKeys = ["ONB_TITLE_1", "ONB_TITLE_2", "ONB_TITLE_3", "START_BTN"]
        
        for key in onboardingKeys {
            let localized = key.t
            XCTAssertFalse(localized.isEmpty, "Onboarding key '\(key)' should not be empty")
            XCTAssertNotEqual(localized, key, "Onboarding key '\(key)' should be localized")
            XCTAssertTrue(localized.count > 3, "Onboarding key '\(key)' should have meaningful content")
        }
    }
    
    func testErrorMessageKeysExist() {
        // Test error message keys specifically
        let errorKeys = ["GENERIC_ERROR", "NETWORK_ERROR", "AUTH_ERROR"]
        
        for key in errorKeys {
            let localized = key.t
            XCTAssertNotEqual(localized, key, "Error key '\(key)' should be localized")
            XCTAssertTrue(localized.count > 10, "Error message '\(key)' should be descriptive")
        }
    }
    
    func testActionButtonKeysExist() {
        // Test action button keys
        let actionKeys = ["OK", "CANCEL", "RETRY", "CLOSE"]
        
        for key in actionKeys {
            let localized = key.t
            XCTAssertNotEqual(localized, key, "Action key '\(key)' should be localized")
            XCTAssertFalse(localized.isEmpty, "Action key '\(key)' should not be empty")
        }
    }
    
    func testNavigationKeysExist() {
        // Test navigation keys
        let navKeys = ["HOME", "REGISTER", "TIMER", "HISTORY", "PROFILE"]
        
        for key in navKeys {
            let localized = key.t
            XCTAssertNotEqual(localized, key, "Navigation key '\(key)' should be localized")
            XCTAssertFalse(localized.isEmpty, "Navigation key '\(key)' should not be empty")
        }
    }
    
    func testLocalizationHelperMethods() {
        // Test LocalizationHelper utility methods
        let currentLang = LocalizationHelper.currentLanguage
        XCTAssertTrue(["en", "es"].contains(currentLang) || currentLang.count == 2, 
                     "Current language should be a valid language code")
        
        let keyExists = LocalizationHelper.keyExists("START_BTN")
        XCTAssertTrue(keyExists, "START_BTN key should exist")
        
        let fakeKeyExists = LocalizationHelper.keyExists("NONEXISTENT_KEY_123")
        XCTAssertFalse(fakeKeyExists, "Fake key should not exist")
    }
}
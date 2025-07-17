import XCTest
import SwiftUI
@testable import fit_app

class WelcomeNameTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Clear any existing user name before each test
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
    }
    
    override func tearDown() {
        // Clean up after tests
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
        super.tearDown()
    }
    
    func testDefaultUserNameDisplayed() {
        // Test case 1: No user name stored, should show default
        let userName = pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.qZG15ZFGuYDd5FpaQeRKOxJz7vSXlxzL.BZSWPiEO0MeOPKVTrzLSfAQTVIO4Xo9i()
        
        XCTAssertEqual(userName, pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.DlHLlMeyuOHeFBIO58NGuiSSD5Z2YKSj.Bqc0PbT10QXG2oXLLc6yrDvpET6lFrbp, "Should return default user name when none is stored")
    }
    
    func testPersonalizedUserNameDisplayed() {
        // Test case 2: User name is stored, should show personalized greeting
        let testUserName = "TestUser"
        
        // Store the test user name
        let success = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.wBqxqyKHdtNvJSzEMZWFGBKcJx6iJ8hK(testUserName, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
        
        XCTAssertTrue(success, "Storing user name should succeed")
        
        // Retrieve the user name
        let userName = pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.qZG15ZFGuYDd5FpaQeRKOxJz7vSXlxzL.BZSWPiEO0MeOPKVTrzLSfAQTVIO4Xo9i()
        
        XCTAssertEqual(userName, testUserName, "Should return the stored user name")
    }
    
    func testWelcomeViewContainsUserName() {
        // Test case 3: WelcomeView contains the user name in the greeting
        let testUserName = "João"
        
        // Store the test user name
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.wBqxqyKHdtNvJSzEMZWFGBKcJx6iJ8hK(testUserName, for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
        
        // Create the welcome view (since it has obfuscated name, we test the function directly)
        let userName = pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.qZG15ZFGuYDd5FpaQeRKOxJz7vSXlxzL.BZSWPiEO0MeOPKVTrzLSfAQTVIO4Xo9i()
        
        XCTAssertEqual(userName, testUserName, "WelcomeView should display the stored user name")
    }
    
    func testLocalizedWelcomeMessage() {
        // Test case 4: Verify localized strings exist for personalized greeting
        let testUserName = "Maria"
        let englishGreeting = "HELLO_USER".t.replacingOccurrences(of: "{name}", with: testUserName)
        
        // The localized string should contain the user name
        XCTAssertTrue(englishGreeting.contains(testUserName), "Localized greeting should contain the user name")
        XCTAssertFalse(englishGreeting.contains("{name}"), "Localized greeting should not contain placeholder")
    }
    
    func testMotivationalPhraseGeneration() {
        // Test case 5: Verify motivational phrase generation works
        let phrase = pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.qZG15ZFGuYDd5FpaQeRKOxJz7vSXlxzL.W8dpI3lFmaeZTnurvJabtvAQFRaWZ2tW()
        
        XCTAssertFalse(phrase.isEmpty, "Motivational phrase should not be empty")
        XCTAssertTrue(phrase.count > 10, "Motivational phrase should be meaningful length")
    }
}
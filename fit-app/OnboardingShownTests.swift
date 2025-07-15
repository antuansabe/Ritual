import XCTest
@testable import fit_app

class OnboardingShownTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Clear any existing onboarding flag before each test
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: "hasSeenOnboarding")
    }
    
    override func tearDown() {
        // Clean up after tests
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: "hasSeenOnboarding")
        super.tearDown()
    }
    
    func testOnboardingFlagOffByDefault() {
        // Test case 1: Flag off (onboarding not seen)
        // When the app launches for the first time, hasSeenOnboarding should be nil/false
        let hasSeenOnboarding = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.xDNpJkHgR3T9mBzWqFvYc8aLtQsEu7Ko(for: "hasSeenOnboarding")
        
        XCTAssertNil(hasSeenOnboarding, "hasSeenOnboarding should be nil when not set")
    }
    
    func testOnboardingFlagCanBeSetToTrue() {
        // Test case 2: Flag on (onboarding has been seen)
        // Set the flag to true
        let success = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.wBqxqyKHdtNvJSzEMZWFGBKcJx6iJ8hK(true, for: "hasSeenOnboarding")
        
        XCTAssertTrue(success, "Setting hasSeenOnboarding to true should succeed")
        
        // Verify it was stored correctly
        let hasSeenOnboarding = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.xDNpJkHgR3T9mBzWqFvYc8aLtQsEu7Ko(for: "hasSeenOnboarding")
        
        XCTAssertNotNil(hasSeenOnboarding, "hasSeenOnboarding should not be nil after being set")
        XCTAssertTrue(hasSeenOnboarding!, "hasSeenOnboarding should be true after being set to true")
    }
    
    func testOnboardingFlagPersistence() {
        // Test that the flag persists across multiple accesses
        // Set the flag
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.wBqxqyKHdtNvJSzEMZWFGBKcJx6iJ8hK(true, for: "hasSeenOnboarding")
        
        // Read it multiple times to ensure persistence
        for _ in 0..<5 {
            let hasSeenOnboarding = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.xDNpJkHgR3T9mBzWqFvYc8aLtQsEu7Ko(for: "hasSeenOnboarding")
            XCTAssertTrue(hasSeenOnboarding ?? false, "hasSeenOnboarding should remain true")
        }
    }
    
    func testOnboardingFlagCanBeReset() {
        // Test that the flag can be set back to false
        // First set to true
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.wBqxqyKHdtNvJSzEMZWFGBKcJx6iJ8hK(true, for: "hasSeenOnboarding")
        
        // Then set to false
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.wBqxqyKHdtNvJSzEMZWFGBKcJx6iJ8hK(false, for: "hasSeenOnboarding")
        
        let hasSeenOnboarding = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.xDNpJkHgR3T9mBzWqFvYc8aLtQsEu7Ko(for: "hasSeenOnboarding")
        
        XCTAssertNotNil(hasSeenOnboarding, "hasSeenOnboarding should not be nil after being set")
        XCTAssertFalse(hasSeenOnboarding!, "hasSeenOnboarding should be false after being set to false")
    }
    
    func testOnboardingViewExistence() {
        // Test that OnboardingView can be instantiated
        let onboardingView = OnboardingView(hasCompletedOnboarding: .constant(false))
        XCTAssertNotNil(onboardingView, "OnboardingView should be instantiable")
    }
    
    func testOnboardingSlideExistence() {
        // Test that OnboardingSlide can be instantiated
        let slide = OnboardingSlide(
            icon: "bolt.heart",
            title: "Test Title",
            description: "Test Description"
        )
        XCTAssertNotNil(slide, "OnboardingSlide should be instantiable")
    }
}
import XCTest
import SwiftUI
@testable import fit_app

final class RootSwitcherTests: XCTestCase {
    var authViewModel: M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB!
    var navigationStateManager: NavigationStateManager!
    
    override func setUp() {
        super.setUp()
        authViewModel = M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB()
        navigationStateManager = NavigationStateManager()
        
        // Clear any existing state
        UserDefaults.standard.removeObject(forKey: "hasSeenWelcome")
        UserDefaults.standard.removeObject(forKey: "hasSeenOnboarding")
    }
    
    override func tearDown() {
        authViewModel = nil
        navigationStateManager = nil
        
        // Clean up UserDefaults
        UserDefaults.standard.removeObject(forKey: "hasSeenWelcome")
        UserDefaults.standard.removeObject(forKey: "hasSeenOnboarding")
        
        super.tearDown()
    }
    
    func testInitialStateShowsLogin() {
        // Given: User is not authenticated
        authViewModel.isLoggedIn = false
        
        // When: RootSwitcher is rendered
        // Then: Should show login view (verified through auth state)
        XCTAssertFalse(authViewModel.isLoggedIn, "Should start with unauthenticated state")
        XCTAssertFalse(navigationStateManager.showWelcome, "Should not show welcome initially")
    }
    
    func testLoginSuccessTriggersWelcomeFlow() {
        // Given: User successfully logs in and has seen onboarding
        HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.r0AqoYxLhfNYCN9Nib0HLfzhDAmXp8ry("true", for: "hasSeenOnboarding")
        authViewModel.isLoggedIn = true
        
        // When: Navigation state manager is set up
        navigationStateManager.triggerWelcome()
        
        // Then: Should show welcome
        XCTAssertTrue(navigationStateManager.showWelcome, "Should trigger welcome after login")
    }
    
    func testWelcomeCompletionNavigatesToTabBar() {
        // Given: User is in welcome flow
        authViewModel.isLoggedIn = true
        navigationStateManager.showWelcome = true
        
        // When: User completes welcome
        navigationStateManager.completeWelcome()
        UserDefaults.standard.set(true, forKey: "hasSeenWelcome")
        
        // Then: Should no longer show welcome
        XCTAssertFalse(navigationStateManager.showWelcome, "Should complete welcome flow")
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "hasSeenWelcome"), "Should mark welcome as seen")
    }
    
    func testReturningUserSkipsWelcome() {
        // Given: User has seen welcome before
        UserDefaults.standard.set(true, forKey: "hasSeenWelcome")
        HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.r0AqoYxLhfNYCN9Nib0HLfzhDAmXp8ry("true", for: "hasSeenOnboarding")
        authViewModel.isLoggedIn = true
        
        // When: RootSwitcher evaluates state
        // Then: Should not show welcome
        XCTAssertFalse(navigationStateManager.showWelcome, "Returning user should skip welcome")
    }
    
    func testLogoutResetsNavigationState() {
        // Given: User is authenticated with navigation state
        authViewModel.isLoggedIn = true
        navigationStateManager.showWelcome = true
        navigationStateManager.rootTab = 2
        
        // When: User logs out
        authViewModel.isLoggedIn = false
        navigationStateManager.showWelcome = false
        navigationStateManager.rootTab = 0
        
        // Then: Navigation state should be reset
        XCTAssertFalse(authViewModel.isLoggedIn, "Should be logged out")
        XCTAssertFalse(navigationStateManager.showWelcome, "Welcome should be reset")
        XCTAssertEqual(navigationStateManager.rootTab, 0, "Should reset to home tab")
    }
    
    func testNavigationStateManagerTabNavigation() {
        // Given: NavigationStateManager
        XCTAssertEqual(navigationStateManager.rootTab, 0, "Should start on home tab")
        
        // When: Navigate to different tabs
        navigationStateManager.navigateToTab(1)
        XCTAssertEqual(navigationStateManager.rootTab, 1, "Should navigate to register tab")
        
        navigationStateManager.navigateToTab(3)
        XCTAssertEqual(navigationStateManager.rootTab, 3, "Should navigate to history tab")
    }
    
    func testIsRootViewLogic() {
        // Given: NavigationStateManager on home tab
        navigationStateManager.rootTab = 0
        
        // When: Check if root view
        // Then: Should return true for home tab
        XCTAssertTrue(navigationStateManager.isRootView(), "Home tab should be root view")
        
        // When: Navigate to different tab
        navigationStateManager.navigateToTab(2)
        
        // Then: Should not be root view
        XCTAssertFalse(navigationStateManager.isRootView(), "Other tabs should not be root view")
    }
}
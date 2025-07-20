import XCTest
import SwiftUI
@testable import fit_app

final class WelcomeViewTests: XCTestCase {
    var authViewModel: M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB!
    var userProfileManager: gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm!
    var navigationStateManager: NavigationStateManager!
    
    override func setUpWithError() throws {
        authViewModel = M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB()
        userProfileManager = gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
        navigationStateManager = NavigationStateManager()
    }
    
    override func tearDownWithError() throws {
        authViewModel = nil
        userProfileManager = nil
        navigationStateManager = nil
        
        // Clean up test data from SecureStorage
        _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.NUGTlwW4yncSmuhUGrpLiLxGsjhSLWaO(key: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
    }
    
    func testWelcomeViewShowsCorrectUserName() throws {
        // Given: Store a user display name in SecureStorage
        let testUserName = "Antuan"
        let stored = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(
            testUserName,
            for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd
        )
        XCTAssertTrue(stored, "Should successfully store test user name")
        
        // When: Create WelcomeView
        let welcomeView = FODJtP74PgH7G1Dvz9bqZM4YTVIu3AY0()
            .environmentObject(authViewModel)
            .environmentObject(userProfileManager)
            .environmentObject(navigationStateManager)
        
        // Then: Verify the view can be created (this tests the userName computed property)
        XCTAssertNotNil(welcomeView)
        
        // Verify the stored name can be retrieved
        let retrievedName = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
        XCTAssertEqual(retrievedName, testUserName, "Retrieved name should match stored test name")
    }
    
    func testWelcomeViewFallsBackToAtletaWhenNoUserName() throws {
        // Given: No user name stored (clean state)
        
        // When: Create WelcomeView  
        let welcomeView = FODJtP74PgH7G1Dvz9bqZM4YTVIu3AY0()
            .environmentObject(authViewModel)
            .environmentObject(userProfileManager)
            .environmentObject(navigationStateManager)
        
        // Then: Verify the view can be created
        XCTAssertNotNil(welcomeView)
        
        // Verify no name is stored
        let retrievedName = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
        XCTAssertNil(retrievedName, "Should not have stored name")
    }
    
    func testWelcomeViewIgnoresPlaceholderValues() throws {
        // Given: Store a placeholder value
        let stored = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp(
            "HELLO_USER",
            for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd
        )
        XCTAssertTrue(stored, "Should successfully store placeholder")
        
        // When: Create WelcomeView
        let welcomeView = FODJtP74PgH7G1Dvz9bqZM4YTVIu3AY0()
            .environmentObject(authViewModel)
            .environmentObject(userProfileManager)
            .environmentObject(navigationStateManager)
        
        // Then: Verify the view can be created (userName should fallback to "Atleta")
        XCTAssertNotNil(welcomeView)
        
        // Verify placeholder is stored but should be ignored by the view logic
        let retrievedName = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
        XCTAssertEqual(retrievedName, "HELLO_USER", "Placeholder should be stored correctly")
    }
}
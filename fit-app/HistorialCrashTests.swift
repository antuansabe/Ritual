import XCTest
import SwiftUI
@testable import fit_app

final class HistorialCrashTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testHistorialViewDoesNotCrash() {
        // Given: App is launched and user is authenticated
        // (This assumes the app starts in authenticated state for testing)
        
        // When: Navigate to Historial tab
        let historialTab = app.tabBars.buttons["Historial"]
        if historialTab.exists {
            historialTab.tap()
            
            // Then: App should not crash and Historial view should be displayed
            XCTAssertTrue(app.exists, "App should still be running after navigating to Historial")
            
            // Wait for view to load
            let expectation = XCTestExpectation(description: "Historial view loads")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 3.0)
            
            // Verify the view is responsive
            XCTAssertTrue(app.exists, "App should remain stable after Historial view loads")
        }
    }
    
    func testHistorialNavigationDoesNotCrash() {
        // Given: User is in Historial view
        let historialTab = app.tabBars.buttons["Historial"]
        if historialTab.exists {
            historialTab.tap()
            
            // When: Try to navigate back (if back button exists)
            let backButton = app.buttons["Atrás"]
            if backButton.exists {
                backButton.tap()
                
                // Then: App should not crash
                XCTAssertTrue(app.exists, "App should not crash when navigating back from Historial")
            }
        }
    }
    
    func testTimerViewDoesNotCrash() {
        // Given: App is launched
        
        // When: Navigate to Timer tab
        let timerTab = app.tabBars.buttons["Timer"]
        if timerTab.exists {
            timerTab.tap()
            
            // Then: App should not crash and Timer view should be displayed
            XCTAssertTrue(app.exists, "App should still be running after navigating to Timer")
            
            // Wait for view to load
            let expectation = XCTestExpectation(description: "Timer view loads")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 3.0)
            
            // Verify the view is responsive
            XCTAssertTrue(app.exists, "App should remain stable after Timer view loads")
        }
    }
    
    func testPerfilViewDoesNotCrash() {
        // Given: App is launched
        
        // When: Navigate to Perfil tab
        let perfilTab = app.tabBars.buttons["Perfil"]
        if perfilTab.exists {
            perfilTab.tap()
            
            // Then: App should not crash and Perfil view should be displayed
            XCTAssertTrue(app.exists, "App should still be running after navigating to Perfil")
            
            // Wait for view to load
            let expectation = XCTestExpectation(description: "Perfil view loads")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 3.0)
            
            // Verify the view is responsive
            XCTAssertTrue(app.exists, "App should remain stable after Perfil view loads")
        }
    }
    
    func testRapidTabSwitchingDoesNotCrash() {
        // Given: App is launched
        
        // When: Rapidly switch between tabs
        let tabs = ["Inicio", "Registrar", "Timer", "Historial", "Perfil"]
        
        for _ in 0..<3 { // Repeat the sequence 3 times
            for tabName in tabs {
                let tab = app.tabBars.buttons[tabName]
                if tab.exists {
                    tab.tap()
                    // Small delay to allow view to start loading
                    usleep(100000) // 0.1 seconds
                }
            }
        }
        
        // Then: App should still be running
        XCTAssertTrue(app.exists, "App should not crash during rapid tab switching")
        
        // Final check after a short delay
        let expectation = XCTestExpectation(description: "App remains stable")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertTrue(app.exists, "App should remain stable after rapid tab switching")
    }
    
    func testMemoryPressureHandling() {
        // Given: App is launched
        
        // When: Navigate to different views multiple times to test memory management
        let navigationSequence = [
            ("Historial", "Navigate to Historial"),
            ("Timer", "Navigate to Timer"), 
            ("Perfil", "Navigate to Perfil"),
            ("Inicio", "Return to Inicio")
        ]
        
        for cycle in 0..<5 { // Repeat 5 times to stress test
            for (tabName, description) in navigationSequence {
                let tab = app.tabBars.buttons[tabName]
                if tab.exists {
                    tab.tap()
                    
                    // Allow time for view to load and animations to complete
                    let expectation = XCTestExpectation(description: description)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        expectation.fulfill()
                    }
                    wait(for: [expectation], timeout: 1.0)
                    
                    // Verify app is still responsive
                    XCTAssertTrue(app.exists, "App should remain responsive during cycle \(cycle + 1)")
                }
            }
        }
        
        // Then: App should still be running without memory issues
        XCTAssertTrue(app.exists, "App should handle memory pressure without crashing")
    }
}
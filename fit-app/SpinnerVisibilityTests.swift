import XCTest
import SwiftUI
@testable import fit_app

class SpinnerVisibilityTests: XCTestCase {
    
    func testLoadingSpinnerViewInit() {
        // Test that LoadingSpinnerView can be initialized with default message
        let defaultSpinner = LoadingSpinnerView()
        XCTAssertNotNil(defaultSpinner, "LoadingSpinnerView should initialize with default message")
        
        // Test that LoadingSpinnerView can be initialized with custom message
        let customSpinner = LoadingSpinnerView(message: "Custom Loading")
        XCTAssertNotNil(customSpinner, "LoadingSpinnerView should initialize with custom message")
    }
    
    func testLoadingOverlayModifier() {
        // Test that loading overlay modifier can be applied to views
        let testView = Text("Test Content")
        let viewWithOverlay = testView.loadingOverlay(isLoading: true)
        XCTAssertNotNil(viewWithOverlay, "Loading overlay should be applicable to any view")
        
        let viewWithoutOverlay = testView.loadingOverlay(isLoading: false)
        XCTAssertNotNil(viewWithoutOverlay, "Loading overlay should be applicable even when not loading")
    }
    
    func testErrorAlertCreation() {
        // Test default error alert
        let defaultError = ErrorAlert()
        XCTAssertNotNil(defaultError.alert, "Default error alert should be created")
        
        // Test custom error alert
        let customError = ErrorAlert(
            title: "Custom Title",
            message: "Custom Message",
            primaryButton: .default(Text("OK"))
        )
        XCTAssertNotNil(customError.alert, "Custom error alert should be created")
    }
    
    func testErrorStateManagerInitialization() {
        // Test ErrorStateManager initialization
        let errorManager = ErrorStateManager()
        XCTAssertFalse(errorManager.showError, "Error manager should initialize with showError = false")
        XCTAssertEqual(errorManager.errorMessage, "GENERIC_ERROR".t, "Error manager should initialize with generic error message")
        XCTAssertEqual(errorManager.errorTitle, "Error", "Error manager should initialize with default title")
    }
    
    func testErrorStateManagerGenericError() {
        // Test generic error display
        let errorManager = ErrorStateManager()
        errorManager.showGenericError()
        
        XCTAssertTrue(errorManager.showError, "showError should be true after showing generic error")
        XCTAssertEqual(errorManager.errorMessage, "GENERIC_ERROR".t, "Error message should be generic error")
        XCTAssertEqual(errorManager.errorTitle, "Error", "Error title should be 'Error'")
    }
    
    func testErrorStateManagerNetworkError() {
        // Test network error display
        let errorManager = ErrorStateManager()
        errorManager.showNetworkError()
        
        XCTAssertTrue(errorManager.showError, "showError should be true after showing network error")
        XCTAssertEqual(errorManager.errorMessage, "NETWORK_ERROR".t, "Error message should be network error")
        XCTAssertEqual(errorManager.errorTitle, "Error", "Error title should be 'Error'")
    }
    
    func testErrorStateManagerAuthError() {
        // Test auth error display
        let errorManager = ErrorStateManager()
        errorManager.showAuthError()
        
        XCTAssertTrue(errorManager.showError, "showError should be true after showing auth error")
        XCTAssertEqual(errorManager.errorMessage, "AUTH_ERROR".t, "Error message should be auth error")
        XCTAssertEqual(errorManager.errorTitle, "Error", "Error title should be 'Error'")
    }
    
    func testErrorStateManagerCustomError() {
        // Test custom error display
        let errorManager = ErrorStateManager()
        let customTitle = "Custom Title"
        let customMessage = "Custom error message"
        
        errorManager.showCustomError(title: customTitle, message: customMessage)
        
        XCTAssertTrue(errorManager.showError, "showError should be true after showing custom error")
        XCTAssertEqual(errorManager.errorMessage, customMessage, "Error message should be custom message")
        XCTAssertEqual(errorManager.errorTitle, customTitle, "Error title should be custom title")
    }
    
    func testViewModifierExtensions() {
        // Test that view modifier extensions work
        let testView = Text("Test")
        
        let viewWithGenericAlert = testView.genericErrorAlert(isPresented: .constant(false))
        XCTAssertNotNil(viewWithGenericAlert, "Generic error alert modifier should work")
        
        let viewWithCustomAlert = testView.errorAlert(
            isPresented: .constant(false),
            title: "Custom",
            message: "Custom message"
        )
        XCTAssertNotNil(viewWithCustomAlert, "Custom error alert modifier should work")
    }
    
    func testLoadingMessages() {
        // Test different loading messages
        let loadingSpinner = LoadingSpinnerView(message: "LOADING".t)
        XCTAssertNotNil(loadingSpinner, "Loading spinner with LOADING message should work")
        
        let savingSpinner = LoadingSpinnerView(message: "SAVING".t)
        XCTAssertNotNil(savingSpinner, "Loading spinner with SAVING message should work")
        
        let syncingSpinner = LoadingSpinnerView(message: "SYNCING".t)
        XCTAssertNotNil(syncingSpinner, "Loading spinner with SYNCING message should work")
    }
    
    func testLoadingSpinnerLocalizedMessages() {
        // Test that localized loading messages are not empty
        let loadingText = "LOADING".t
        XCTAssertFalse(loadingText.isEmpty, "Loading text should not be empty")
        XCTAssertNotEqual(loadingText, "LOADING", "Loading text should be localized")
        
        let savingText = "SAVING".t
        XCTAssertFalse(savingText.isEmpty, "Saving text should not be empty")
        XCTAssertNotEqual(savingText, "SAVING", "Saving text should be localized")
        
        let syncingText = "SYNCING".t
        XCTAssertFalse(syncingText.isEmpty, "Syncing text should not be empty")
        XCTAssertNotEqual(syncingText, "SYNCING", "Syncing text should be localized")
    }
}
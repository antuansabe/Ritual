import SwiftUI

// MARK: - Generic Error Alert
struct ErrorAlert {
    let title: String
    let message: String
    let primaryButton: Alert.Button?
    let secondaryButton: Alert.Button?
    
    init(
        title: String = "Error",
        message: String = "GENERIC_ERROR".t,
        primaryButton: Alert.Button? = nil,
        secondaryButton: Alert.Button? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
    
    var alert: Alert {
        if let primary = primaryButton, let secondary = secondaryButton {
            return Alert(
                title: Text(title),
                message: Text(message),
                primaryButton: primary,
                secondaryButton: secondary
            )
        } else if let primary = primaryButton {
            return Alert(
                title: Text(title),
                message: Text(message),
                dismissButton: primary
            )
        } else {
            return Alert(
                title: Text(title),
                message: Text(message),
                dismissButton: .default(Text("OK".t))
            )
        }
    }
}

// MARK: - Error Alert Modifier
struct ErrorAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let errorAlert: ErrorAlert
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                errorAlert.alert
            }
    }
}

extension View {
    func errorAlert(
        isPresented: Binding<Bool>,
        title: String = "Error",
        message: String = "GENERIC_ERROR".t,
        primaryButton: Alert.Button? = nil,
        secondaryButton: Alert.Button? = nil
    ) -> some View {
        let errorAlert = ErrorAlert(
            title: title,
            message: message,
            primaryButton: primaryButton,
            secondaryButton: secondaryButton
        )
        return self.modifier(ErrorAlertModifier(isPresented: isPresented, errorAlert: errorAlert))
    }
    
    func genericErrorAlert(isPresented: Binding<Bool>) -> some View {
        self.errorAlert(isPresented: isPresented)
    }
}

// MARK: - Error State Manager
class ErrorStateManager: ObservableObject {
    @Published var showError = false
    @Published var errorMessage = "GENERIC_ERROR".t
    @Published var errorTitle = "Error"
    
    func showGenericError() {
        errorTitle = "Error"
        errorMessage = "GENERIC_ERROR".t
        showError = true
    }
    
    func showNetworkError() {
        errorTitle = "Error"
        errorMessage = "NETWORK_ERROR".t
        showError = true
    }
    
    func showAuthError() {
        errorTitle = "Error"
        errorMessage = "AUTH_ERROR".t
        showError = true
    }
    
    func showCustomError(title: String = "Error", message: String) {
        errorTitle = title
        errorMessage = message
        showError = true
    }
}
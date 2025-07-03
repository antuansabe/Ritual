import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    
    // Dummy credentials
    private let dummyEmail = "test@test.com"
    private let dummyPassword = "123456"
    
    func login() {
        errorMessage = nil
        
        if email == dummyEmail && password == dummyPassword {
            isAuthenticated = true
        } else {
            errorMessage = "Email o contraseña incorrectos"
        }
    }
    
    func register() {
        errorMessage = nil
        
        if email.isEmpty {
            errorMessage = "El email no puede estar vacío"
            return
        }
        
        if password != confirmPassword {
            errorMessage = "Las contraseñas no coinciden"
            return
        }
        
        // Simulate successful registration
        isAuthenticated = true
    }
    
    func logout() {
        isAuthenticated = false
        email = ""
        password = ""
        confirmPassword = ""
        errorMessage = nil
    }
}
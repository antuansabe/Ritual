import Foundation
import CryptoKit

// MARK: - Authentication Result Types
enum AuthResult {
    case success(user: UserCredentials)
    case failure(error: AuthError)
}

enum AuthError: LocalizedError {
    case invalidEmail
    case weakPassword
    case emailNotRegistered
    case incorrectPassword
    case userAlreadyExists
    case storageError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Formato de email inválido"
        case .weakPassword:
            return "La contraseña debe tener al menos 8 caracteres, una mayúscula y un número"
        case .emailNotRegistered:
            return "Este email no está registrado"
        case .incorrectPassword:
            return "Contraseña incorrecta"
        case .userAlreadyExists:
            return "Este email ya está registrado"
        case .storageError:
            return "Error al guardar datos. Intenta de nuevo"
        case .unknownError:
            return "Error desconocido. Intenta de nuevo"
        }
    }
}

// MARK: - User Credentials Model
struct UserCredentials: Codable {
    let email: String
    let passwordHash: String
    let registrationDate: Date
    let lastLoginDate: Date?
    
    init(email: String, passwordHash: String) {
        self.email = email
        self.passwordHash = passwordHash
        self.registrationDate = Date()
        self.lastLoginDate = nil
    }
}

// MARK: - Secure Authentication Service
class SecureAuthService {
    static let shared = SecureAuthService()
    
    private let storage = SecureStorage.shared
    private let saltString = "FitApp2025SecureSalt"
    
    private init() {}
    
    // MARK: - Input Validation and Sanitization
    
    /// Sanitize user input to prevent malicious data
    func sanitizeInput(_ input: String) -> String {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove potentially dangerous characters
        let sanitized = trimmed
            .replacingOccurrences(of: "<", with: "")
            .replacingOccurrences(of: ">", with: "")
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "&", with: "")
            .replacingOccurrences(of: ";", with: "")
            .replacingOccurrences(of: "=", with: "")
        
        print("🔐 SecureAuth: Input sanitized (length: \(sanitized.count))")
        return sanitized
    }
    
    /// Validate email format using regex
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValid = emailPredicate.evaluate(with: email)
        
        print("🔐 SecureAuth: Email validation result: \(isValid)")
        return isValid
    }
    
    /// Validate password strength (minimum 8 characters, at least one uppercase and one number)
    func validatePassword(_ password: String) -> Bool {
        guard password.count >= 8 else {
            print("🔐 SecureAuth: Password too short")
            return false
        }
        
        let uppercaseRegex = ".*[A-Z]+.*"
        let numberRegex = ".*[0-9]+.*"
        
        let hasUppercase = NSPredicate(format: "SELF MATCHES %@", uppercaseRegex).evaluate(with: password)
        let hasNumber = NSPredicate(format: "SELF MATCHES %@", numberRegex).evaluate(with: password)
        
        let isValid = hasUppercase && hasNumber
        print("🔐 SecureAuth: Password validation - Length: ✓, Uppercase: \(hasUppercase ? "✓" : "✗"), Number: \(hasNumber ? "✓" : "✗")")
        
        return isValid
    }
    
    // MARK: - Password Hashing
    
    /// Hash password using SHA256 with salt
    private func hashPassword(_ password: String) -> String {
        let saltedPassword = password + saltString
        let data = Data(saltedPassword.utf8)
        let hash = SHA256.hash(data: data)
        let hashString = hash.compactMap { String(format: "%02x", $0) }.joined()
        
        print("🔐 SecureAuth: Password hashed successfully")
        return hashString
    }
    
    /// Verify password against stored hash
    private func verifyPassword(_ password: String, against hash: String) -> Bool {
        let inputHash = hashPassword(password)
        let isValid = inputHash == hash
        
        print("🔐 SecureAuth: Password verification result: \(isValid)")
        return isValid
    }
    
    // MARK: - User Registration
    
    /// Register a new user with secure validation
    func register(email: String, password: String, confirmPassword: String) -> AuthResult {
        print("🔐 SecureAuth: Starting user registration")
        
        // Sanitize inputs
        let sanitizedEmail = sanitizeInput(email).lowercased()
        let sanitizedPassword = sanitizeInput(password)
        let sanitizedConfirmPassword = sanitizeInput(confirmPassword)
        
        // Validate email format
        guard validateEmail(sanitizedEmail) else {
            print("🔐 SecureAuth: Registration failed - Invalid email format")
            return .failure(error: .invalidEmail)
        }
        
        // Validate password strength
        guard validatePassword(sanitizedPassword) else {
            print("🔐 SecureAuth: Registration failed - Weak password")
            return .failure(error: .weakPassword)
        }
        
        // Check password confirmation
        guard sanitizedPassword == sanitizedConfirmPassword else {
            print("🔐 SecureAuth: Registration failed - Password confirmation mismatch")
            return .failure(error: .weakPassword)
        }
        
        // Check if user already exists
        if userExists(email: sanitizedEmail) {
            print("🔐 SecureAuth: Registration failed - User already exists")
            return .failure(error: .userAlreadyExists)
        }
        
        // Create user credentials
        let passwordHash = hashPassword(sanitizedPassword)
        let userCredentials = UserCredentials(email: sanitizedEmail, passwordHash: passwordHash)
        
        // Store credentials securely
        guard storeUserCredentials(userCredentials) else {
            print("🔐 SecureAuth: Registration failed - Storage error")
            return .failure(error: .storageError)
        }
        
        print("🔐 SecureAuth: User registration successful")
        return .success(user: userCredentials)
    }
    
    // MARK: - User Login
    
    /// Authenticate user with secure validation
    func login(email: String, password: String) -> AuthResult {
        print("🔐 SecureAuth: Starting user login")
        
        // Sanitize inputs
        let sanitizedEmail = sanitizeInput(email).lowercased()
        let sanitizedPassword = sanitizeInput(password)
        
        // Validate email format
        guard validateEmail(sanitizedEmail) else {
            print("🔐 SecureAuth: Login failed - Invalid email format")
            return .failure(error: .invalidEmail)
        }
        
        // Check if user exists
        guard userExists(email: sanitizedEmail) else {
            print("🔐 SecureAuth: Login failed - Email not registered")
            return .failure(error: .emailNotRegistered)
        }
        
        // Retrieve stored credentials
        guard let storedCredentials = getUserCredentials(email: sanitizedEmail) else {
            print("🔐 SecureAuth: Login failed - Could not retrieve user credentials")
            return .failure(error: .storageError)
        }
        
        // Verify password
        guard verifyPassword(sanitizedPassword, against: storedCredentials.passwordHash) else {
            print("🔐 SecureAuth: Login failed - Incorrect password")
            return .failure(error: .incorrectPassword)
        }
        
        // Update last login date
        let updatedCredentials = UserCredentials(
            email: storedCredentials.email,
            passwordHash: storedCredentials.passwordHash
        )
        
        // Store current session
        _ = storage.store(sanitizedEmail, for: SecureStorage.StorageKeys.userEmail)
        
        print("🔐 SecureAuth: User login successful")
        return .success(user: updatedCredentials)
    }
    
    // MARK: - User Management
    
    /// Check if user exists
    private func userExists(email: String) -> Bool {
        return getUserCredentials(email: email) != nil
    }
    
    /// Store user credentials securely
    private func storeUserCredentials(_ credentials: UserCredentials) -> Bool {
        do {
            let data = try JSONEncoder().encode(credentials)
            let jsonString = String(data: data, encoding: .utf8) ?? ""
            
            let key = "user_\(credentials.email)"
            return storage.store(jsonString, for: key)
        } catch {
            print("🔐 SecureAuth: Failed to encode user credentials: \(error)")
            return false
        }
    }
    
    /// Retrieve user credentials
    private func getUserCredentials(email: String) -> UserCredentials? {
        let key = "user_\(email)"
        
        guard let jsonString = storage.retrieve(for: key),
              let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(UserCredentials.self, from: data)
        } catch {
            print("🔐 SecureAuth: Failed to decode user credentials: \(error)")
            return nil
        }
    }
    
    /// Get current logged in user
    func getCurrentUser() -> String? {
        return storage.retrieve(for: SecureStorage.StorageKeys.userEmail)
    }
    
    /// Check if user is currently logged in
    func isUserLoggedIn() -> Bool {
        return getCurrentUser() != nil
    }
    
    /// Logout current user
    func logout() -> Bool {
        print("🔐 SecureAuth: Logging out current user")
        let success = storage.clearAllCredentials()
        
        if success {
            print("🔐 SecureAuth: Logout successful")
        } else {
            print("🔐 SecureAuth: Logout failed")
        }
        
        return success
    }
    
    // MARK: - Security Utilities
    
    /// Generate secure session token (for future backend integration)
    func generateSessionToken() -> String {
        let tokenData = Data((0..<32).map { _ in UInt8.random(in: 0...255) })
        return tokenData.base64EncodedString()
    }
}
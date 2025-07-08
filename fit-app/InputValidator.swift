import Foundation
import SwiftUI

/// Comprehensive input validation and sanitization class
/// Provides security validation for all user inputs in the fitness app
class InputValidator {
    static let shared = InputValidator()
    
    private init() {}
    
    // MARK: - Input Sanitization
    
    /// Sanitize user input to remove dangerous characters and normalize whitespace
    /// - Parameter input: Raw user input string
    /// - Returns: Sanitized string safe for storage and processing
    func sanitizeInput(_ input: String) -> String {
        // Remove leading/trailing whitespace and newlines
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove potentially dangerous characters for injection prevention
        let sanitized = trimmed
            .replacingOccurrences(of: "<", with: "")          // HTML tags
            .replacingOccurrences(of: ">", with: "")          // HTML tags
            .replacingOccurrences(of: "\"", with: "")         // Double quotes
            .replacingOccurrences(of: "'", with: "")          // Single quotes
            .replacingOccurrences(of: "&", with: "")          // Ampersand
            .replacingOccurrences(of: ";", with: "")          // Semicolon
            .replacingOccurrences(of: "=", with: "")          // Equal sign
            .replacingOccurrences(of: "%", with: "")          // Percent encoding
            .replacingOccurrences(of: "+", with: "")          // Plus sign
            .replacingOccurrences(of: "\\", with: "")         // Backslash
            .replacingOccurrences(of: "/", with: "")          // Forward slash
            .replacingOccurrences(of: "|", with: "")          // Pipe
            .replacingOccurrences(of: "`", with: "")          // Backtick
            .replacingOccurrences(of: "~", with: "")          // Tilde
            .replacingOccurrences(of: "!", with: "")          // Exclamation
            .replacingOccurrences(of: "@", with: "")          // At symbol (except in emails)
            .replacingOccurrences(of: "#", with: "")          // Hash
            .replacingOccurrences(of: "$", with: "")          // Dollar sign
            .replacingOccurrences(of: "^", with: "")          // Caret
            .replacingOccurrences(of: "*", with: "")          // Asterisk
            .replacingOccurrences(of: "(", with: "")          // Parentheses
            .replacingOccurrences(of: ")", with: "")          // Parentheses
            .replacingOccurrences(of: "[", with: "")          // Brackets
            .replacingOccurrences(of: "]", with: "")          // Brackets
            .replacingOccurrences(of: "{", with: "")          // Braces
            .replacingOccurrences(of: "}", with: "")          // Braces
        
        // Normalize multiple spaces to single space
        let normalized = sanitized.replacingOccurrences(
            of: "\\s+", 
            with: " ", 
            options: .regularExpression
        )
        
        return normalized.trimmingCharacters(in: .whitespaces)
    }
    
    /// Sanitize email input (preserves @ and . for email format)
    /// - Parameter email: Raw email input
    /// - Returns: Sanitized email string
    func sanitizeEmail(_ email: String) -> String {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // Remove dangerous characters but preserve email-specific ones
        let sanitized = trimmed
            .replacingOccurrences(of: "<", with: "")
            .replacingOccurrences(of: ">", with: "")
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: ";", with: "")
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: "\\", with: "")
            .replacingOccurrences(of: "|", with: "")
            .replacingOccurrences(of: "`", with: "")
            .replacingOccurrences(of: "~", with: "")
            .replacingOccurrences(of: "!", with: "")
            .replacingOccurrences(of: "#", with: "")
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: "^", with: "")
            .replacingOccurrences(of: "*", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
            .replacingOccurrences(of: "{", with: "")
            .replacingOccurrences(of: "}", with: "")
        
        return sanitized
    }
    
    // MARK: - Email Validation
    
    /// Validate email format with comprehensive regex
    /// - Parameter email: Email string to validate
    /// - Returns: ValidationResult with success/failure and error message
    func isValidEmail(_ email: String) -> ValidationResult {
        let sanitizedEmail = sanitizeEmail(email)
        
        // Check if empty
        guard !sanitizedEmail.isEmpty else {
            return ValidationResult(isValid: false, errorMessage: "El email es requerido")
        }
        
        // Check length constraints
        guard sanitizedEmail.count >= 5 else {
            return ValidationResult(isValid: false, errorMessage: "El email es demasiado corto")
        }
        
        guard sanitizedEmail.count <= 254 else {
            return ValidationResult(isValid: false, errorMessage: "El email es demasiado largo")
        }
        
        // Comprehensive email regex pattern
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        guard emailPredicate.evaluate(with: sanitizedEmail) else {
            return ValidationResult(isValid: false, errorMessage: "Formato de email inválido")
        }
        
        // Additional security checks
        if sanitizedEmail.contains("..") || sanitizedEmail.hasPrefix(".") || sanitizedEmail.hasSuffix(".") {
            return ValidationResult(isValid: false, errorMessage: "Formato de email inválido")
        }
        
        return ValidationResult(isValid: true, errorMessage: nil)
    }
    
    // MARK: - Password Validation
    
    /// Validate password strength with comprehensive requirements
    /// - Parameter password: Password string to validate
    /// - Returns: ValidationResult with success/failure and error message
    func isValidPassword(_ password: String) -> ValidationResult {
        // Don't sanitize passwords as it might affect legitimate characters
        guard !password.isEmpty else {
            return ValidationResult(isValid: false, errorMessage: "La contraseña es requerida")
        }
        
        guard password.count >= 8 else {
            return ValidationResult(isValid: false, errorMessage: "La contraseña debe tener al menos 8 caracteres")
        }
        
        guard password.count <= 128 else {
            return ValidationResult(isValid: false, errorMessage: "La contraseña es demasiado larga")
        }
        
        // Check for uppercase letter
        let uppercaseRegex = ".*[A-Z]+.*"
        let hasUppercase = NSPredicate(format: "SELF MATCHES %@", uppercaseRegex).evaluate(with: password)
        
        guard hasUppercase else {
            return ValidationResult(isValid: false, errorMessage: "La contraseña debe contener al menos una letra mayúscula")
        }
        
        // Check for number
        let numberRegex = ".*[0-9]+.*"
        let hasNumber = NSPredicate(format: "SELF MATCHES %@", numberRegex).evaluate(with: password)
        
        guard hasNumber else {
            return ValidationResult(isValid: false, errorMessage: "La contraseña debe contener al menos un número")
        }
        
        // Check for lowercase letter
        let lowercaseRegex = ".*[a-z]+.*"
        let hasLowercase = NSPredicate(format: "SELF MATCHES %@", lowercaseRegex).evaluate(with: password)
        
        guard hasLowercase else {
            return ValidationResult(isValid: false, errorMessage: "La contraseña debe contener al menos una letra minúscula")
        }
        
        // Check for common weak passwords
        let weakPasswords = ["12345678", "password", "password1", "123456789", "qwerty123", "abc123456"]
        if weakPasswords.contains(password.lowercased()) {
            return ValidationResult(isValid: false, errorMessage: "Esta contraseña es demasiado común. Usa una más segura")
        }
        
        return ValidationResult(isValid: true, errorMessage: nil)
    }
    
    // MARK: - Name Validation
    
    /// Validate user names (full names, display names, etc.)
    /// - Parameter name: Name string to validate
    /// - Returns: ValidationResult with success/failure and error message
    func isValidName(_ name: String) -> ValidationResult {
        let sanitizedName = sanitizeInput(name)
        
        guard !sanitizedName.isEmpty else {
            return ValidationResult(isValid: false, errorMessage: "El nombre es requerido")
        }
        
        guard sanitizedName.count >= 2 else {
            return ValidationResult(isValid: false, errorMessage: "El nombre debe tener al menos 2 caracteres")
        }
        
        guard sanitizedName.count <= 50 else {
            return ValidationResult(isValid: false, errorMessage: "El nombre es demasiado largo")
        }
        
        // Check for valid name characters (letters, spaces, hyphens, apostrophes)
        let nameRegex = "^[a-zA-ZÀ-ÿ\\u0100-\\u017F\\s\\-']+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        
        guard namePredicate.evaluate(with: sanitizedName) else {
            return ValidationResult(isValid: false, errorMessage: "El nombre contiene caracteres no válidos")
        }
        
        // Check for consecutive spaces or hyphens
        if sanitizedName.contains("  ") || sanitizedName.contains("--") || sanitizedName.contains("''") {
            return ValidationResult(isValid: false, errorMessage: "Formato de nombre inválido")
        }
        
        return ValidationResult(isValid: true, errorMessage: nil)
    }
    
    // MARK: - Workout Duration Validation
    
    /// Validate workout duration in minutes
    /// - Parameter duration: Duration value to validate
    /// - Returns: ValidationResult with success/failure and error message
    func isValidDuration(_ duration: String) -> ValidationResult {
        let sanitizedDuration = sanitizeInput(duration)
        
        guard !sanitizedDuration.isEmpty else {
            return ValidationResult(isValid: false, errorMessage: "La duración es requerida")
        }
        
        // Check if it's a valid number
        guard let durationInt = Int(sanitizedDuration) else {
            return ValidationResult(isValid: false, errorMessage: "La duración debe ser un número válido")
        }
        
        guard durationInt >= 1 else {
            return ValidationResult(isValid: false, errorMessage: "La duración mínima es de 1 minuto")
        }
        
        guard durationInt <= 600 else {
            return ValidationResult(isValid: false, errorMessage: "La duración máxima es de 600 minutos (10 horas)")
        }
        
        return ValidationResult(isValid: true, errorMessage: nil)
    }
    
    /// Validate workout duration as integer
    /// - Parameter duration: Duration integer to validate
    /// - Returns: ValidationResult with success/failure and error message
    func isValidDuration(_ duration: Int) -> ValidationResult {
        guard duration >= 1 else {
            return ValidationResult(isValid: false, errorMessage: "La duración mínima es de 1 minuto")
        }
        
        guard duration <= 600 else {
            return ValidationResult(isValid: false, errorMessage: "La duración máxima es de 600 minutos (10 horas)")
        }
        
        return ValidationResult(isValid: true, errorMessage: nil)
    }
    
    // MARK: - Workout Type Validation
    
    /// Validate workout type names
    /// - Parameter workoutType: Workout type string to validate
    /// - Returns: ValidationResult with success/failure and error message
    func isValidWorkoutType(_ workoutType: String) -> ValidationResult {
        let sanitizedType = sanitizeInput(workoutType)
        
        guard !sanitizedType.isEmpty else {
            return ValidationResult(isValid: false, errorMessage: "El tipo de entrenamiento es requerido")
        }
        
        guard sanitizedType.count >= 2 else {
            return ValidationResult(isValid: false, errorMessage: "El tipo de entrenamiento debe tener al menos 2 caracteres")
        }
        
        guard sanitizedType.count <= 30 else {
            return ValidationResult(isValid: false, errorMessage: "El tipo de entrenamiento es demasiado largo")
        }
        
        // Allow letters, numbers, spaces, and some special characters for workout names
        let typeRegex = "^[a-zA-ZÀ-ÿ\\u0100-\\u017F0-9\\s\\-&]+$"
        let typePredicate = NSPredicate(format: "SELF MATCHES %@", typeRegex)
        
        guard typePredicate.evaluate(with: sanitizedType) else {
            return ValidationResult(isValid: false, errorMessage: "El tipo de entrenamiento contiene caracteres no válidos")
        }
        
        return ValidationResult(isValid: true, errorMessage: nil)
    }
    
    // MARK: - Calories Validation
    
    /// Validate calories burned in workout
    /// - Parameter calories: Calories value to validate
    /// - Returns: ValidationResult with success/failure and error message
    func isValidCalories(_ calories: String) -> ValidationResult {
        let sanitizedCalories = sanitizeInput(calories)
        
        guard !sanitizedCalories.isEmpty else {
            return ValidationResult(isValid: false, errorMessage: "Las calorías son requeridas")
        }
        
        guard let caloriesInt = Int(sanitizedCalories) else {
            return ValidationResult(isValid: false, errorMessage: "Las calorías deben ser un número válido")
        }
        
        guard caloriesInt >= 1 else {
            return ValidationResult(isValid: false, errorMessage: "Las calorías mínimas son 1")
        }
        
        guard caloriesInt <= 5000 else {
            return ValidationResult(isValid: false, errorMessage: "Las calorías máximas son 5000")
        }
        
        return ValidationResult(isValid: true, errorMessage: nil)
    }
    
    /// Validate calories as integer
    /// - Parameter calories: Calories integer to validate
    /// - Returns: ValidationResult with success/failure and error message
    func isValidCalories(_ calories: Int) -> ValidationResult {
        guard calories >= 1 else {
            return ValidationResult(isValid: false, errorMessage: "Las calorías mínimas son 1")
        }
        
        guard calories <= 5000 else {
            return ValidationResult(isValid: false, errorMessage: "Las calorías máximas son 5000")
        }
        
        return ValidationResult(isValid: true, errorMessage: nil)
    }
    
    // MARK: - General Text Validation
    
    /// Validate general text inputs (notes, descriptions, etc.)
    /// - Parameters:
    ///   - text: Text to validate
    ///   - minLength: Minimum required length
    ///   - maxLength: Maximum allowed length
    ///   - allowEmpty: Whether empty text is allowed
    /// - Returns: ValidationResult with success/failure and error message
    func isValidText(_ text: String, minLength: Int = 0, maxLength: Int = 500, allowEmpty: Bool = true) -> ValidationResult {
        let sanitizedText = sanitizeInput(text)
        
        if !allowEmpty && sanitizedText.isEmpty {
            return ValidationResult(isValid: false, errorMessage: "Este campo es requerido")
        }
        
        if !sanitizedText.isEmpty && sanitizedText.count < minLength {
            return ValidationResult(isValid: false, errorMessage: "El texto debe tener al menos \(minLength) caracteres")
        }
        
        if sanitizedText.count > maxLength {
            return ValidationResult(isValid: false, errorMessage: "El texto no puede exceder \(maxLength) caracteres")
        }
        
        return ValidationResult(isValid: true, errorMessage: nil)
    }
    
    // MARK: - Comprehensive Form Validation
    
    /// Validate complete login form
    /// - Parameters:
    ///   - email: Email input
    ///   - password: Password input
    /// - Returns: FormValidationResult with all validation results
    func validateLoginForm(email: String, password: String) -> FormValidationResult {
        let emailResult = isValidEmail(email)
        let passwordResult = isValidPassword(password)
        
        let isValid = emailResult.isValid && passwordResult.isValid
        
        return FormValidationResult(
            isValid: isValid,
            emailError: emailResult.errorMessage,
            passwordError: passwordResult.errorMessage
        )
    }
    
    /// Validate complete registration form
    /// - Parameters:
    ///   - email: Email input
    ///   - password: Password input
    ///   - confirmPassword: Password confirmation input
    ///   - fullName: Full name input (optional)
    /// - Returns: RegistrationValidationResult with all validation results
    func validateRegistrationForm(email: String, password: String, confirmPassword: String, fullName: String? = nil) -> RegistrationValidationResult {
        let emailResult = isValidEmail(email)
        let passwordResult = isValidPassword(password)
        
        // Password confirmation validation
        var confirmPasswordError: String? = nil
        if password != confirmPassword {
            confirmPasswordError = "Las contraseñas no coinciden"
        }
        
        // Full name validation (if provided)
        var fullNameError: String? = nil
        if let name = fullName, !name.isEmpty {
            let nameResult = isValidName(name)
            fullNameError = nameResult.errorMessage
        }
        
        let isValid = emailResult.isValid && 
                     passwordResult.isValid && 
                     confirmPasswordError == nil && 
                     fullNameError == nil
        
        return RegistrationValidationResult(
            isValid: isValid,
            emailError: emailResult.errorMessage,
            passwordError: passwordResult.errorMessage,
            confirmPasswordError: confirmPasswordError,
            fullNameError: fullNameError
        )
    }
    
    /// Validate workout form
    /// - Parameters:
    ///   - type: Workout type
    ///   - duration: Duration in minutes
    ///   - calories: Calories burned
    /// - Returns: WorkoutValidationResult with all validation results
    func validateWorkoutForm(type: String, duration: String, calories: String) -> WorkoutValidationResult {
        let typeResult = isValidWorkoutType(type)
        let durationResult = isValidDuration(duration)
        let caloriesResult = isValidCalories(calories)
        
        let isValid = typeResult.isValid && durationResult.isValid && caloriesResult.isValid
        
        return WorkoutValidationResult(
            isValid: isValid,
            typeError: typeResult.errorMessage,
            durationError: durationResult.errorMessage,
            caloriesError: caloriesResult.errorMessage
        )
    }
}

// MARK: - Validation Result Types

/// Basic validation result structure
struct ValidationResult {
    let isValid: Bool
    let errorMessage: String?
}

/// Form validation result for login
struct FormValidationResult {
    let isValid: Bool
    let emailError: String?
    let passwordError: String?
}

/// Form validation result for registration
struct RegistrationValidationResult {
    let isValid: Bool
    let emailError: String?
    let passwordError: String?
    let confirmPasswordError: String?
    let fullNameError: String?
}

/// Form validation result for workout
struct WorkoutValidationResult {
    let isValid: Bool
    let typeError: String?
    let durationError: String?
    let caloriesError: String?
}
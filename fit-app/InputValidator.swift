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
        var sanitized = trimmed
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
        
        // Remove dangerous SQL injection patterns
        let sqlPatterns = ["DROP", "DELETE", "INSERT", "UPDATE", "SELECT", "UNION", "EXEC", "SCRIPT", "ALERT", "PROMPT"]
        for pattern in sqlPatterns {
            sanitized = sanitized.replacingOccurrences(of: pattern, with: "", options: .caseInsensitive)
        }
        
        // Remove suspicious URL patterns and protocols
        let urlPatterns = ["javascript:", "data:", "vbscript:", "file:", "http://", "https://", "ftp://"]
        for pattern in urlPatterns {
            sanitized = sanitized.replacingOccurrences(of: pattern, with: "", options: .caseInsensitive)
        }
        
        // Remove null bytes and control characters
        sanitized = sanitized.replacingOccurrences(of: "\\0", with: "")
        sanitized = sanitized.components(separatedBy: .controlCharacters).joined()
        
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
        
        // More strict and realistic email regex pattern
        // This pattern validates:
        // - Local part: 1-64 characters, alphanumeric, dots, hyphens, underscores
        // - No consecutive dots, no dots at start/end of local part
        // - Domain: valid domain format with proper TLD (2-6 characters)
        let emailRegex = "^[a-zA-Z0-9]([a-zA-Z0-9._-]*[a-zA-Z0-9])?@[a-zA-Z0-9]([a-zA-Z0-9.-]*[a-zA-Z0-9])?\\.[a-zA-Z]{2,6}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        guard emailPredicate.evaluate(with: sanitizedEmail) else {
            return ValidationResult(isValid: false, errorMessage: "Formato de email inválido")
        }
        
        // Additional strict security checks
        if sanitizedEmail.contains("..") || 
           sanitizedEmail.hasPrefix(".") || 
           sanitizedEmail.hasSuffix(".") ||
           sanitizedEmail.contains("@.") ||
           sanitizedEmail.contains(".@") {
            return ValidationResult(isValid: false, errorMessage: "Formato de email inválido")
        }
        
        // Check for suspicious domains and patterns
        let suspiciousDomains = ["test.com", "example.com", "localhost", "temp-mail", "10minutemail", "guerrillamail"]
        let domain = String(sanitizedEmail.split(separator: "@").last ?? "")
        
        if suspiciousDomains.contains(where: domain.lowercased().contains) {
            return ValidationResult(isValid: false, errorMessage: "Dominio de email no válido")
        }
        
        // Check local part length (before @)
        let localPart = String(sanitizedEmail.split(separator: "@").first ?? "")
        guard localPart.count >= 1 && localPart.count <= 64 else {
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
        
        // Check for special characters (more secure passwords)
        let specialCharRegex = ".*[!@#$%^&*(),.?\":{}|<>\\-_+=\\[\\]\\\\;'~/`]+.*"
        let hasSpecialChar = NSPredicate(format: "SELF MATCHES %@", specialCharRegex).evaluate(with: password)
        
        if !hasSpecialChar {
            return ValidationResult(isValid: false, errorMessage: "La contraseña debe contener al menos un carácter especial (!@#$%^&*)")
        }
        
        // Check for sequential characters (123, abc, etc.)
        let sequentialPatterns = ["123", "234", "345", "456", "567", "678", "789", "abc", "bcd", "cde", "def", "efg", "fgh", "ghi"]
        for pattern in sequentialPatterns {
            if password.lowercased().contains(pattern) || password.lowercased().contains(String(pattern.reversed())) {
                return ValidationResult(isValid: false, errorMessage: "La contraseña no puede contener secuencias obvias")
            }
        }
        
        // Check for repeated characters (aaa, 111, etc.)
        let repeatedPattern = ".*([a-zA-Z0-9])\\1{2,}.*"
        if NSPredicate(format: "SELF MATCHES %@", repeatedPattern).evaluate(with: password) {
            return ValidationResult(isValid: false, errorMessage: "La contraseña no puede tener más de 2 caracteres iguales consecutivos")
        }
        
        // Expanded list of common weak passwords
        let weakPasswords = [
            "12345678", "password", "password1", "123456789", "qwerty123", "abc123456",
            "password123", "admin123", "letmein", "welcome", "monkey", "dragon",
            "qwerty", "123123", "111111", "654321", "superman", "iloveyou",
            "trustno1", "sunshine", "master", "123qwe", "welcome123", "admin",
            "qwerty12", "password12", "123abc", "test123", "user123", "pass123"
        ]
        
        if weakPasswords.contains(password.lowercased()) {
            return ValidationResult(isValid: false, errorMessage: "Esta contraseña es demasiado común. Usa una más segura")
        }
        
        // Check for personal information patterns (common names, dates)
        let personalPatterns = ["antonio", "maria", "juan", "ana", "carlos", "luis", "jose", "2023", "2024", "2025"]
        for pattern in personalPatterns {
            if password.lowercased().contains(pattern) {
                return ValidationResult(isValid: false, errorMessage: "La contraseña no debe contener información personal obvia")
            }
        }
        
        return ValidationResult(isValid: true, errorMessage: nil)
    }
    
    /// Enhanced password validation with suggestions
    /// - Parameter password: Password string to validate
    /// - Returns: EnhancedValidationResult with suggestions for improvement
    func validatePasswordWithSuggestions(_ password: String) -> EnhancedValidationResult {
        var suggestions: [String] = []
        var severity: EnhancedValidationResult.ValidationSeverity = .error
        
        // Don't sanitize passwords as it might affect legitimate characters
        guard !password.isEmpty else {
            return EnhancedValidationResult.failure("La contraseña es requerida", severity: .error)
        }
        
        // Check minimum length
        if password.count < 8 {
            suggestions.append("Agrega más caracteres (mínimo 8)")
            return EnhancedValidationResult.failure("La contraseña debe tener al menos 8 caracteres", severity: .error, suggestions: suggestions)
        }
        
        // Check maximum length
        if password.count > 128 {
            return EnhancedValidationResult.failure("La contraseña es demasiado larga", severity: .error)
        }
        
        // Check for character type requirements
        let hasUppercase = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password)
        let hasLowercase = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password)
        let hasNumber = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)
        let hasSpecialChar = NSPredicate(format: "SELF MATCHES %@", ".*[!@#$%^&*(),.?\":{}|<>\\-_+=\\[\\]\\\\;'~/`]+.*").evaluate(with: password)
        
        if !hasUppercase {
            suggestions.append("Agrega al menos una letra mayúscula")
        }
        if !hasLowercase {
            suggestions.append("Agrega al menos una letra minúscula")
        }
        if !hasNumber {
            suggestions.append("Agrega al menos un número")
        }
        if !hasSpecialChar {
            suggestions.append("Agrega al menos un carácter especial (!@#$%^&*)")
        }
        
        // Return early if basic requirements not met
        if !hasUppercase || !hasLowercase || !hasNumber || !hasSpecialChar {
            let missingRequirements = suggestions.joined(separator: ", ")
            return EnhancedValidationResult.failure("Faltan requisitos: \(missingRequirements)", severity: .error, suggestions: suggestions)
        }
        
        // Advanced security checks
        var warnings: [String] = []
        
        // Check for sequential characters
        let sequentialPatterns = ["123", "234", "345", "456", "567", "678", "789", "abc", "bcd", "cde", "def", "efg", "fgh", "ghi"]
        for pattern in sequentialPatterns {
            if password.lowercased().contains(pattern) || password.lowercased().contains(String(pattern.reversed())) {
                warnings.append("Evita secuencias obvias como '123' o 'abc'")
                severity = .warning
                break
            }
        }
        
        // Check for repeated characters
        if NSPredicate(format: "SELF MATCHES %@", ".*([a-zA-Z0-9])\\1{2,}.*").evaluate(with: password) {
            warnings.append("Evita repetir el mismo carácter más de 2 veces")
            severity = .warning
        }
        
        // Check for common weak patterns
        let weakPasswords = [
            "12345678", "password", "password1", "123456789", "qwerty123", "abc123456",
            "password123", "admin123", "letmein", "welcome", "monkey", "dragon"
        ]
        
        if weakPasswords.contains(password.lowercased()) {
            return EnhancedValidationResult.failure("Esta contraseña es demasiado común", severity: .critical, suggestions: ["Usa una combinación única de caracteres"])
        }
        
        // Check for personal information
        let personalPatterns = ["antonio", "maria", "juan", "ana", "carlos", "luis", "jose", "2023", "2024", "2025"]
        for pattern in personalPatterns {
            if password.lowercased().contains(pattern) {
                warnings.append("Evita usar información personal en tu contraseña")
                severity = .warning
                break
            }
        }
        
        // Strong password achieved
        if warnings.isEmpty {
            return EnhancedValidationResult.success()
        } else {
            // Password is valid but has warnings
            return EnhancedValidationResult(isValid: true, errorMessage: warnings.first, severity: severity, suggestions: warnings)
        }
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
    
    /// Create a successful validation result
    static func success() -> ValidationResult {
        return ValidationResult(isValid: true, errorMessage: nil)
    }
    
    /// Create a failed validation result with error message
    static func failure(_ message: String) -> ValidationResult {
        return ValidationResult(isValid: false, errorMessage: message)
    }
}

/// Enhanced validation result with severity levels
struct EnhancedValidationResult {
    let isValid: Bool
    let errorMessage: String?
    let severity: ValidationSeverity
    let suggestions: [String]
    
    enum ValidationSeverity {
        case info       // Informational message
        case warning    // Warning that doesn't prevent submission
        case error      // Critical error that prevents submission
        case critical   // Security-related critical error
    }
    
    static func success() -> EnhancedValidationResult {
        return EnhancedValidationResult(isValid: true, errorMessage: nil, severity: .info, suggestions: [])
    }
    
    static func failure(_ message: String, severity: ValidationSeverity = .error, suggestions: [String] = []) -> EnhancedValidationResult {
        return EnhancedValidationResult(isValid: false, errorMessage: message, severity: severity, suggestions: suggestions)
    }
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

// MARK: - Validation UI Components
extension InputValidator {
    /// Create a standardized validation error view
    /// - Parameters:
    ///   - errorMessage: The error message to display
    ///   - severity: The severity level of the error
    /// - Returns: A SwiftUI view for displaying the error
    static func createErrorView(errorMessage: String, severity: EnhancedValidationResult.ValidationSeverity = .error) -> some View {
        HStack(spacing: 8) {
            Image(systemName: severity.iconName)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(severity.color)
            
            Text(errorMessage)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(severity.color)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(severity.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(severity.color.opacity(0.3), lineWidth: 1)
                )
        )
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
}

extension EnhancedValidationResult.ValidationSeverity {
    var iconName: String {
        switch self {
        case .info: return "info.circle"
        case .warning: return "exclamationmark.triangle"
        case .error: return "xmark.circle"
        case .critical: return "exclamationmark.triangle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .info: return .blue
        case .warning: return .orange
        case .error: return .red
        case .critical: return .red
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .info: return .blue.opacity(0.1)
        case .warning: return .orange.opacity(0.1)
        case .error: return .red.opacity(0.1)
        case .critical: return .red.opacity(0.15)
        }
    }
}

// MARK: - Testing and Validation Verification
extension InputValidator {
    
    /// Comprehensive testing of all validation functions
    /// - Returns: True if all tests pass, false otherwise
    func runValidationTests() -> Bool {
        #if DEBUG
        print("🧪 Running comprehensive validation tests...")
        #endif
        
        var testsPassedCount = 0
        var totalTests = 0
        
        // Test email validation
        let emailTests = [
            ("test@example.com", true),
            ("invalid.email", false),
            ("user@domain.co", true),
            ("", false),
            ("test@.com", false),
            ("test@domain.", false),
            ("test@@domain.com", false),
            ("test@test.com", false), // Should fail due to suspicious domain
        ]
        
        #if DEBUG
        print("📧 Testing email validation...")
        #endif
        for (email, shouldPass) in emailTests {
            totalTests += 1
            let result = isValidEmail(email)
            if result.isValid == shouldPass {
                testsPassedCount += 1
                #if DEBUG
                print("✅ Email test passed: '\(email)' -> \(result.isValid)")
                #endif
            } else {
                #if DEBUG
                print("❌ Email test failed: '\(email)' expected \(shouldPass), got \(result.isValid)")
                #endif
            }
        }
        
        // Test password validation
        let passwordTests = [
            ("MyPassw0rd!", true),
            ("weak", false),
            ("NoNumbers!", false),
            ("nonumbersupper!", false),
            ("NOLOWERCASE123!", false),
            ("NoSpecialChars123", false),
            ("password123", false), // Common password
            ("MyStr0ng#Pass", true),
        ]
        
        #if DEBUG
        print("🔒 Testing password validation...")
        #endif
        for (password, shouldPass) in passwordTests {
            totalTests += 1
            let result = isValidPassword(password)
            if result.isValid == shouldPass {
                testsPassedCount += 1
                #if DEBUG
                print("✅ Password test passed: '\(password.prefix(3))***' -> \(result.isValid)")
                #endif
            } else {
                #if DEBUG
                print("❌ Password test failed: '\(password.prefix(3))***' expected \(shouldPass), got \(result.isValid)")
                #endif
            }
        }
        
        // Test input sanitization
        let sanitizationTests = [
            ("<script>alert('xss')</script>", "scriptalert'xss'script"),
            ("Normal text", "Normal text"),
            ("Text with <tags>", "Text with tags"),
            ("Multiple    spaces", "Multiple spaces"),
            ("  Leading and trailing  ", "Leading and trailing"),
        ]
        
        #if DEBUG
        print("🧽 Testing input sanitization...")
        #endif
        for (input, expected) in sanitizationTests {
            totalTests += 1
            let result = sanitizeInput(input)
            if result == expected {
                testsPassedCount += 1
                #if DEBUG
                print("✅ Sanitization test passed: '\(input)' -> '\(result)'")
                #endif
            } else {
                #if DEBUG
                print("❌ Sanitization test failed: '\(input)' expected '\(expected)', got '\(result)'")
                #endif
            }
        }
        
        // Test name validation
        let nameTests = [
            ("Juan Carlos", true),
            ("María José", true),
            ("", false),
            ("A", false), // Too short
            ("John123", false), // Numbers not allowed
            ("José-María", true),
            ("VeryLongNameThatExceedsTheMaximumAllowedCharacterLimit", false),
        ]
        
        #if DEBUG
        print("👤 Testing name validation...")
        #endif
        for (name, shouldPass) in nameTests {
            totalTests += 1
            let result = isValidName(name)
            if result.isValid == shouldPass {
                testsPassedCount += 1
                #if DEBUG
                print("✅ Name test passed: '\(name)' -> \(result.isValid)")
                #endif
            } else {
                #if DEBUG
                print("❌ Name test failed: '\(name)' expected \(shouldPass), got \(result.isValid)")
                #endif
            }
        }
        
        // Summary
        let successRate = Double(testsPassedCount) / Double(totalTests) * 100
        #if DEBUG
        print("\n📊 Validation Test Summary:")
        print("✅ Tests passed: \(testsPassedCount)/\(totalTests)")
        print("📈 Success rate: \(String(format: "%.1f", successRate))%")
        #endif
        
        let allTestsPassed = testsPassedCount == totalTests
        if allTestsPassed {
            #if DEBUG
            print("🎉 All validation tests passed!")
            #endif
        } else {
            #if DEBUG
            print("⚠️ Some validation tests failed. Please review implementation.")
            #endif
        }
        
        return allTestsPassed
    }
    
    /// Quick validation test for debugging
    /// - Returns: True if basic validations work
    func quickValidationTest() -> Bool {
        let emailTest = isValidEmail("test@valid.com").isValid
        let passwordTest = isValidPassword("MyStr0ng#Pass").isValid
        let nameTest = isValidName("Juan Carlos").isValid
        
        #if DEBUG
        print("🔍 Quick validation test: Email=\(emailTest), Password=\(passwordTest), Name=\(nameTest)")
        #endif
        return emailTest && passwordTest && nameTest
    }
}
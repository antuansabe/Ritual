import Foundation
import SwiftUI

// MARK: - App Configuration
struct AppConstants {
    
    // MARK: - Workout Configuration
    struct Workout {
        static let minDuration = 1
        static let maxDuration = 480 // 8 hours
        static let caloriesPerMinute = 8
        static let maxWorkoutsPerDay = 10
    }
    
    // MARK: - UI Constants
    struct UI {
        // Spacing System
        static let spacingXS: CGFloat = 4
        static let spacingS: CGFloat = 8
        static let spacingM: CGFloat = 12
        static let spacingL: CGFloat = 16
        static let spacingXL: CGFloat = 24
        static let spacingXXL: CGFloat = 32
        
        // Corner Radius
        static let cornerRadiusS: CGFloat = 8
        static let cornerRadiusM: CGFloat = 12
        static let cornerRadiusL: CGFloat = 16
        static let cornerRadiusXL: CGFloat = 20
        
        // Touch Targets
        static let minTouchTarget: CGFloat = 44
        static let fabSize: CGFloat = 56
        
        // Card Sizes
        static let metricCardWidth: CGFloat = 120
        static let metricCardHeight: CGFloat = 100
        static let activityButtonHeight: CGFloat = 80
        
        // Shadow
        static let shadowRadius: CGFloat = 4
        static let shadowOpacity: Double = 0.1
        
        // Border
        static let borderWidth: CGFloat = 1
        static let borderOpacity: Double = 0.1
    }
    
    // MARK: - Design System
    struct Design {
        // Main Colors
        static let primaryGradient = LinearGradient(
            colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let backgroundGradient = LinearGradient(
            colors: [Color.black, Color(.systemGray6).opacity(0.1)],
            startPoint: .top,
            endPoint: .bottom
        )
        
        static let cardGradient = LinearGradient(
            colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Accent Colors
        static let blue = Color.blue
        static let purple = Color.purple
        static let green = Color.green
        static let orange = Color.orange
        static let red = Color.red
        static let yellow = Color.yellow
        
        // Typography
        static let titleFont = Font.system(size: 28, weight: .bold, design: .rounded)
        static let headerFont = Font.system(size: 22, weight: .bold, design: .rounded)
        static let subheaderFont = Font.system(size: 18, weight: .semibold, design: .rounded)
        static let bodyFont = Font.system(size: 16, weight: .medium, design: .default)
        static let captionFont = Font.system(size: 14, weight: .medium, design: .default)
        static let footnoteFont = Font.system(size: 12, weight: .medium, design: .default)
        
        // Card Styles
        static func cardBackground(_ isHighlighted: Bool = false) -> some ShapeStyle {
            Color.white.opacity(isHighlighted ? 0.1 : 0.05)
        }
        
        static func cardBorder(_ color: Color = .white) -> some ShapeStyle {
            color.opacity(0.1)
        }
        
        static func cardShadow() -> Color {
            Color.black.opacity(0.1)
        }
        
        // Button Styles
        static let primaryButtonGradient = LinearGradient(
            colors: [Color.blue, Color.purple],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        static let secondaryButtonBackground = Color.white.opacity(0.1)
    }
    
    // MARK: - Animation
    struct Animation {
        static let quick: Double = 0.2
        static let standard: Double = 0.3
        static let slow: Double = 0.6
        static let entrance: Double = 0.8
    }
    
    // MARK: - Default User
    struct User {
        static let defaultName = "Usuario"
        static let greeting = "Hola"
        static let welcomeEmoji = "👋"
    }
}

// MARK: - App Errors
enum AppError: LocalizedError {
    case invalidDuration
    case durationTooShort
    case durationTooLong
    case saveFailed
    case loadFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidDuration:
            return "Duración inválida. Ingresa un número válido."
        case .durationTooShort:
            return "La duración mínima es \(AppConstants.Workout.minDuration) minuto."
        case .durationTooLong:
            return "La duración máxima es \(AppConstants.Workout.maxDuration) minutos."
        case .saveFailed:
            return "Error al guardar el entrenamiento. Inténtalo de nuevo."
        case .loadFailed:
            return "Error al cargar los datos."
        }
    }
}

// MARK: - Validation Helpers
extension AppConstants {
    static func validateWorkoutDuration(_ duration: String) -> Result<Int, AppError> {
        let trimmed = duration.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let durationInt = Int(trimmed) else {
            return .failure(.invalidDuration)
        }
        
        guard durationInt >= Workout.minDuration else {
            return .failure(.durationTooShort)
        }
        
        guard durationInt <= Workout.maxDuration else {
            return .failure(.durationTooLong)
        }
        
        return .success(durationInt)
    }
    
    static func calculateCalories(for duration: Int) -> Int {
        return duration * Workout.caloriesPerMinute
    }
}
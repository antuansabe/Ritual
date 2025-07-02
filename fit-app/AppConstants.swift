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
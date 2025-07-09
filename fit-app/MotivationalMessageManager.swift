import Foundation
import SwiftUI

// MARK: - Motivational Message Model
struct MotivationalMessage {
    let text: String
    let emoji: String
    let context: MessageContext
    
    enum MessageContext {
        case profile
        case historyEmpty
        case workoutStart
        case longBreak
        case streak
        case general
    }
}

// MARK: - Motivational Message Manager
class MotivationalMessageManager: ObservableObject {
    
    // MARK: - Message Collections
    private let profileMessages = [
        MotivationalMessage(text: "Hoy puedes darte un regalo de movimiento", emoji: "[U+1F9D8]‍♂️", context: .profile),
        MotivationalMessage(text: "Tu bienestar merece estos momentos", emoji: "[U+1F49A]", context: .profile),
        MotivationalMessage(text: "Cada día es una nueva oportunidad", emoji: "[U+1F305]", context: .profile),
        MotivationalMessage(text: "Tu cuerpo te agradece este cuidado", emoji: "✨", context: .profile),
        MotivationalMessage(text: "Pequeños pasos, grandes cambios", emoji: "[U+1F463]", context: .profile)
    ]
    
    private let historyEmptyMessages = [
        MotivationalMessage(text: "Tu primer entrenamiento te está esperando", emoji: "[U+1F331]", context: .historyEmpty),
        MotivationalMessage(text: "Cada gran viaje comienza con un paso", emoji: "[U+1F680]", context: .historyEmpty),
        MotivationalMessage(text: "Hoy puede ser el día perfecto para empezar", emoji: "[U+1F31F]", context: .historyEmpty),
        MotivationalMessage(text: "Tu historia fitness está por comenzar", emoji: "[U+1F4D6]", context: .historyEmpty)
    ]
    
    private let workoutStartMessages = [
        MotivationalMessage(text: "¿Qué tipo de energía quieres crear hoy?", emoji: "⚡", context: .workoutStart),
        MotivationalMessage(text: "Tu cuerpo está listo para este momento", emoji: "[U+1F4AA]", context: .workoutStart),
        MotivationalMessage(text: "Conecta con tu fuerza interior", emoji: "[U+1F525]", context: .workoutStart),
        MotivationalMessage(text: "Este momento es tuyo", emoji: "[U+1F3AF]", context: .workoutStart)
    ]
    
    private let longBreakMessages = [
        MotivationalMessage(text: "Todo bien, puedes volver a empezar", emoji: "[U+1F331]", context: .longBreak),
        MotivationalMessage(text: "El descanso también es parte del proceso", emoji: "[U+1F33F]", context: .longBreak),
        MotivationalMessage(text: "Si descansaste, hoy puedes regresar con calma", emoji: "[U+1F54A]️", context: .longBreak),
        MotivationalMessage(text: "Cada regreso es una nueva oportunidad", emoji: "[U+1F308]", context: .longBreak)
    ]
    
    private let streakMessages = [
        MotivationalMessage(text: "¡Tu constancia inspira!", emoji: "[U+1F525]", context: .streak),
        MotivationalMessage(text: "Mira lo lejos que has llegado", emoji: "⭐", context: .streak),
        MotivationalMessage(text: "Tu disciplina está dando frutos", emoji: "[U+1F338]", context: .streak),
        MotivationalMessage(text: "Eres más fuerte de lo que crees", emoji: "[U+1F48E]", context: .streak)
    ]
    
    // MARK: - Public Methods
    func getMessage(for context: MotivationalMessage.MessageContext, daysSinceLastWorkout: Int = 0, currentStreak: Int = 0) -> MotivationalMessage {
        
        // Lógica adaptativa basada en patrones de entrenamiento
        if daysSinceLastWorkout > 3 {
            return longBreakMessages.randomElement() ?? getDefaultMessage(for: context)
        }
        
        if currentStreak >= 3 {
            return streakMessages.randomElement() ?? getDefaultMessage(for: context)
        }
        
        return getDefaultMessage(for: context)
    }
    
    private func getDefaultMessage(for context: MotivationalMessage.MessageContext) -> MotivationalMessage {
        switch context {
        case .profile:
            return profileMessages.randomElement() ?? MotivationalMessage(text: "Hoy es tu día", emoji: "✨", context: .profile)
        case .historyEmpty:
            return historyEmptyMessages.randomElement() ?? MotivationalMessage(text: "Tu primer paso te espera", emoji: "[U+1F331]", context: .historyEmpty)
        case .workoutStart:
            return workoutStartMessages.randomElement() ?? MotivationalMessage(text: "¡A por ello!", emoji: "[U+1F4AA]", context: .workoutStart)
        case .longBreak:
            return longBreakMessages.randomElement() ?? MotivationalMessage(text: "Vuelve cuando estés listo", emoji: "[U+1F33F]", context: .longBreak)
        case .streak:
            return streakMessages.randomElement() ?? MotivationalMessage(text: "¡Increíble progreso!", emoji: "[U+1F525]", context: .streak)
        case .general:
            return MotivationalMessage(text: "Cada momento cuenta", emoji: "⭐", context: .general)
        }
    }
    
    // MARK: - Workout Analysis Methods
    func calculateDaysSinceLastWorkout(workouts: [WorkoutEntity]) -> Int {
        guard let lastWorkout = workouts.first else { return Int.max }
        
        let calendar = Calendar.current
        let today = Date()
        let lastWorkoutDate = lastWorkout.date ?? today
        
        return calendar.dateComponents([.day], from: lastWorkoutDate, to: today).day ?? 0
    }
    
    func calculateCurrentStreak(workouts: [WorkoutEntity]) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var streak = 0
        var checkDate = today
        
        for _ in 0..<30 { // Check last 30 days maximum
            let workoutsOnDate = workouts.filter { workout in
                guard let workoutDate = workout.date else { return false }
                return calendar.isDate(workoutDate, inSameDayAs: checkDate)
            }
            
            if workoutsOnDate.isEmpty {
                break
            } else {
                streak += 1
            }
            
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
        }
        
        return streak
    }
}
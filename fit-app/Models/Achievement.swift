import Foundation

struct Achievement: Identifiable, Codable {
    enum Kind: String, Codable, CaseIterable {
        case firstWorkout
        case fiveWorkouts
        case tenWorkouts
        case weeklyStreak
        
        var title: String {
            switch self {
            case .firstWorkout:
                return "Primera Victoria"
            case .fiveWorkouts:
                return "Semana Activa"
            case .tenWorkouts:
                return "Constancia Premiada"
            case .weeklyStreak:
                return "Racha Semanal"
            }
        }
        
        var description: String {
            switch self {
            case .firstWorkout:
                return "Completaste tu primer entrenamiento"
            case .fiveWorkouts:
                return "5 entrenamientos completados"
            case .tenWorkouts:
                return "10 entrenamientos completados"
            case .weeklyStreak:
                return "7 días consecutivos de actividad"
            }
        }
        
        var icon: String {
            switch self {
            case .firstWorkout:
                return "star.fill"
            case .fiveWorkouts:
                return "flame.fill"
            case .tenWorkouts:
                return "trophy.fill"
            case .weeklyStreak:
                return "calendar.badge.checkmark"
            }
        }
    }
    
    let id: Kind
    var unlocked: Bool
    var unlockedDate: Date?
    
    init(id: Kind, unlocked: Bool = false, unlockedDate: Date? = nil) {
        self.id = id
        self.unlocked = unlocked
        self.unlockedDate = unlockedDate
    }
    
    static func allAchievements() -> [Achievement] {
        return Kind.allCases.map { Achievement(id: $0) }
    }
}
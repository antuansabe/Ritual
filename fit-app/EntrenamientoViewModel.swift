import Foundation

class EntrenamientoViewModel: ObservableObject {
    @Published var entrenamientos: [Entrenamiento] = []
    
    var entrenamientosOrdenados: [Entrenamiento] {
        entrenamientos.sorted { $0.fecha > $1.fecha }
    }
    
    var totalWorkouts: Int {
        entrenamientos.count
    }
    
    var totalMinutes: Int {
        entrenamientos.reduce(0) { $0 + $1.duracion }
    }
    
    var totalCalories: Int {
        entrenamientos.reduce(0) { $0 + ($1.duracion * 8) }
    }
    
    var currentStreak: Int {
        guard !entrenamientos.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let today = Date()
        var streak = 0
        var currentDate = today
        
        let sortedWorkouts = entrenamientos.sorted { $0.fecha > $1.fecha }
        
        for workout in sortedWorkouts {
            if calendar.isDate(workout.fecha, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if calendar.isDate(workout.fecha, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: today) ?? today) {
                streak += 1
                break
            } else {
                break
            }
        }
        
        return max(streak, entrenamientos.isEmpty ? 0 : 1)
    }
    
    var todayWorkouts: [Entrenamiento] {
        let calendar = Calendar.current
        let today = Date()
        return entrenamientos.filter { calendar.isDate($0.fecha, inSameDayAs: today) }
    }
    
    var thisWeekWorkouts: [Entrenamiento] {
        let calendar = Calendar.current
        let today = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: today) ?? today
        return entrenamientos.filter { $0.fecha >= weekAgo }
    }
    
    func agregarEntrenamiento(tipo: String, duracion: Int) {
        let nuevoEntrenamiento = Entrenamiento(tipo: tipo, duracion: duracion, fecha: Date())
        entrenamientos.append(nuevoEntrenamiento)
    }
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        let calendar = Calendar.current
        let today = Date()
        
        let sampleData = [
            Entrenamiento(tipo: "Cardio", duracion: 30, fecha: today),
            Entrenamiento(tipo: "Yoga", duracion: 45, fecha: calendar.date(byAdding: .hour, value: -3, to: today) ?? today),
            Entrenamiento(tipo: "Fuerza", duracion: 60, fecha: calendar.date(byAdding: .day, value: -1, to: today) ?? today),
            Entrenamiento(tipo: "Caminata", duracion: 25, fecha: calendar.date(byAdding: .day, value: -1, to: today) ?? today),
            Entrenamiento(tipo: "Ciclismo", duracion: 40, fecha: calendar.date(byAdding: .day, value: -2, to: today) ?? today),
            Entrenamiento(tipo: "Natación", duracion: 35, fecha: calendar.date(byAdding: .day, value: -3, to: today) ?? today),
            Entrenamiento(tipo: "Striking", duracion: 50, fecha: calendar.date(byAdding: .day, value: -4, to: today) ?? today),
        ]
        entrenamientos = sampleData
    }
}
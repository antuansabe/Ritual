import Foundation

class EntrenamientoViewModel: ObservableObject {
    @Published var entrenamientos: [Entrenamiento] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userDefaults = UserDefaults.standard
    private let workoutsKey = "SavedWorkouts"
    
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
        entrenamientos.reduce(0) { $0 + AppConstants.calculateCalories(for: $1.duracion) }
    }
    
    var currentStreak: Int {
        guard !entrenamientos.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Agrupar entrenamientos por día
        let workoutDays = Set(entrenamientos.map { calendar.startOfDay(for: $0.fecha) })
        let sortedDays = Array(workoutDays).sorted(by: >)
        
        var streak = 0
        var currentCheckDate = today
        
        for day in sortedDays {
            if calendar.isDate(day, inSameDayAs: currentCheckDate) {
                streak += 1
                currentCheckDate = calendar.date(byAdding: .day, value: -1, to: currentCheckDate) ?? currentCheckDate
            } else {
                break
            }
        }
        
        return streak
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
    
    func agregarEntrenamiento(tipo: String, duracion: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let nuevoEntrenamiento = Entrenamiento(tipo: tipo, duracion: duracion, fecha: Date())
            entrenamientos.append(nuevoEntrenamiento)
            try await saveWorkouts()
        } catch {
            errorMessage = AppError.saveFailed.localizedDescription
        }
        
        isLoading = false
    }
    
    init() {
        loadWorkouts()
    }
    
    private func loadWorkouts() {
        if let data = userDefaults.data(forKey: workoutsKey),
           let decodedWorkouts = try? JSONDecoder().decode([Entrenamiento].self, from: data) {
            self.entrenamientos = decodedWorkouts
        } else {
            // Solo cargar datos de muestra si no hay datos guardados
            loadSampleData()
        }
    }
    
    private func saveWorkouts() async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(entrenamientos)
        userDefaults.set(data, forKey: workoutsKey)
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
    
    func clearError() {
        errorMessage = nil
    }
}
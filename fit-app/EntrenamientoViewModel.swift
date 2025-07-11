import Foundation

class SqUH6kIq89jGG11s48KgotGWrfuMNHR6: ObservableObject {
    @Published var EdFdnkp5UuMy3VJCNfbNQVbqtJ3R0f7A: [GwUTKTnqAiCG48OZaptDYJhnVzb8Rggd] = []
    @Published var YSuY2aW2PCZkKwq4ph5miIoJ2ncJmCdo = false
    @Published var TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy: String?
    
    private let gRuPw7Hk8VHJi7kbT5U4CF66LMecaGGF = UserDefaults.standard
    private let LIEER1PHveFs0DalGE5vWSqQtszO96dG = "SavedWorkouts"
    
    var vYZ4fa2ghsr2dElueiVCgbtZdm6mhFpZ: [GwUTKTnqAiCG48OZaptDYJhnVzb8Rggd] {
        EdFdnkp5UuMy3VJCNfbNQVbqtJ3R0f7A.sorted { $0.fecha > $1.fecha }
    }
    
    var dtSAhjsInADv7EcOxyP7uQFwtXZctHQx: Int {
        EdFdnkp5UuMy3VJCNfbNQVbqtJ3R0f7A.count
    }
    
    var ggax5PJg8tx0gaA3Z3bEvYumPoiafIdG: Int {
        EdFdnkp5UuMy3VJCNfbNQVbqtJ3R0f7A.reduce(0) { $0 + $1.duracion }
    }
    
    var YdMLPUVsFr9j15lAvC2Au5g786i7VRsk: Int {
        EdFdnkp5UuMy3VJCNfbNQVbqtJ3R0f7A.reduce(0) { $0 + pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.macBuYFDgFuotG3Vx9Tc3pppQyU8fFgE(for: $1.duracion) }
    }
    
    var GP2LD8OEZ1Q7Tw3WzF5PNuAoKLky42wd: Int {
        guard !EdFdnkp5UuMy3VJCNfbNQVbqtJ3R0f7A.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Agrupar entrenamientos por día
        let workoutDays = Set(EdFdnkp5UuMy3VJCNfbNQVbqtJ3R0f7A.map { calendar.startOfDay(for: $0.fecha) })
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
    
    var ZbMus1cX3lQlgvAtmOkaaRCqgFywUhhu: [GwUTKTnqAiCG48OZaptDYJhnVzb8Rggd] {
        let calendar = Calendar.current
        let today = Date()
        return EdFdnkp5UuMy3VJCNfbNQVbqtJ3R0f7A.filter { calendar.isDate($0.fecha, inSameDayAs: today) }
    }
    
    var kEWp9gx151xU7eavGFVtcNg9YOiLqnmu: [GwUTKTnqAiCG48OZaptDYJhnVzb8Rggd] {
        let calendar = Calendar.current
        let today = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: today) ?? today
        return EdFdnkp5UuMy3VJCNfbNQVbqtJ3R0f7A.filter { $0.fecha >= weekAgo }
    }
    
    func kZ2egx2BUExWEHUTF4kcHI14M4Df36J8(tipo: String, duracion: Int) async {
        YSuY2aW2PCZkKwq4ph5miIoJ2ncJmCdo = true
        TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = nil
        
        do {
            let nuevoEntrenamiento = GwUTKTnqAiCG48OZaptDYJhnVzb8Rggd(tipo: tipo, duracion: duracion, fecha: Date())
            EdFdnkp5UuMy3VJCNfbNQVbqtJ3R0f7A.append(nuevoEntrenamiento)
            try await wU2QE5Z7TfbmEnkD3Gzk3jQqK4PpkQzF()
        } catch {
            TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = fGsTSzPpELfPriTNhXgvgjffTuQ1eb9H.hiNCTxD5IB37rTmJ8FEa3sxEZ304nBQl.localizedDescription
        }
        
        YSuY2aW2PCZkKwq4ph5miIoJ2ncJmCdo = false
    }
    
    init() {
        C1JQm2KATAfhNvD1Gk2aBtFsRHPiAnaB()
    }
    
    private func C1JQm2KATAfhNvD1Gk2aBtFsRHPiAnaB() {
        guard let data = gRuPw7Hk8VHJi7kbT5U4CF66LMecaGGF.data(forKey: LIEER1PHveFs0DalGE5vWSqQtszO96dG) else {
            MDlDw06KqQOscZpV6zwc6mPZBYfEiDwL()
            return
        }
        
        do {
            self.EdFdnkp5UuMy3VJCNfbNQVbqtJ3R0f7A = try JSONDecoder().decode([GwUTKTnqAiCG48OZaptDYJhnVzb8Rggd].self, from: data)
        } catch {
            print("Error loading workouts: \(error.localizedDescription)")
            TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = fGsTSzPpELfPriTNhXgvgjffTuQ1eb9H.J95y5YdF4aUR6aL5ONOAQHrGaoh2cNPI.localizedDescription
            MDlDw06KqQOscZpV6zwc6mPZBYfEiDwL()
        }
    }
    
    private func wU2QE5Z7TfbmEnkD3Gzk3jQqK4PpkQzF() async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(EdFdnkp5UuMy3VJCNfbNQVbqtJ3R0f7A)
        gRuPw7Hk8VHJi7kbT5U4CF66LMecaGGF.set(data, forKey: LIEER1PHveFs0DalGE5vWSqQtszO96dG)
    }
    
    private func MDlDw06KqQOscZpV6zwc6mPZBYfEiDwL() {
        let calendar = Calendar.current
        let today = Date()
        
        let sampleData = [
            GwUTKTnqAiCG48OZaptDYJhnVzb8Rggd(tipo: "Cardio", duracion: 30, fecha: today),
            GwUTKTnqAiCG48OZaptDYJhnVzb8Rggd(tipo: "Yoga", duracion: 45, fecha: calendar.date(byAdding: .hour, value: -3, to: today) ?? today),
            GwUTKTnqAiCG48OZaptDYJhnVzb8Rggd(tipo: "Fuerza", duracion: 60, fecha: calendar.date(byAdding: .day, value: -1, to: today) ?? today),
            GwUTKTnqAiCG48OZaptDYJhnVzb8Rggd(tipo: "Caminata", duracion: 25, fecha: calendar.date(byAdding: .day, value: -1, to: today) ?? today),
            GwUTKTnqAiCG48OZaptDYJhnVzb8Rggd(tipo: "Ciclismo", duracion: 40, fecha: calendar.date(byAdding: .day, value: -2, to: today) ?? today),
            GwUTKTnqAiCG48OZaptDYJhnVzb8Rggd(tipo: "Natación", duracion: 35, fecha: calendar.date(byAdding: .day, value: -3, to: today) ?? today),
            GwUTKTnqAiCG48OZaptDYJhnVzb8Rggd(tipo: "Striking", duracion: 50, fecha: calendar.date(byAdding: .day, value: -4, to: today) ?? today),
        ]
        EdFdnkp5UuMy3VJCNfbNQVbqtJ3R0f7A = sampleData
    }
    
    func EYA1lT4kx4ae526Okh9jsZgBxFHUOAsZ() {
        TGMG3Myrq6Le2PoAtbtRgcnL1DsCKLIy = nil
    }
}
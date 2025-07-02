import Foundation

class EntrenamientoViewModel: ObservableObject {
    @Published var entrenamientos: [Entrenamiento] = []
    
    var entrenamientosOrdenados: [Entrenamiento] {
        entrenamientos.sorted { $0.fecha > $1.fecha }
    }
    
    func agregarEntrenamiento(tipo: String, duracion: Int) {
        let nuevoEntrenamiento = Entrenamiento(tipo: tipo, duracion: duracion, fecha: Date())
        entrenamientos.append(nuevoEntrenamiento)
    }
}
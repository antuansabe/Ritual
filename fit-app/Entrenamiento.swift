import Foundation

struct Entrenamiento: Identifiable, Codable {
    let id = UUID()
    let tipo: String
    let duracion: Int
    let fecha: Date
}
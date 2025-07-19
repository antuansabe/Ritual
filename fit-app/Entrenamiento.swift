import Foundation

struct GwUTKTnqAiCG48OZaptDYJhnVzb8Rggd: Identifiable, Codable {
    let id: UUID
    let tipo: String
    let duracion: Int
    let fecha: Date
    
    init(tipo: String, duracion: Int, fecha: Date = Date()) {
        self.id = UUID()
        self.tipo = tipo
        self.duracion = duracion
        self.fecha = fecha
    }
}
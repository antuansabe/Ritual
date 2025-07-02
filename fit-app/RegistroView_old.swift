import SwiftUI

struct RegistroView: View {
    @State private var tipoActividad = "Jiu-Jitsu"
    @State private var duracion = ""
    @State private var intensidad = "Moderado"
    @State private var notas = ""
    
    let tiposActividad = ["Jiu-Jitsu", "Pesas", "Funcional", "Yoga", "MMA", "Running"]
    let nivelesIntensidad = ["Ligero", "Moderado", "Intenso"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tipo de actividad")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Picker("Tipo de actividad", selection: $tipoActividad) {
                        ForEach(tiposActividad, id: \.self) { tipo in
                            Text(tipo).tag(tipo)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.white)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Duración (minutos)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    TextField("Ej: 60", text: $duracion)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .colorScheme(.dark)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Intensidad")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Picker("Intensidad", selection: $intensidad) {
                        ForEach(nivelesIntensidad, id: \.self) { nivel in
                            Text(nivel).tag(nivel)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color.clear)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notas")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    TextEditor(text: $notas)
                        .frame(minHeight: 100)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .colorScheme(.dark)
                }
                
                Button(action: guardarEntrenamiento) {
                    Text("Guardar entrenamiento")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding(.top, 16)
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .navigationTitle("Registro")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    private func guardarEntrenamiento() {
        print("=== ENTRENAMIENTO GUARDADO ===")
        print("Tipo: \(tipoActividad)")
        print("Duración: \(duracion) minutos")
        print("Intensidad: \(intensidad)")
        print("Notas: \(notas)")
        print("==============================")
    }
}

#Preview {
    NavigationStack {
        RegistroView()
    }
    .preferredColorScheme(.dark)
}
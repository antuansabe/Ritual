import SwiftUI

struct RegistroView: View {
    @ObservedObject var viewModel: EntrenamientoViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var tipoSeleccionado = "Cardio"
    @State private var duracion = ""
    
    let tiposEntrenamiento = ["Cardio", "Fuerza", "Flexibilidad", "Deportes"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Registrar Entrenamiento")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tipo de entrenamiento")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Picker("Tipo", selection: $tipoSeleccionado) {
                        ForEach(tiposEntrenamiento, id: \.self) { tipo in
                            Text(tipo).tag(tipo)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Duración (minutos)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    TextField("Ej: 30", text: $duracion)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                .padding(.horizontal, 20)
                
                Button(action: {
                    if let duracionInt = Int(duracion), duracionInt > 0 {
                        viewModel.agregarEntrenamiento(tipo: tipoSeleccionado, duracion: duracionInt)
                        dismiss()
                    }
                }) {
                    Text("Guardar entrenamiento")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .disabled(duracion.isEmpty || Int(duracion) == nil || Int(duracion)! <= 0)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    RegistroView(viewModel: EntrenamientoViewModel())
        .preferredColorScheme(.dark)
}
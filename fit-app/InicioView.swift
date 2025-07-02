import SwiftUI

struct InicioView: View {
    @ObservedObject var viewModel: EntrenamientoViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Hola, Antonio 👋")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)
            
            NavigationLink(destination: RegistroView(viewModel: viewModel)) {
                Text("Registrar entrenamiento")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            
            if !viewModel.entrenamientosOrdenados.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Entrenamientos recientes")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.entrenamientosOrdenados) { entrenamiento in
                                EntrenamientoRow(entrenamiento: entrenamiento)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            } else {
                Spacer()
                Text("No hay entrenamientos registrados")
                    .font(.body)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .navigationBarHidden(true)
    }
}

struct EntrenamientoRow: View {
    let entrenamiento: Entrenamiento
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entrenamiento.tipo)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("\(entrenamiento.duracion) min")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: entrenamiento.fecha))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        InicioView(viewModel: EntrenamientoViewModel())
    }
    .preferredColorScheme(.dark)
}
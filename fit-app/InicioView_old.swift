import SwiftUI

struct InicioView: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Text("Hola, Antonio 👋")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            NavigationLink(destination: RegistroView()) {
                Text("Registrar entrenamiento")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        InicioView()
    }
    .preferredColorScheme(.dark)
}
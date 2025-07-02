import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = EntrenamientoViewModel()
    
    var body: some View {
        TabView {
            NavigationStack {
                InicioView(viewModel: viewModel)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Inicio")
            }
            
            NavigationStack {
                RegistroView(viewModel: viewModel)
            }
            .tabItem {
                Image(systemName: "plus.circle.fill")
                Text("Registrar")
            }
            
            NavigationStack {
                PerfilView(viewModel: viewModel)
            }
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("Perfil")
            }
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
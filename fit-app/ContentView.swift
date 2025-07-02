import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = EntrenamientoViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            AppConstants.Design.backgroundGradient
                .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                NavigationStack {
                    InicioView(viewModel: viewModel, selectedTab: $selectedTab)
                }
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                    Text("Inicio")
                        .font(AppConstants.Design.footnoteFont)
                }
                .tag(0)
                
                NavigationStack {
                    RegistroView(viewModel: viewModel, selectedTab: $selectedTab)
                }
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "plus.circle.fill" : "plus.circle")
                        .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                    Text("Registrar")
                        .font(AppConstants.Design.footnoteFont)
                }
                .tag(1)
                
                NavigationStack {
                    HistorialView(viewModel: viewModel)
                }
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                        .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                    Text("Historial")
                        .font(AppConstants.Design.footnoteFont)
                }
                .tag(2)
                
                NavigationStack {
                    PerfilView(viewModel: viewModel)
                }
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "person.crop.circle.fill" : "person.crop.circle")
                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                    Text("Perfil")
                        .font(AppConstants.Design.footnoteFont)
                }
                .tag(3)
            }
            .tint(AppConstants.Design.blue)
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

#Preview {
    ContentView()
}
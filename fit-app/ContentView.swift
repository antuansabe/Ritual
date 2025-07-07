import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        ZStack {
            // Background gradient
            AppConstants.Design.backgroundGradient
                .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                NavigationStack {
                    InicioView(selectedTab: $selectedTab)
                }
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                    Text("Inicio")
                        .font(AppConstants.Design.footnoteFont)
                }
                .tag(0)
                
                NavigationStack {
                    RegistroView(selectedTab: $selectedTab)
                }
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "plus.circle.fill" : "plus.circle")
                        .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                    Text("Registrar")
                        .font(AppConstants.Design.footnoteFont)
                }
                .tag(1)
                
                NavigationStack {
                    TimerView()
                }
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "timer" : "timer")
                        .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                    Text("Timer")
                        .font(AppConstants.Design.footnoteFont)
                }
                .tag(2)
                
                NavigationStack {
                    HistorialView()
                }
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "chart.bar.fill" : "chart.bar")
                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                    Text("Historial")
                        .font(AppConstants.Design.footnoteFont)
                }
                .tag(3)
                
                NavigationStack {
                    PerfilView()
                }
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.crop.circle.fill" : "person.crop.circle")
                        .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                    Text("Perfil")
                        .font(AppConstants.Design.footnoteFont)
                }
                .tag(4)
            }
            .tint(AppConstants.Design.blue)
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
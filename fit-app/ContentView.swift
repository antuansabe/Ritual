import SwiftUI

struct B2rIflV5J4IUvMWrPeMVoV4aFDkd8UwZ: View {
    @State private var selectedTab = 0
    @StateObject private var navigationContext = NavigationContext()
    let persistenceController = GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    var body: some View {
        ZStack {
            // Background gradient
            pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.P2JAqpuaMaUNg0pKyHnxvgk0VYFtEhNu
                .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                NavigationStack {
                    nGHHMNtoBwM0IFT4HW5NflwlHlDPD5KZ(selectedTab: $selectedTab)
                }
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                    Text("Inicio")
                        .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.zOhE8MtN0Z8xUsj1pwHJeEuvzmgf7tYr)
                }
                .tag(0)
                
                NavigationStack {
                    IMjYxABvVAMQSC7XsNhcGrSt11ziYDi2(selectedTab: $selectedTab)
                }
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "plus.circle.fill" : "plus.circle")
                        .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                    Text("Registrar")
                        .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.zOhE8MtN0Z8xUsj1pwHJeEuvzmgf7tYr)
                }
                .tag(1)
                
                NavigationStack {
                    TimerView()
                }
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "timer" : "timer")
                        .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                    Text("Timer")
                        .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.zOhE8MtN0Z8xUsj1pwHJeEuvzmgf7tYr)
                }
                .tag(2)
                
                NavigationStack {
                    HistorialView()
                        .onAppear {
                            navigationContext.setTabContext()
                        }
                }
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "chart.bar.fill" : "chart.bar")
                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                    Text("Historial")
                        .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.zOhE8MtN0Z8xUsj1pwHJeEuvzmgf7tYr)
                }
                .tag(3)
                
                NavigationStack {
                    q29ClCI2LABu3hQnTLcu6EAO6vHtllJW()
                }
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.crop.circle.fill" : "person.crop.circle")
                        .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                    Text("Perfil")
                        .font(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.zOhE8MtN0Z8xUsj1pwHJeEuvzmgf7tYr)
                }
                .tag(4)
            }
            .tint(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.rYKfPHiDxgHes5dAHUqMXv8tJwl6R5jr)
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .environment(\.managedObjectContext, persistenceController.FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext)
        .navigationContext(navigationContext)
    }
}

#Preview {
    B2rIflV5J4IUvMWrPeMVoV4aFDkd8UwZ()
        .environment(\.managedObjectContext, GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx.WD9g7eC9WeDqkPF9KKQ4lphkoLpd3nwF.FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext)
}
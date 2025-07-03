import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ContentView()
    }
}

#Preview {
    MainAppView()
        .environmentObject(AuthViewModel())
}
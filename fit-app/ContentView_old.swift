import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            InicioView()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}

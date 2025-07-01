import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hola, Antonio 👋")
                .font(.largeTitle)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .foregroundColor(.white)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
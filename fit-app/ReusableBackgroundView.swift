import SwiftUI

struct ReusableBackgroundView<Content: View>: View {
    let imageName: String
    let overlayOpacity: Double
    let content: Content
    
    init(imageName: String, overlayOpacity: Double = 0.0, @ViewBuilder content: () -> Content) {
        self.imageName = imageName
        self.overlayOpacity = overlayOpacity
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Background image
            Image(imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Optional overlay for darkening
            if overlayOpacity > 0 {
                Color.black
                    .opacity(overlayOpacity)
                    .ignoresSafeArea()
            }
            
            // Content
            content
        }
    }
}

#Preview {
    ReusableBackgroundView(imageName: "loginBackground", overlayOpacity: 0.3) {
        VStack(spacing: 20) {
            Text("Hola")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Button("Iniciar sesión") {
                // Action
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}
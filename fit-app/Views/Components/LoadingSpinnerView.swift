import SwiftUI

struct LoadingSpinnerView: View {
    let message: String
    
    init(message: String = "LOADING".t) {
        self.message = message
    }
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            // Spinner container
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
                
                Text(message)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.8))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: true)
    }
}

// MARK: - Loading Overlay Modifier
struct LoadingOverlay: ViewModifier {
    let isLoading: Bool
    let message: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isLoading {
                LoadingSpinnerView(message: message)
            }
        }
    }
}

extension View {
    func loadingOverlay(isLoading: Bool, message: String = "LOADING".t) -> some View {
        self.modifier(LoadingOverlay(isLoading: isLoading, message: message))
    }
}

#Preview {
    VStack {
        Text("Content behind loading")
            .padding()
    }
    .loadingOverlay(isLoading: true, message: "SAVING".t)
}
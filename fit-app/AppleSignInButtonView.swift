import SwiftUI
import AuthenticationServices

struct kUUx8S7NdyM5CPSTtv4aW8j7aBf037UH: View {
    @StateObject private var appleSignInManager = Lx00e402Z63gwc4vKEC97NhbZVDDCOfA.shared
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                print("🍎 Apple Sign In button tapped - preparing request...")
                appleSignInManager.jniddSZKEoGcms9So9T3uUpuM55PjT8X()
            },
            onCompletion: { result in
                print("🍎 Apple Sign In button completion called")
                // The actual handling is done in AppleSignInManager
                // This is just for logging/debugging
                switch result {
                case .success:
                    print("✅ Apple Sign In button reported success")
                case .failure(let error):
                    print("❌ Apple Sign In button reported failure: \(error.localizedDescription)")
                }
            }
        )
        .signInWithAppleButtonStyle(.whiteOutline)
        .frame(height: 45)
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .disabled(appleSignInManager.isLoading)
        .opacity(appleSignInManager.isLoading ? 0.6 : 1.0)
        .overlay(
            // Loading indicator
            Group {
                if appleSignInManager.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(0.8)
                }
            }
        )
    }
}

#Preview {
    kUUx8S7NdyM5CPSTtv4aW8j7aBf037UH()
        .preferredColorScheme(.dark)
}
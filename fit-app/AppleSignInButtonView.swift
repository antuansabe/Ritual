import SwiftUI
import AuthenticationServices

struct AppleSignInButtonView: View {
    @StateObject private var appleSignInManager = AppleSignInManager.shared
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                print("[U+1F34E] Apple Sign In button tapped - preparing request...")
                appleSignInManager.signInWithApple()
            },
            onCompletion: { result in
                print("[U+1F34E] Apple Sign In button completion called")
                // The actual handling is done in AppleSignInManager
                // This is just for logging/debugging
                switch result {
                case .success:
                    print("[OK] Apple Sign In button reported success")
                case .failure(let error):
                    print("[ERR] Apple Sign In button reported failure: \(error.localizedDescription)")
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
    AppleSignInButtonView()
        .preferredColorScheme(.dark)
}
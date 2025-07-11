import SwiftUI

struct fdsNnzsNuc4ubtpYpSbsrJfmPuz1AmGM: View {
    @EnvironmentObject var authViewModel: M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB
    @State private var showingConfirmation = false
    
    let style: PgXfOx7vFQZpY0rsRXcmQptR4wBBoBPS
    
    enum PgXfOx7vFQZpY0rsRXcmQptR4wBBoBPS {
        case text
        case icon
        case card
    }
    
    init(style: PgXfOx7vFQZpY0rsRXcmQptR4wBBoBPS = .text) {
        self.style = style
    }
    
    var body: some View {
        Button(action: {
            showingConfirmation = true
        }) {
            switch style {
            case .text:
                Text("Cerrar sesión")
                    .foregroundColor(.red)
            case .icon:
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundColor(.red)
            case .card:
                HStack(spacing: 12) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.red)
                    
                    Text("Cerrar sesión")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.red)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.red.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
        .alert("Cerrar sesión", isPresented: $showingConfirmation) {
            Button("Cancelar", role: .cancel) { }
            Button("Cerrar sesión", role: .destructive) {
                authViewModel.xeZsiWBAd5pwKDqJFItOs5ErVipoJw0y()
            }
        } message: {
            Text("¿Estás seguro de que quieres cerrar sesión?")
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        fdsNnzsNuc4ubtpYpSbsrJfmPuz1AmGM(style: .text)
        fdsNnzsNuc4ubtpYpSbsrJfmPuz1AmGM(style: .icon)
        fdsNnzsNuc4ubtpYpSbsrJfmPuz1AmGM(style: .card)
    }
    .padding()
    .environmentObject(M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB())
}
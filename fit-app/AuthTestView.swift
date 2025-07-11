import SwiftUI

struct enhgCsfhgu4V3xtKpZcvrIPvisksjuew: View {
    @State private var showLogin = false
    @State private var showRegister = false
    
    var body: some View {
        ZStack {
            pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.P2JAqpuaMaUNg0pKyHnxvgk0VYFtEhNu
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Text("Test de Autenticación")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                VStack(spacing: 16) {
                    Button("Mostrar Login") {
                        showLogin = true
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                            .fill(pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.Fl7U1OWoRlFXK0bWCdojinFQIb6zPmMX.BRZumEEKLDNhpWlIssXSSHs7tRJDkiWk)
                    )
                    
                    Button("Mostrar Register") {
                        showRegister = true
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: pgbZhy0Lxp1T8uS1Guy4Hv0b3xS7aPLc.k137TNijvZD3w1DkCOx9VDgHKsSa6IOU.EzcnhFsVsemfqR641lcIHDHfEWrqdIrZ)
                            .fill(LinearGradient(
                                colors: [Color.green, Color.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                    )
                }
                .padding(.horizontal, 40)
            }
        }
        .sheet(isPresented: $showLogin) {
            wdJa7hhtRa6I67ei2Mi07KjELvqym68b()
                .environmentObject(M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB())
        }
        .sheet(isPresented: $showRegister) {
            B4qvsC5G8P17ox009Aj1FnUDwHQ5CAhI()
                .environmentObject(M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB())
        }
    }
}

#Preview {
    enhgCsfhgu4V3xtKpZcvrIPvisksjuew()
}
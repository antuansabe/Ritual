import SwiftUI
import Network
import Combine
import os.log

// MARK: - Network Monitor
class T6BDbtv2u0anCAqwtryY4XMWEB6pm5mX: ObservableObject {
    static let DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX = T6BDbtv2u0anCAqwtryY4XMWEB6pm5mX()
    
    @Published var AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD = false
    @Published var qM87SDle89QNegw75KZH0WQzyom9dMpz: wNwig4dpRHZV12ARZSu5GtwyMtYFklZl = .U2BbCrhB76y6e5hEyEs6MCs6RwZ3sY9T
    @Published var JsKYc2qFPPkgCzcrxcidQR9mhcIEP14D = false
    
    private let sRdDqGnbuFbQEUeqkIca38pSEcs4GTuW = NWPathMonitor()
    private let qJ4ybqZ6TxFy0QZgLIGh8vNVgjrSu53H = DispatchQueue(label: "NetworkMonitor")
    
    enum wNwig4dpRHZV12ARZSu5GtwyMtYFklZl {
        case NLDJfJu7kC5gNfmdSQYBDF0uxx3iOOIf
        case y1qY4m9bjPfmVJ8qhcyexhmKd2QiuQ0s
        case UZc2NOCwZONcJzAibKpo6TrER2enaj05
        case U2BbCrhB76y6e5hEyEs6MCs6RwZ3sY9T
        
        var W5TVRE97oSlHf67bpUXP80LgXeYzET6B: String {
            switch self {
            case .NLDJfJu7kC5gNfmdSQYBDF0uxx3iOOIf: return "WiFi"
            case .y1qY4m9bjPfmVJ8qhcyexhmKd2QiuQ0s: return "Celular"
            case .UZc2NOCwZONcJzAibKpo6TrER2enaj05: return "Ethernet"
            case .U2BbCrhB76y6e5hEyEs6MCs6RwZ3sY9T: return "Sin conexión"
            }
        }
        
        var i6rGNxQpdsotQeCmVcyhE5mg1Tqt59EB: String {
            switch self {
            case .NLDJfJu7kC5gNfmdSQYBDF0uxx3iOOIf: return "📶"
            case .y1qY4m9bjPfmVJ8qhcyexhmKd2QiuQ0s: return "📱"
            case .UZc2NOCwZONcJzAibKpo6TrER2enaj05: return "🌐"
            case .U2BbCrhB76y6e5hEyEs6MCs6RwZ3sY9T: return "❌"
            }
        }
    }
    
    private init() {
        KS7KlEqxSY9KdHmrzi1LMNMF8x1Uudtm()
    }
    
    private func KS7KlEqxSY9KdHmrzi1LMNMF8x1Uudtm() {
        sRdDqGnbuFbQEUeqkIca38pSEcs4GTuW.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let wasConnected = self?.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD ?? false
                self?.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD = path.status == .satisfied
                
                // Detect connection type
                if path.usesInterfaceType(.wifi) {
                    self?.qM87SDle89QNegw75KZH0WQzyom9dMpz = .NLDJfJu7kC5gNfmdSQYBDF0uxx3iOOIf
                } else if path.usesInterfaceType(.cellular) {
                    self?.qM87SDle89QNegw75KZH0WQzyom9dMpz = .y1qY4m9bjPfmVJ8qhcyexhmKd2QiuQ0s
                } else if path.usesInterfaceType(.wiredEthernet) {
                    self?.qM87SDle89QNegw75KZH0WQzyom9dMpz = .UZc2NOCwZONcJzAibKpo6TrER2enaj05
                } else {
                    self?.qM87SDle89QNegw75KZH0WQzyom9dMpz = .U2BbCrhB76y6e5hEyEs6MCs6RwZ3sY9T
                }
                
                // Track offline state
                if !wasConnected && path.status != .satisfied {
                    self?.JsKYc2qFPPkgCzcrxcidQR9mhcIEP14D = true
                }
                
                // Log network changes
                self?.hw64xfqCTsMU8s0dJwEErn9FQo5TdwKh(wasConnected: wasConnected, currentStatus: path.status)
                
                // Notify CloudKit sync when connection is restored
                if !wasConnected && path.status == .satisfied && self?.JsKYc2qFPPkgCzcrxcidQR9mhcIEP14D == true {
                    self?.HnbOultdgWjMpMJyRzL7QlghF8ODBB4Q()
                }
            }
        }
        
        sRdDqGnbuFbQEUeqkIca38pSEcs4GTuW.start(queue: qJ4ybqZ6TxFy0QZgLIGh8vNVgjrSu53H)
        #if DEBUG
        Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🌐 NetworkMonitor: Monitoreo de red iniciado")
        #endif
    }
    
    private func hw64xfqCTsMU8s0dJwEErn9FQo5TdwKh(wasConnected: Bool, currentStatus: NWPath.Status) {
        let isCurrentlyConnected = currentStatus == .satisfied
        
        if !wasConnected && isCurrentlyConnected {
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🌐 ✅ Red CONECTADA - Tipo: \(self.qM87SDle89QNegw75KZH0WQzyom9dMpz.i6rGNxQpdsotQeCmVcyhE5mg1Tqt59EB) \(self.qM87SDle89QNegw75KZH0WQzyom9dMpz.W5TVRE97oSlHf67bpUXP80LgXeYzET6B)")
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔄 Iniciando sincronización automática CloudKit...")
            #endif
        } else if wasConnected && !isCurrentlyConnected {
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🌐 ❌ Red DESCONECTADA - Modo offline activado")
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("💾 Los datos se guardarán localmente hasta reconectar")
            #endif
        } else if isCurrentlyConnected {
            #if DEBUG
            Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🌐 📡 Cambio de red - Tipo: \(self.qM87SDle89QNegw75KZH0WQzyom9dMpz.i6rGNxQpdsotQeCmVcyhE5mg1Tqt59EB) \(self.qM87SDle89QNegw75KZH0WQzyom9dMpz.W5TVRE97oSlHf67bpUXP80LgXeYzET6B)")
            #endif
        }
    }
    
    private func HnbOultdgWjMpMJyRzL7QlghF8ODBB4Q() {
        #if DEBUG
        Logger.yL8NaAoCOrUH0vo1x7vLpRaCcqwEFrfx.debug("🔄 CONEXIÓN RESTAURADA - Iniciando sincronización CloudKit")
        #endif
        
        // Trigger CloudKit sync
        NotificationCenter.default.post(
            name: .ILlsG6AGSPfKqmaZ8Mna8hoLCQupaEms,
            object: nil,
            userInfo: ["connectionType": qM87SDle89QNegw75KZH0WQzyom9dMpz.W5TVRE97oSlHf67bpUXP80LgXeYzET6B]
        )
        
        // Reset offline flag after a delay to allow sync
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.JsKYc2qFPPkgCzcrxcidQR9mhcIEP14D = false
        }
    }
    
    deinit {
        sRdDqGnbuFbQEUeqkIca38pSEcs4GTuW.cancel()
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let ILlsG6AGSPfKqmaZ8Mna8hoLCQupaEms = Notification.Name("networkConnectionRestored")
}

// MARK: - Network Status Banner
struct SFjoEA9WgrgcG2VXMOEPdBh25bSeyWSg: View {
    @ObservedObject var networkMonitor = T6BDbtv2u0anCAqwtryY4XMWEB6pm5mX.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @State private var showBanner = false
    
    var body: some View {
        VStack(spacing: 0) {
            if !networkMonitor.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD {
                HStack(spacing: 12) {
                    Image(systemName: "wifi.slash")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Modo Offline")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Los datos se sincronizarán cuando regrese la conexión")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "info.circle")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 14))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [Color.orange, Color.red.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            } else if networkMonitor.JsKYc2qFPPkgCzcrxcidQR9mhcIEP14D {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Conexión Restaurada")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Sincronizando datos con iCloud...")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Spacer()
                    
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [Color.green, Color.blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: networkMonitor.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD)
        .animation(.easeInOut(duration: 0.5), value: networkMonitor.JsKYc2qFPPkgCzcrxcidQR9mhcIEP14D)
    }
}

// MARK: - Network Status Card for Settings
struct kpzgruBC1Plnfc1qqU6PbDLy9aJwEMTS: View {
    @ObservedObject var networkMonitor = T6BDbtv2u0anCAqwtryY4XMWEB6pm5mX.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Estado de Red")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            
            HStack(spacing: 16) {
                // Connection status icon
                ZStack {
                    Circle()
                        .fill(networkMonitor.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: networkMonitor.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD ? "wifi" : "wifi.slash")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(networkMonitor.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD ? .green : .red)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(networkMonitor.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD ? "Conectado" : "Desconectado")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(networkMonitor.qM87SDle89QNegw75KZH0WQzyom9dMpz.W5TVRE97oSlHf67bpUXP80LgXeYzET6B)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    if !networkMonitor.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD {
                        Text("Los datos se guardan localmente")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.orange)
                    }
                }
                
                Spacer()
                
                // Connection type emoji
                Text(networkMonitor.qM87SDle89QNegw75KZH0WQzyom9dMpz.i6rGNxQpdsotQeCmVcyhE5mg1Tqt59EB)
                    .font(.system(size: 28))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            networkMonitor.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD ? Color.green.opacity(0.3) : Color.orange.opacity(0.3),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
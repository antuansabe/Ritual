import SwiftUI
import Network
import Combine
import os.log

// MARK: - Network Monitor
class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    @Published var isConnected = false
    @Published var connectionType: ConnectionType = .none
    @Published var hasBeenOffline = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case none
        
        var description: String {
            switch self {
            case .wifi: return "WiFi"
            case .cellular: return "Celular"
            case .ethernet: return "Ethernet"
            case .none: return "Sin conexión"
            }
        }
        
        var emoji: String {
            switch self {
            case .wifi: return "📶"
            case .cellular: return "📱"
            case .ethernet: return "🌐"
            case .none: return "❌"
            }
        }
    }
    
    private init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let wasConnected = self?.isConnected ?? false
                self?.isConnected = path.status == .satisfied
                
                // Detect connection type
                if path.usesInterfaceType(.wifi) {
                    self?.connectionType = .wifi
                } else if path.usesInterfaceType(.cellular) {
                    self?.connectionType = .cellular
                } else if path.usesInterfaceType(.wiredEthernet) {
                    self?.connectionType = .ethernet
                } else {
                    self?.connectionType = .none
                }
                
                // Track offline state
                if !wasConnected && path.status != .satisfied {
                    self?.hasBeenOffline = true
                }
                
                // Log network changes
                self?.logNetworkChange(wasConnected: wasConnected, currentStatus: path.status)
                
                // Notify CloudKit sync when connection is restored
                if !wasConnected && path.status == .satisfied && self?.hasBeenOffline == true {
                    self?.handleConnectionRestored()
                }
            }
        }
        
        monitor.start(queue: queue)
        #if DEBUG
        Logger.network.debug("🌐 NetworkMonitor: Monitoreo de red iniciado")
        #endif
    }
    
    private func logNetworkChange(wasConnected: Bool, currentStatus: NWPath.Status) {
        let isCurrentlyConnected = currentStatus == .satisfied
        
        if !wasConnected && isCurrentlyConnected {
            #if DEBUG
            Logger.network.debug("🌐 ✅ Red CONECTADA - Tipo: \(connectionType.emoji) \(connectionType.description)")
            Logger.network.debug("🔄 Iniciando sincronización automática CloudKit...")
            #endif
        } else if wasConnected && !isCurrentlyConnected {
            #if DEBUG
            Logger.network.debug("🌐 ❌ Red DESCONECTADA - Modo offline activado")
            Logger.network.debug("💾 Los datos se guardarán localmente hasta reconectar")
            #endif
        } else if isCurrentlyConnected {
            #if DEBUG
            Logger.network.debug("🌐 📡 Cambio de red - Tipo: \(connectionType.emoji) \(connectionType.description)")
            #endif
        }
    }
    
    private func handleConnectionRestored() {
        #if DEBUG
        Logger.network.debug("🔄 CONEXIÓN RESTAURADA - Iniciando sincronización CloudKit")
        #endif
        
        // Trigger CloudKit sync
        NotificationCenter.default.post(
            name: .networkConnectionRestored,
            object: nil,
            userInfo: ["connectionType": connectionType.description]
        )
        
        // Reset offline flag after a delay to allow sync
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.hasBeenOffline = false
        }
    }
    
    deinit {
        monitor.cancel()
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let networkConnectionRestored = Notification.Name("networkConnectionRestored")
}

// MARK: - Network Status Banner
struct NetworkStatusBanner: View {
    @ObservedObject var networkMonitor = NetworkMonitor.shared
    @State private var showBanner = false
    
    var body: some View {
        VStack(spacing: 0) {
            if !networkMonitor.isConnected {
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
            } else if networkMonitor.hasBeenOffline {
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
        .animation(.easeInOut(duration: 0.5), value: networkMonitor.isConnected)
        .animation(.easeInOut(duration: 0.5), value: networkMonitor.hasBeenOffline)
    }
}

// MARK: - Network Status Card for Settings
struct NetworkStatusCard: View {
    @ObservedObject var networkMonitor = NetworkMonitor.shared
    
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
                        .fill(networkMonitor.isConnected ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: networkMonitor.isConnected ? "wifi" : "wifi.slash")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(networkMonitor.isConnected ? .green : .red)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(networkMonitor.isConnected ? "Conectado" : "Desconectado")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(networkMonitor.connectionType.description)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    if !networkMonitor.isConnected {
                        Text("Los datos se guardan localmente")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.orange)
                    }
                }
                
                Spacer()
                
                // Connection type emoji
                Text(networkMonitor.connectionType.emoji)
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
                            networkMonitor.isConnected ? Color.green.opacity(0.3) : Color.orange.opacity(0.3),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
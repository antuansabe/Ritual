import SwiftUI
import CoreData
import CloudKit
import Combine

// MARK: - Offline Manager
class f44CM3JdBo3CztstNOncNr1s4UV8ejD1: ObservableObject {
    static let DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX = f44CM3JdBo3CztstNOncNr1s4UV8ejD1()
    
    @Published var B0o5q2YLovddpvaVRWfJ7WLqvDCoILe4: Int = 0
    @Published var YbqAaxfU6LgNJtTvL72oR1DcJC39G6uw: Bool = false
    @Published var n4yktK0CDVvoriTTb5hO06eZnGQhWtkO: Date?
    @Published var EhMl3roOhVS0DDlA0Vm6u6E5TN5E1ukg: dB5EkMzi5txkeXE6NBmlPLfeheS7W6XA = .ELUzH9gG93YqDlAmcRtVcWsXBtvjxxUd
    
    private var e6GbWj0JS44Gsu8Z4iRCLKT0VRiHPjhg = Set<AnyCancellable>()
    private let FU31nOsXzkAu3ssDTzwUVmAnypmtztob: NSPersistentCloudKitContainer
    private let cCLo8pBGvFmDlgxAZEAVTmziJmQW21PK = T6BDbtv2u0anCAqwtryY4XMWEB6pm5mX.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    enum dB5EkMzi5txkeXE6NBmlPLfeheS7W6XA {
        case ELUzH9gG93YqDlAmcRtVcWsXBtvjxxUd
        case D5hTORJnjhceFYvUBxM64q7NBk0xnsBh
        case Amqyy95vWgcOGxPe2gHNEvOb2gQuwTDe
        case B6guvQySqp61PhiS7GuVYZpS4DK79waY(String)
        
        var W5TVRE97oSlHf67bpUXP80LgXeYzET6B: String {
            switch self {
            case .ELUzH9gG93YqDlAmcRtVcWsXBtvjxxUd: return "En espera"
            case .D5hTORJnjhceFYvUBxM64q7NBk0xnsBh: return "Sincronizando..."
            case .Amqyy95vWgcOGxPe2gHNEvOb2gQuwTDe: return "Sincronización exitosa"
            case .B6guvQySqp61PhiS7GuVYZpS4DK79waY(let error): return "Error: \(error)"
            }
        }
        
        var i6rGNxQpdsotQeCmVcyhE5mg1Tqt59EB: String {
            switch self {
            case .ELUzH9gG93YqDlAmcRtVcWsXBtvjxxUd: return "⏱️"
            case .D5hTORJnjhceFYvUBxM64q7NBk0xnsBh: return "🔄"
            case .Amqyy95vWgcOGxPe2gHNEvOb2gQuwTDe: return "✅"
            case .B6guvQySqp61PhiS7GuVYZpS4DK79waY: return "❌"
            }
        }
    }
    
    private init() {
        self.FU31nOsXzkAu3ssDTzwUVmAnypmtztob = GgJjlIWWrlkkeb1rUQT1TyDcuxy3khjx.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.FU31nOsXzkAu3ssDTzwUVmAnypmtztob
        qMjsf1IWTje8tFDhWKEpXpE92uJgU3HZ()
        D9sOmGkjITWa44coPEifMK5I9qw4Vzvj()
    }
    
    // MARK: - Setup
    private func qMjsf1IWTje8tFDhWKEpXpE92uJgU3HZ() {
        // Monitor network status changes
        cCLo8pBGvFmDlgxAZEAVTmziJmQW21PK.$AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD
            .sink { [weak self] isConnected in
                if isConnected {
                    self?.SISkcA95WMByftv24JEF644un4n77iNo()
                } else {
                    self?.t51FLxUVpxaGAbT1j4gwPJ2fROKNYZ7O()
                }
            }
            .store(in: &e6GbWj0JS44Gsu8Z4iRCLKT0VRiHPjhg)
        
        // Listen for connection restored notification
        NotificationCenter.default.publisher(for: .ILlsG6AGSPfKqmaZ8Mna8hoLCQupaEms)
            .sink { [weak self] _ in
                self?.NViXNgXcM1zVt0cas0R7CHvbeKH6SWyM()
            }
            .store(in: &e6GbWj0JS44Gsu8Z4iRCLKT0VRiHPjhg)
        
        // Monitor Core Data saves for pending sync count
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
            .sink { [weak self] notification in
                self?.zjucttRzZNROcMYVAu7NehOeGvBK69nQ(from: notification)
            }
            .store(in: &e6GbWj0JS44Gsu8Z4iRCLKT0VRiHPjhg)
        
        print("💾 OfflineManager: Sistema offline inicializado")
    }
    
    private func D9sOmGkjITWa44coPEifMK5I9qw4Vzvj() {
        // Monitor CloudKit events for sync status
        NotificationCenter.default.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification)
            .sink { [weak self] notification in
                self?.bj3sTebVa9G5O7MKm5u8tW18iuREPcNZ(notification)
            }
            .store(in: &e6GbWj0JS44Gsu8Z4iRCLKT0VRiHPjhg)
    }
    
    // MARK: - Network Event Handlers
    private func SISkcA95WMByftv24JEF644un4n77iNo() {
        guard cCLo8pBGvFmDlgxAZEAVTmziJmQW21PK.JsKYc2qFPPkgCzcrxcidQR9mhcIEP14D else { return }
        
        print("🌐 ✅ Red reconectada - Preparando sincronización offline")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.NViXNgXcM1zVt0cas0R7CHvbeKH6SWyM()
        }
    }
    
    private func t51FLxUVpxaGAbT1j4gwPJ2fROKNYZ7O() {
        print("🌐 ❌ Red desconectada - Activando modo offline")
        print("💾 Los entrenamientos se guardarán localmente")
        
        DispatchQueue.main.async {
            self.EhMl3roOhVS0DDlA0Vm6u6E5TN5E1ukg = .ELUzH9gG93YqDlAmcRtVcWsXBtvjxxUd
            self.YbqAaxfU6LgNJtTvL72oR1DcJC39G6uw = false
        }
    }
    
    // MARK: - CloudKit Sync Management
    private func NViXNgXcM1zVt0cas0R7CHvbeKH6SWyM() {
        guard cCLo8pBGvFmDlgxAZEAVTmziJmQW21PK.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD else {
            print("❌ No se puede sincronizar: Sin conexión a internet")
            return
        }
        
        print("🔄 Iniciando sincronización CloudKit después de reconexión...")
        
        DispatchQueue.main.async {
            self.YbqAaxfU6LgNJtTvL72oR1DcJC39G6uw = true
            self.EhMl3roOhVS0DDlA0Vm6u6E5TN5E1ukg = .D5hTORJnjhceFYvUBxM64q7NBk0xnsBh
        }
        
        // Force CloudKit to attempt sync by saving the context
        let context = FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext
        
        do {
            if context.hasChanges {
                try context.save()
                print("💾 Context guardado - CloudKit sincronizará automáticamente")
            } else {
                // Even if no changes, this can trigger a sync check
                try context.save()
                print("🔄 Trigger de sincronización enviado a CloudKit")
            }
        } catch {
            print("❌ Error al trigger sincronización: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.EhMl3roOhVS0DDlA0Vm6u6E5TN5E1ukg = .B6guvQySqp61PhiS7GuVYZpS4DK79waY(error.localizedDescription)
                self.YbqAaxfU6LgNJtTvL72oR1DcJC39G6uw = false
            }
        }
    }
    
    // MARK: - CloudKit Event Handling
    private func bj3sTebVa9G5O7MKm5u8tW18iuREPcNZ(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let event = userInfo[NSPersistentCloudKitContainer.eventChangedNotification] as? NSPersistentCloudKitContainer.Event else {
            return
        }
        
        DispatchQueue.main.async {
            self.LqmxgkYUhCMWejtqMz7zCz5CUBayoN75(event)
        }
    }
    
    private func LqmxgkYUhCMWejtqMz7zCz5CUBayoN75(_ event: NSPersistentCloudKitContainer.Event) {
        switch event.type {
        case .import:
            if let error = event.error {
                print("❌ CloudKit Import Error: \(error.localizedDescription)")
                EhMl3roOhVS0DDlA0Vm6u6E5TN5E1ukg = .B6guvQySqp61PhiS7GuVYZpS4DK79waY("Import failed")
                YbqAaxfU6LgNJtTvL72oR1DcJC39G6uw = false
            } else {
                print("📥 CloudKit Import Success: Datos recibidos desde iCloud")
                if YbqAaxfU6LgNJtTvL72oR1DcJC39G6uw {
                    EhMl3roOhVS0DDlA0Vm6u6E5TN5E1ukg = .Amqyy95vWgcOGxPe2gHNEvOb2gQuwTDe
                    n4yktK0CDVvoriTTb5hO06eZnGQhWtkO = Date()
                    YbqAaxfU6LgNJtTvL72oR1DcJC39G6uw = false
                    
                    // Auto-hide success status after delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        if case .Amqyy95vWgcOGxPe2gHNEvOb2gQuwTDe = self.EhMl3roOhVS0DDlA0Vm6u6E5TN5E1ukg {
                            self.EhMl3roOhVS0DDlA0Vm6u6E5TN5E1ukg = .ELUzH9gG93YqDlAmcRtVcWsXBtvjxxUd
                        }
                    }
                }
            }
            
        case .export:
            if let error = event.error {
                print("❌ CloudKit Export Error: \(error.localizedDescription)")
                EhMl3roOhVS0DDlA0Vm6u6E5TN5E1ukg = .B6guvQySqp61PhiS7GuVYZpS4DK79waY("Export failed")
                YbqAaxfU6LgNJtTvL72oR1DcJC39G6uw = false
            } else {
                print("📤 CloudKit Export Success: Datos enviados a iCloud")
                if YbqAaxfU6LgNJtTvL72oR1DcJC39G6uw {
                    EhMl3roOhVS0DDlA0Vm6u6E5TN5E1ukg = .Amqyy95vWgcOGxPe2gHNEvOb2gQuwTDe
                    n4yktK0CDVvoriTTb5hO06eZnGQhWtkO = Date()
                    B0o5q2YLovddpvaVRWfJ7WLqvDCoILe4 = 0 // Reset pending count on successful export
                    
                    // Continue syncing to check for imports
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.YbqAaxfU6LgNJtTvL72oR1DcJC39G6uw = false
                        
                        // Auto-hide success status after delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            if case .Amqyy95vWgcOGxPe2gHNEvOb2gQuwTDe = self.EhMl3roOhVS0DDlA0Vm6u6E5TN5E1ukg {
                                self.EhMl3roOhVS0DDlA0Vm6u6E5TN5E1ukg = .ELUzH9gG93YqDlAmcRtVcWsXBtvjxxUd
                            }
                        }
                    }
                }
            }
            
        case .setup:
            print("⚙️ CloudKit Setup: Configuración completada")
            
        @unknown default:
            print("❓ CloudKit Event desconocido: \(event.type)")
        }
    }
    
    // MARK: - Pending Sync Count Management
    private func zjucttRzZNROcMYVAu7NehOeGvBK69nQ(from notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext,
              context == FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext else { return }
        
        // Only count as pending if we're offline
        if !cCLo8pBGvFmDlgxAZEAVTmziJmQW21PK.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD {
            if let userInfo = notification.userInfo,
               let insertedObjects = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
                
                let workoutInserts = insertedObjects.compactMap { $0 as? WorkoutEntity }
                if !workoutInserts.isEmpty {
                    DispatchQueue.main.async {
                        self.B0o5q2YLovddpvaVRWfJ7WLqvDCoILe4 += workoutInserts.count
                        print("💾 Entrenamientos pendientes de sync: \(self.B0o5q2YLovddpvaVRWfJ7WLqvDCoILe4)")
                    }
                }
            }
        } else {
            // If we're online, successful saves mean sync is happening
            print("🔄 Guardado online - CloudKit sincronizará automáticamente")
        }
    }
    
    // MARK: - Manual Sync Trigger
    func SA1vew8Mon4LeBo9psBoNhEQZ6IDuzZt() {
        guard cCLo8pBGvFmDlgxAZEAVTmziJmQW21PK.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD else {
            print("❌ Sync manual: Sin conexión a internet")
            return
        }
        
        print("🔄 Sync manual iniciado por usuario")
        NViXNgXcM1zVt0cas0R7CHvbeKH6SWyM()
    }
    
    // MARK: - Offline Data Management
    func XBNtmJEXfOAj8OCqeTbHzegoSpck7eKC(type: String, duration: Int32, calories: Int32) -> Bool {
        let context = FU31nOsXzkAu3ssDTzwUVmAnypmtztob.viewContext
        
        let workout = WorkoutEntity(context: context)
        workout.id = UUID()
        workout.type = type
        workout.duration = duration
        workout.date = Date()
        workout.calories = calories
        
        do {
            try context.save()
            
            if cCLo8pBGvFmDlgxAZEAVTmziJmQW21PK.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD {
                print("🔄 Entrenamiento guardado y enviado a CloudKit: \(type)")
            } else {
                print("💾 Entrenamiento guardado offline: \(type)")
                print("📋 Se sincronizará cuando regrese la conexión")
                
                DispatchQueue.main.async {
                    self.B0o5q2YLovddpvaVRWfJ7WLqvDCoILe4 += 1
                }
            }
            
            return true
        } catch {
            print("❌ Error al guardar entrenamiento: \(error.localizedDescription)")
            return false
        }
    }
}

// MARK: - Sync Status Card UI
struct Rf9EmfwK66p5t78UXWHBzw52tpz7Fe6b: View {
    @ObservedObject var offlineManager = f44CM3JdBo3CztstNOncNr1s4UV8ejD1.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @ObservedObject var networkMonitor = T6BDbtv2u0anCAqwtryY4XMWEB6pm5mX.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Estado de Sincronización")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }
            
            HStack(spacing: 12) {
                // Status icon
                ZStack {
                    Circle()
                        .fill(statusColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    if offlineManager.YbqAaxfU6LgNJtTvL72oR1DcJC39G6uw {
                        ProgressView()
                            .scaleEffect(0.8)
                            .progressViewStyle(CircularProgressViewStyle(tint: statusColor))
                    } else {
                        Text(offlineManager.EhMl3roOhVS0DDlA0Vm6u6E5TN5E1ukg.i6rGNxQpdsotQeCmVcyhE5mg1Tqt59EB)
                            .font(.system(size: 18))
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(offlineManager.EhMl3roOhVS0DDlA0Vm6u6E5TN5E1ukg.W5TVRE97oSlHf67bpUXP80LgXeYzET6B)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    if offlineManager.B0o5q2YLovddpvaVRWfJ7WLqvDCoILe4 > 0 {
                        Text("\(offlineManager.B0o5q2YLovddpvaVRWfJ7WLqvDCoILe4) entrenamientos pendientes")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.orange)
                    }
                    
                    if let lastSync = offlineManager.n4yktK0CDVvoriTTb5hO06eZnGQhWtkO {
                        Text("Última sync: \(WPhHoE1PLwqQatnfUREd9LegNnFZKRjV(lastSync))")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                if networkMonitor.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD && !offlineManager.YbqAaxfU6LgNJtTvL72oR1DcJC39G6uw {
                    Button("Sincronizar") {
                        offlineManager.SA1vew8Mon4LeBo9psBoNhEQZ6IDuzZt()
                    }
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(statusColor.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var statusColor: Color {
        switch offlineManager.EhMl3roOhVS0DDlA0Vm6u6E5TN5E1ukg {
        case .ELUzH9gG93YqDlAmcRtVcWsXBtvjxxUd:
            return networkMonitor.AhYmo0aa4upmzmZOGClQFkcRsRJjIvLD ? .blue : .orange
        case .D5hTORJnjhceFYvUBxM64q7NBk0xnsBh:
            return .blue
        case .Amqyy95vWgcOGxPe2gHNEvOb2gQuwTDe:
            return .green
        case .B6guvQySqp61PhiS7GuVYZpS4DK79waY:
            return .red
        }
    }
    
    private func WPhHoE1PLwqQatnfUREd9LegNnFZKRjV(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
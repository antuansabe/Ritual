import SwiftUI
import CoreData
import CloudKit

// MARK: - CloudKit Test View
struct CloudKitTestView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.dismiss) private var dismiss
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)])
    private var workouts: FetchedResults<WorkoutEntity>
    
    @StateObject private var syncMonitor = CloudKitSyncMonitor(container: PersistenceController.shared.container)
    
    @State private var testResults: [String] = []
    @State private var isRunningTest = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    cloudKitStatusSection
                    testActionsSection
                    workoutDataSection
                    testResultsSection
                }
                .padding()
            }
            .navigationTitle("CloudKit Test")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            addTestResult("📱 Vista de testing CloudKit iniciada")
            syncMonitor.checkCloudKitAccountStatus()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "icloud.and.arrow.up.and.arrow.down")
                .font(.system(size: 48))
                .foregroundColor(.blue)
            
            Text("CloudKit Sync Test")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Prueba la sincronización de datos con iCloud")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.1))
        )
    }
    
    // MARK: - CloudKit Status Section
    private var cloudKitStatusSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Estado de CloudKit")
                .font(.headline)
                .fontWeight(.semibold)
            
            CloudKitSyncStatusView(container: PersistenceController.shared.container)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    // MARK: - Test Actions Section
    private var testActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Acciones de Testing")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                testButton(
                    title: "Verificar Cuenta iCloud",
                    icon: "person.icloud",
                    action: testCloudKitAccount
                )
                
                testButton(
                    title: "Crear Entrenamiento de Prueba",
                    icon: "plus.circle",
                    action: createTestWorkout
                )
                
                testButton(
                    title: "Forzar Sincronización",
                    icon: "arrow.triangle.2.circlepath",
                    action: forceSyncData
                )
                
                testButton(
                    title: "Verificar Datos Remotos",
                    icon: "icloud.and.arrow.down",
                    action: checkRemoteData
                )
                
                testButton(
                    title: "Limpiar Logs",
                    icon: "trash",
                    action: clearTestResults
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    // MARK: - Workout Data Section
    private var workoutDataSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Datos Locales (\(workouts.count) entrenamientos)")
                .font(.headline)
                .fontWeight(.semibold)
            
            if workouts.isEmpty {
                Text("No hay entrenamientos guardados")
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(workouts.prefix(5).enumerated()), id: \.element.objectID) { index, workout in
                        workoutRow(workout: workout, index: index + 1)
                    }
                    
                    if workouts.count > 5 {
                        Text("... y \(workouts.count - 5) más")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    // MARK: - Test Results Section
    private var testResultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Logs de Testing")
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(testResults.enumerated()), id: \.offset) { index, result in
                        Text(result)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(12)
                .background(Color.black.opacity(0.05))
                .cornerRadius(8)
            }
            .frame(maxHeight: 200)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    // MARK: - Helper Views
    private func testButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 20)
                Text(title)
                Spacer()
                if isRunningTest {
                    ProgressView()
                        .scaleEffect(0.7)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .disabled(isRunningTest)
    }
    
    private func workoutRow(workout: WorkoutEntity, index: Int) -> some View {
        HStack {
            Text("\(index).")
                .fontWeight(.medium)
                .frame(width: 20, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(workout.type ?? "Unknown")
                    .fontWeight(.medium)
                
                Text("\(workout.duration) min • \(workout.calories) kcal")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(formatDate(workout.date))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Test Actions
    private func testCloudKitAccount() {
        isRunningTest = true
        addTestResult("🔍 Verificando cuenta iCloud...")
        
        CKContainer.default().accountStatus { status, error in
            DispatchQueue.main.async {
                self.isRunningTest = false
                
                if let error = error {
                    self.addTestResult("❌ Error: \(error.localizedDescription)")
                    return
                }
                
                switch status {
                case .available:
                    self.addTestResult("✅ Cuenta iCloud disponible")
                case .noAccount:
                    self.addTestResult("❌ No hay cuenta iCloud configurada")
                case .restricted:
                    self.addTestResult("❌ Cuenta iCloud restringida")
                case .couldNotDetermine:
                    self.addTestResult("❌ No se pudo determinar estado iCloud")
                case .temporarilyUnavailable:
                    self.addTestResult("⚠️ iCloud temporalmente no disponible")
                @unknown default:
                    self.addTestResult("❓ Estado iCloud desconocido")
                }
            }
        }
    }
    
    private func createTestWorkout() {
        isRunningTest = true
        addTestResult("🏋️‍♂️ Creando entrenamiento de prueba...")
        
        let context = managedObjectContext
        let testWorkout = WorkoutEntity(context: context)
        testWorkout.id = UUID()
        testWorkout.type = "Test CloudKit"
        testWorkout.duration = Int16.random(in: 15...60)
        testWorkout.date = Date()
        testWorkout.calories = Int16(testWorkout.duration * 8)
        
        do {
            try context.save()
            addTestResult("✅ Entrenamiento de prueba creado")
            addTestResult("📤 Sincronización CloudKit iniciada automáticamente")
            isRunningTest = false
        } catch {
            addTestResult("❌ Error al crear entrenamiento: \(error.localizedDescription)")
            isRunningTest = false
        }
    }
    
    private func forceSyncData() {
        isRunningTest = true
        addTestResult("🔄 Forzando sincronización...")
        
        let context = managedObjectContext
        
        // Force save to trigger CloudKit sync
        do {
            try context.save()
            addTestResult("💾 Contexto guardado - sincronización iniciada")
            
            // Monitor sync using our sync monitor
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.syncMonitor.triggerManualSync()
                self.isRunningTest = false
                self.addTestResult("📡 Sincronización manual activada")
            }
        } catch {
            addTestResult("❌ Error al forzar sincronización: \(error.localizedDescription)")
            isRunningTest = false
        }
    }
    
    private func checkRemoteData() {
        isRunningTest = true
        addTestResult("☁️ Verificando datos remotos...")
        
        // This is a simplified check - in a real app you might query CloudKit directly
        let container = CKContainer.default()
        let database = container.privateCloudDatabase
        
        let query = CKQuery(recordType: "CD_WorkoutEntity", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        database.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                self.isRunningTest = false
                
                if let error = error {
                    self.addTestResult("❌ Error consultando CloudKit: \(error.localizedDescription)")
                    return
                }
                
                let recordCount = records?.count ?? 0
                self.addTestResult("☁️ Registros encontrados en CloudKit: \(recordCount)")
                
                if let records = records?.prefix(3) {
                    for (index, record) in records.enumerated() {
                        let type = record["CD_type"] as? String ?? "Unknown"
                        self.addTestResult("  \(index + 1). \(type)")
                    }
                }
            }
        }
    }
    
    private func clearTestResults() {
        testResults.removeAll()
        addTestResult("🧹 Logs limpiados")
    }
    
    // MARK: - Helper Methods
    private func addTestResult(_ message: String) {
        let timestamp = DateFormatter.timeFormatter.string(from: Date())
        testResults.append("[\(timestamp)] \(message)")
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "No date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }()
}

// MARK: - Preview
#Preview {
    CloudKitTestView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
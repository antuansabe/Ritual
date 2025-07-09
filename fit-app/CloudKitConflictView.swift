import SwiftUI
import CoreData

// MARK: - CloudKit Conflict Monitoring View
struct CloudKitConflictView: View {
    // @ObservedObject var conflictMonitor = PersistenceController.conflictMonitor // Temporarily disabled
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    Text("CloudKit Conflict Monitor")
                        .font(.title2)
                        .padding()
                    
                    Text("Función de monitoreo avanzado en desarrollo")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                    
                    Text("Esta vista mostrará conflictos de sincronización CloudKit cuando esté completamente implementada.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding()
            }
            .navigationTitle("CloudKit Monitor")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "icloud.and.arrow.up.and.arrow.down")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("CloudKit Conflict Monitor")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Monitoreo avanzado de sincronización y conflictos")
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
    
    private var statusOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Estado General")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 20) {
                StatusIndicator(
                    icon: "exclamationmark.triangle.fill",
                    value: "\(conflictMonitor.conflicts.count)",
                    label: "Conflictos",
                    color: conflictMonitor.conflicts.isEmpty ? .green : .red
                )
                
                StatusIndicator(
                    icon: "arrow.triangle.2.circlepath",
                    value: "\(conflictMonitor.syncEvents.count)",
                    label: "Eventos",
                    color: .blue
                )
                
                StatusIndicator(
                    icon: "wifi.exclamationmark",
                    value: "\(conflictMonitor.networkIssues.count)",
                    label: "Problemas",
                    color: conflictMonitor.networkIssues.isEmpty ? .green : .orange
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private var conflictsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("[U+1F525] Conflictos Detectados (\(conflictMonitor.conflicts.count))")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVStack(spacing: 12) {
                ForEach(conflictMonitor.conflicts.suffix(10)) { conflict in
                    ConflictCard(conflict: conflict)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.red.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var syncEventsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("[U+1F4CB] Eventos de Sincronización (\(conflictMonitor.syncEvents.count))")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVStack(spacing: 8) {
                ForEach(conflictMonitor.syncEvents.suffix(15)) { event in
                    SyncEventRow(event: event)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private var networkIssuesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("[U+1F4E1] Problemas de Red (\(conflictMonitor.networkIssues.count))")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVStack(spacing: 12) {
                ForEach(conflictMonitor.networkIssues.suffix(10)) { issue in
                    NetworkIssueCard(issue: issue)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.orange.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("[U+1F527] Acciones de Debugging")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                Button(action: {
                    // Generate conflict report
                    let report = conflictMonitor.generateConflictReport()
                    print(report)
                }) {
                    HStack {
                        Image(systemName: "doc.text")
                        Text("Generar Reporte Completo")
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Button(action: {
                    conflictMonitor.clearAllEvents()
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Limpiar Todos los Eventos")
                        Spacer()
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

// MARK: - Supporting Views

struct StatusIndicator: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.1))
        )
    }
}

struct ConflictCard: View {
    let conflict: CloudKitConflictMonitor.CloudKitConflict
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(conflict.conflictType.emoji)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(conflict.description)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(conflict.entityType)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(formatTime(conflict.timestamp))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Local:")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    Text(conflict.localData)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Remoto:")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                    Text(conflict.remoteData)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(4)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct SyncEventRow: View {
    let event: CloudKitConflictMonitor.SyncEvent
    
    var body: some View {
        HStack(spacing: 12) {
            Text(event.type.emoji)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(event.description)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if let details = event.details {
                    Text(details)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text(formatTime(event.timestamp))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(event.type.color.opacity(0.1))
        )
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct NetworkIssueCard: View {
    let issue: CloudKitConflictMonitor.NetworkIssue
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(issue.type.emoji)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(issue.description)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(formatTime(issue.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Sugerencia:")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                Text(issue.suggestion)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(4)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    CloudKitConflictView()
}
import SwiftUI

struct TaskDetailView: View {
    
    let task: Task
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 10, height: 10)
                    Text(statusText)
                        .font(.subheadline)
                        .foregroundStyle(statusColor)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Firma")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(task.companyName)
                        .font(.title2)
                        .bold()
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Adres")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Label(task.address, systemImage: "mappin.circle.fill")
                        .font(.body)
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Arıza Açıklaması")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(task.description)
                        .font(.body)
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Oluşturulma Tarihi")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(task.createdAt.formatted(date: .long, time: .shortened))
                        .font(.body)
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .navigationTitle(task.title)
        .navigationBarTitleDisplayMode(.large)
    }
    
    var statusColor: Color {
        switch task.status {
        case .bekliyor: return .orange
        case .devamEdiyor: return .blue
        case .tamamlandi: return .green
        }
    }
    
    var statusText: String {
        switch task.status {
        case .bekliyor: return "Bekliyor"
        case .devamEdiyor: return "Devam Ediyor"
        case .tamamlandi: return "Tamamlandı"
        }
    }
}

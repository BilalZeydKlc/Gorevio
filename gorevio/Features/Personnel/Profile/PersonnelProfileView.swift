import SwiftUI

struct PersonnelProfileView: View {
    
    let completedTasks = MockData.tasks.filter { $0.status == .tamamlandi }.count
    let activeTasks = MockData.tasks.filter { $0.status == .devamEdiyor }.count
    let pendingTasks = MockData.tasks.filter { $0.status == .bekliyor }.count
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.accent.opacity(0.15))
                                .frame(width: 90, height: 90)
                            Text("B")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(Color.accent)
                        }
                        
                        Text("Bilal Zeyd Kılıç")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(Color.primaryText)
                        
                        Text("bilal@gorevio.com")
                            .font(.subheadline)
                            .foregroundStyle(Color.secondaryText)
                    }
                    .padding(.top)
                    
                    HStack(spacing: 16) {
                        StatCardView(count: completedTasks, title: "Tamamlanan", color: .green)
                        StatCardView(count: activeTasks, title: "Devam Eden", color: .blue)
                        StatCardView(count: pendingTasks, title: "Bekleyen", color: .orange)
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        ProfileRowView(icon: "person.fill", title: "Ad Soyad", value: "Bilal Zeyd Kılıç")
                        Divider().padding(.leading, 52)
                        ProfileRowView(icon: "envelope.fill", title: "Email", value: "bilal@gorevio.com")
                        Divider().padding(.leading, 52)
                        ProfileRowView(icon: "briefcase.fill", title: "Rol", value: "Personel")
                    }
                    .background(Color.cardBackground)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    Button {
                    } label: {
                        Text("Çıkış Yap")
                            .font(.body)
                            .bold()
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.cardBackground)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profil")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.primaryText)
                }
            }
        }
    }
}

struct StatCardView: View {
    let count: Int
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(count)")
                .font(.title)
                .bold()
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(Color.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.cardBackground)
        .cornerRadius(16)
    }
}

struct ProfileRowView: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundStyle(Color.accent)
                .frame(width: 20)
                .padding(.leading, 16)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(Color.secondaryText)
                Text(value)
                    .font(.body)
                    .foregroundStyle(Color.primaryText)
            }
            Spacer()
        }
        .padding(.vertical, 12)
    }
}

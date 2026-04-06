//
//  PersonnelProfileView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import SwiftUI

struct PersonnelProfileView: View {
    
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var taskService: TaskService
    
    // Tamamlanan işlerin sayısı
    var completedTasks: Int {
        taskService.tasks.filter { $0.status == "tamamlandi" }.count
    }
    
    // Devam eden işlerin sayısı (Backend 'bekliyor' gönderdiği için her ikisini de sayıyoruz)
    var activeTasks: Int {
        taskService.tasks.filter { $0.status == "devamEdiyor" || $0.status == "bekliyor" }.count
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Profil Üst Kısım
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.accent.opacity(0.15))
                                .frame(width: 90, height: 90)
                            Text(String(authService.currentUser?.name.prefix(1) ?? "?"))
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(Color.accent)
                        }
                        
                        Text(authService.currentUser?.name ?? "")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(Color.primaryText)
                        
                        Text(authService.currentUser?.email ?? "")
                            .font(.subheadline)
                            .foregroundStyle(Color.secondaryText)
                    }
                    .padding(.top)
                    
                    // MARK: - İstatistik Kartları
                    HStack(spacing: 16) {
                        StatCardView(count: activeTasks, title: "Devam Eden", color: .blue)
                        StatCardView(count: completedTasks, title: "Tamamlanan", color: .green)
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Kullanıcı Bilgileri Listesi
                    VStack(spacing: 0) {
                        ProfileRowView(icon: "person.fill", title: "Ad Soyad", value: authService.currentUser?.name ?? "")
                        Divider().padding(.leading, 52)
                        ProfileRowView(icon: "envelope.fill", title: "Email", value: authService.currentUser?.email ?? "")
                        Divider().padding(.leading, 52)
                        ProfileRowView(icon: "briefcase.fill", title: "Rol", value: "Personel")
                    }
                    .background(Color.cardBackground)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // MARK: - Çıkış Butonu
                    Button {
                        authService.logout()
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

#Preview {
    PersonnelProfileView()
        .environmentObject(AuthService.shared)
        .environmentObject(TaskService.shared)
}

//
//  AdminProfileView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 23.03.2026.
//

import SwiftUI

struct AdminProfileView: View {
    
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var taskService: TaskService
    @EnvironmentObject var personnelService: PersonnelService
    
    var totalTasks: Int { taskService.tasks.count }
    var completedTasks: Int { taskService.tasks.filter { $0.status == "tamamlandi" }.count }
    var personnelCount: Int { personnelService.personnelList.filter { $0.role == "personel" }.count }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 24) {
                        
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.accent.opacity(0.15))
                                    .frame(width: 90, height: 90)
                                Text(String(authService.currentUser?.name.prefix(1) ?? "Y"))
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundStyle(Color.accent)
                            }
                            
                            Text(authService.currentUser?.name ?? "Yönetici")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(Color.primaryText)
                            
                            Text(authService.currentUser?.email ?? "")
                                .font(.subheadline)
                                .foregroundStyle(Color.secondaryText)
                        }
                        .padding(.top)
                        
                        HStack(spacing: 16) {
                            StatCardView(count: totalTasks, title: "Toplam İş", color: .blue)
                            StatCardView(count: completedTasks, title: "Tamamlanan", color: .green)
                            StatCardView(count: personnelCount, title: "Personel", color: .orange)
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            ProfileRowView(icon: "person.fill", title: "Ad Soyad", value: authService.currentUser?.name ?? "")
                            Divider().padding(.leading, 52)
                            ProfileRowView(icon: "envelope.fill", title: "Email", value: authService.currentUser?.email ?? "")
                            Divider().padding(.leading, 52)
                            ProfileRowView(icon: "briefcase.fill", title: "Rol", value: "Yönetici")
                        }
                        .background(Color.cardBackground)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
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
                        
                        Spacer(minLength: 30) // İmza için boşluk bırak
                        
                        // MARK: - Footer (Sayfa Altı İmza)
                        VStack(spacing: 4) {
                            Text("Created By: Bilal Zeyd Kılıç")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            Text("Versiyon: \(Bundle.main.releaseVersionNumber ?? "1.0").\(Bundle.main.buildVersionNumber ?? "0")")
                                .font(.caption2)
                                .foregroundColor(.secondary.opacity(0.8))
                        }
                        .padding(.bottom, 20)
                        
                    }
                    .frame(minHeight: geometry.size.height) // Ekran yüksekliğini doldur
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

//
//  PersonnelHomeView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import SwiftUI

struct PersonnelHomeView: View {
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var taskService: TaskService
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Merhaba, \(authService.currentUser?.name.components(separatedBy: " ").first ?? "") 👋")
                        .font(.largeTitle).bold().foregroundStyle(Color.primaryText).padding(.horizontal)
                    
                    if !devamEdenTasks.isEmpty {
                        Text("Mevcut İşlerin")
                            .font(.title2).bold().foregroundStyle(Color.primaryText).padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            ForEach(devamEdenTasks) { task in
                                NavigationLink(destination: TaskDetailView(task: task)) {
                                    BigTaskCardView(task: task)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 48)).foregroundStyle(Color.secondaryText)
                            Text("Şu an atanmış görevin yok 🎉")
                                .font(.subheadline).foregroundStyle(Color.secondaryText)
                        }
                        .frame(maxWidth: .infinity).padding(.top, 40)
                    }
                }
                .padding(.top)
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) { Text("GöreviO").bold() }
            }
            .task {
                if let userId = authService.currentUser?.id {
                    try? await taskService.fetchPersonnelTasks(personnelId: userId)
                }
            }
        }
    }
    
    var devamEdenTasks: [APITask] {
        // Backend 'bekliyor' kaydetse bile biz devam eden iş sayıyoruz
        taskService.tasks.filter { $0.status == "devamEdiyor" || $0.status == "bekliyor" }
    }
}

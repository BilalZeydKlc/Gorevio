//
//  AdminHomeView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 23.03.2026.
//

import SwiftUI

struct AdminHomeView: View {
    
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var taskService: TaskService
    
    // "bekliyor" ve "devamEdiyor" durumlarını birleştirdik
    var activeTasks: Int { taskService.tasks.filter { $0.status == "devamEdiyor" || $0.status == "bekliyor" }.count }
    var completedTasks: Int { taskService.tasks.filter { $0.status == "tamamlandi" }.count }
    var totalTasks: Int { taskService.tasks.count }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Hoş Geldin, \(authService.currentUser?.name.components(separatedBy: " ").first ?? "") 👋")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color.primaryText)
                        .padding(.horizontal)
                    
                    Text("Genel Durum")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.primaryText)
                        .padding(.horizontal)
                    
                    HStack(spacing: 12) {
                        StatCardView(count: totalTasks, title: "Toplam", color: .purple)
                        StatCardView(count: activeTasks, title: "Devam Eden", color: .blue)
                        StatCardView(count: completedTasks, title: "Tamamlanan", color: .green)
                    }
                    .padding(.horizontal)
                    
                    Text("Son İşler")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.primaryText)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ForEach(taskService.tasks.prefix(3)) { task in
                            // ÇÖZÜM BURADA: Kartı tıklanabilir bir NavigationLink içine aldık
                            NavigationLink(destination: TaskDetailView(task: task)) {
                                TaskRowView(task: task)
                            }
                            .buttonStyle(.plain) // Tıklanabilir olunca yazıların maviye dönmesini engeller
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("GöreviO")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.primaryText)
                }
            })
            .task {
                try? await taskService.fetchAllTasks()
            }
        }
    }
}

#Preview {
    AdminHomeView()
        .environmentObject(AuthService.shared)
        .environmentObject(TaskService.shared)
}

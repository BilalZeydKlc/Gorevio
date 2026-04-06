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
    
    var completedTasks: Int { taskService.tasks.filter { $0.status == "tamamlandi" }.count }
    var activeTasks: Int { taskService.tasks.filter { $0.status == "devamEdiyor" }.count }
    var pendingTasks: Int { taskService.tasks.filter { $0.status == "bekliyor" }.count }
    
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
                        StatCardView(count: activeTasks, title: "Devam Eden", color: .blue)
                        StatCardView(count: pendingTasks, title: "Bekleyen", color: .orange)
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
                            TaskRowView(task: task)
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

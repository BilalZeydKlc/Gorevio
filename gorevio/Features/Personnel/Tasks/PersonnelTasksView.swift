//
//  PersonnelTasksView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import SwiftUI

struct PersonnelTasksView: View {
    @EnvironmentObject var taskService: TaskService
    @EnvironmentObject var authService: AuthService
    @State private var selectedTab = 1
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $selectedTab) {
                    Text("Devam Ediyor").tag(1)
                    Text("Tamamlandı").tag(2)
                }
                .pickerStyle(.segmented).padding()
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredTasks) { task in
                            NavigationLink(destination: TaskDetailView(task: task)) {
                                TaskRowView(task: task)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        if filteredTasks.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: emptyIcon)
                                    .font(.system(size: 48)).foregroundStyle(Color.secondaryText)
                                Text(emptyMessage).font(.subheadline).foregroundStyle(Color.secondaryText)
                            }
                            .padding(.top, 60)
                        }
                    }
                    .padding(.horizontal).padding(.top, 8)
                }
                .refreshable { await loadTasks() }
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) { Text("İşlerim").bold() }
            }
        }
        .task { await loadTasks() }
    }
    
    var filteredTasks: [APITask] {
        if selectedTab == 1 {
            return taskService.tasks.filter { $0.status == "devamEdiyor" || $0.status == "bekliyor" }
        } else {
            return taskService.tasks.filter { $0.status == "tamamlandi" }
        }
    }
    
    var emptyIcon: String { selectedTab == 1 ? "briefcase" : "checkmark.circle" }
    var emptyMessage: String { selectedTab == 1 ? "Aktif iş yok" : "Tamamlanan iş yok" }
    
    private func loadTasks() async {
        guard let personnelId = authService.currentUser?.id else { return }
        try? await taskService.fetchPersonnelTasks(personnelId: personnelId)
    }
}

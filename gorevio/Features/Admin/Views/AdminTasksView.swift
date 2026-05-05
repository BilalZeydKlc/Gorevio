//  AdminTasksView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 23.03.2026.
//

import SwiftUI

struct AdminTasksView: View {
    @EnvironmentObject var taskService: TaskService
    @EnvironmentObject var companyService: CompanyService
    @EnvironmentObject var personnelService: PersonnelService
    @State private var showNewTask = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    // Mevcut tüm görevler
                    ForEach(taskService.tasks) { task in
                        TaskRowView(task: task)
                    }
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Görevler")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.primaryText)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewTask = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.accent)
                    }
                }
            }
            // Yeni görev ekleme sheet açılır
            .sheet(isPresented: $showNewTask) {
                AdminNewTaskView()
                    .environmentObject(taskService)
                    .environmentObject(companyService)
                    .environmentObject(personnelService)
            }
            .task {
                try? await taskService.fetchAllTasks()
            }
        }
    }
}

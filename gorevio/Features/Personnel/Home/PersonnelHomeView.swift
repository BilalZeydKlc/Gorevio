//
//  PersonnelHomeView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import SwiftUI
import Combine

struct PersonnelHomeView: View {
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var taskService: TaskService
    @State private var showNotifications = false
    
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
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
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNotifications = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell.fill")
                                .font(.title3)
                                .foregroundStyle(Color.accent)
                            
                            if !devamEdenTasks.isEmpty {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 10, height: 10)
                                    .offset(x: 2, y: -2)
                            }
                        }
                    }
                }
            }
            .alert("Bildirim Merkezi 🔔", isPresented: $showNotifications) {
                Button("Anladım", role: .cancel) { }
            } message: {
                if let sonIs = devamEdenTasks.first {
                    Text("Yeni bir görev kaydınız var:\n\n📍 \(sonIs.companyName)\n🛠 \(sonIs.title)\n\nDetaylar için görev listesine göz atın.")
                } else {
                    Text("Şu an okunmamış bir bildiriminiz bulunmuyor.")
                }
            }
            .onReceive(timer) { _ in
                // ÇAKIŞMAYI ÖNLEYEN KRİTİK DEĞİŞİKLİK: _Concurrency.Task
                _Concurrency.Task {
                    if let userId = authService.currentUser?.id {
                        try? await taskService.fetchPersonnelTasks(personnelId: userId)
                    }
                }
            }
            .task {
                if let userId = authService.currentUser?.id {
                    try? await taskService.fetchPersonnelTasks(personnelId: userId)
                }
            }
        }
    }
    
    var devamEdenTasks: [APITask] {
        taskService.tasks.filter { $0.status == "devamEdiyor" || $0.status == "bekliyor" }
    }
}

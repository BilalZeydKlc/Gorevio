//
//  AdminPersonnelView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 23.03.2026.
//

import SwiftUI

struct AdminPersonnelView: View {
    @EnvironmentObject var personnelService: PersonnelService
    @EnvironmentObject var taskService: TaskService
    @State private var showNewPersonnel = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(personnelService.personnelList) { personnel in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(personnel.name)
                                .font(.headline)
                                .foregroundStyle(Color.primaryText)
                            Text(personnel.email)
                                .font(.subheadline)
                                .foregroundStyle(Color.secondaryText)
                        }
                        
                        Spacer()
                        
                        // SADELEŞTİRİLMİŞ SAĞ TARAF (Sadece İş Durumu veya Yönetici Rozeti)
                        if personnel.role == "admin" {
                            Text("Yönetici")
                                .font(.caption)
                                .bold()
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.accent.opacity(0.15))
                                .foregroundStyle(Color.accent)
                                .cornerRadius(8)
                        } else {
                            let aktifIsSayisi = getActiveTaskCount(for: personnel.id)
                            
                            if aktifIsSayisi > 0 {
                                Text("\(aktifIsSayisi) Aktif İş")
                                    .font(.caption)
                                    .bold()
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.orange.opacity(0.15))
                                    .foregroundStyle(Color.orange)
                                    .cornerRadius(8)
                            } else {
                                Text("Müsait")
                                    .font(.caption)
                                    .bold()
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.15))
                                    .foregroundStyle(Color.green)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deletePersonnel)
            }
            .listStyle(.plain)
            .background(Color.appBackground)
            .navigationTitle("Personeller")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewPersonnel = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.accent)
                    }
                }
            }
            .sheet(isPresented: $showNewPersonnel) {
                AdminNewPersonnelView()
                    .environmentObject(personnelService)
            }
            .task {
                try? await personnelService.fetchPersonnel()
                try? await taskService.fetchAllTasks()
            }
        }
    }
    
    // HESAPLAMA YÜKÜNÜ BURAYA ALDIK
    private func getActiveTaskCount(for personnelId: String) -> Int {
        return taskService.tasks.filter { $0.assignedTo.id == personnelId && $0.status != "tamamlandi" }.count
    }
    
    private func deletePersonnel(at offsets: IndexSet) {
        let idsToDelete = offsets.map { personnelService.personnelList[$0].id }
        personnelService.personnelList.remove(atOffsets: offsets)
        
        for id in idsToDelete {
            _Concurrency.Task {
                try? await personnelService.deletePersonnel(id: id)
            }
        }
    }
}

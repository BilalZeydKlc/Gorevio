//
//  TaskDetailView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import SwiftUI

struct TaskDetailView: View {
    
    let task: APITask
    @EnvironmentObject var taskService: TaskService
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Durum
                HStack {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 10, height: 10)
                    Text(statusText)
                        .font(.subheadline)
                        .foregroundStyle(statusColor)
                }
                .padding(.horizontal)
                
                // MARK: - Firma
                VStack(alignment: .leading, spacing: 8) {
                    Text("Firma")
                        .font(.caption)
                        .foregroundStyle(Color.secondaryText)
                    Text(task.companyName)
                        .font(.title2)
                        .bold()
                }
                .padding(.horizontal)
                
                Divider()
                
                // MARK: - Adres
                VStack(alignment: .leading, spacing: 8) {
                    Text("Adres")
                        .font(.caption)
                        .foregroundStyle(Color.secondaryText)
                    Label(task.address, systemImage: "mappin.circle.fill")
                        .font(.body)
                }
                .padding(.horizontal)
                
                Divider()
                
                // MARK: - Arıza
                VStack(alignment: .leading, spacing: 8) {
                    Text("Arıza Açıklaması")
                        .font(.caption)
                        .foregroundStyle(Color.secondaryText)
                    Text(task.description)
                        .font(.body)
                }
                .padding(.horizontal)
                
                Divider()
                
                // MARK: - Tarih
                VStack(alignment: .leading, spacing: 8) {
                    Text("Oluşturulma Tarihi")
                        .font(.caption)
                        .foregroundStyle(Color.secondaryText)
                    Text(task.createdAt)
                        .font(.body)
                }
                .padding(.horizontal)
                
                // MARK: - Tamamla Butonu
                if task.status != "tamamlandi" {
                    Button {
                        showAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Tamamlandı Olarak İşaretle")
                                .bold()
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(14)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                } else {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Tamamlandı")
                            .bold()
                    }
                    .foregroundStyle(.green)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.12))
                    .cornerRadius(14)
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            }
            .padding(.top)
        }
        .background(Color.appBackground)
        .navigationTitle(task.title)
        .navigationBarTitleDisplayMode(.large)
        .alert("Görevi tamamla", isPresented: $showAlert) {
            Button("İptal", role: .cancel) {}
            Button("Tamamlandı") {
                _Concurrency.Task {
                    try? await taskService.completeTask(taskId: task.id)
                    dismiss()
                }
            }
        } message: {
            Text("Bu görevi tamamlandı olarak işaretlemek istediğinize emin misiniz?")
        }
    }
    
    var statusColor: Color {
        switch task.status {
        case "bekliyor", "devamEdiyor": return .blue // İkisi de mavi oldu
        case "tamamlandi": return .green
        default: return .gray
        }
    }
    
    var statusText: String {
        switch task.status {
        case "bekliyor", "devamEdiyor": return "Devam Ediyor" // İkisi de Devam Ediyor yazacak
        case "tamamlandi": return "Tamamlandı"
        default: return "Bilinmiyor"
        }
    }
}

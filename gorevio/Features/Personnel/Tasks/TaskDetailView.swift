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
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Durum Göstergesi
                HStack {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 10, height: 10)
                    Text(statusText)
                        .font(.subheadline)
                        .foregroundStyle(statusColor)
                }
                .padding(.horizontal)
                
                // Firma Bilgisi
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
                
                // Adres Bilgisi
                VStack(alignment: .leading, spacing: 8) {
                    Text("Adres")
                        .font(.caption)
                        .foregroundStyle(Color.secondaryText)
                    Label(task.address, systemImage: "mappin.circle.fill")
                        .font(.body)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Arıza Açıklaması
                VStack(alignment: .leading, spacing: 8) {
                    Text("Arıza Açıklaması")
                        .font(.caption)
                        .foregroundStyle(Color.secondaryText)
                    Text(task.description)
                        .font(.body)
                }
                .padding(.horizontal)
                
                // Atanan PersoneL
                if authService.currentUser?.role != "personel" {
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Atanan Personel")
                            .font(.caption)
                            .foregroundStyle(Color.secondaryText)
                        
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.title3)
                                .foregroundStyle(Color.accent)
                            
                            Text(task.assignedTo.name)
                                .font(.body)
                                .bold()
                                .foregroundStyle(Color.primaryText)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                
                // Oluşturulma Tarihi (Formatlanmış hali)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Oluşturulma Tarihi")
                        .font(.caption)
                        .foregroundStyle(Color.secondaryText)
                    
                    Text(formatDate(task.createdAt))
                        .font(.body)
                }
                .padding(.horizontal)
                
                // Buton Alanı
                if task.status != "tamamlandi" {
                    // Sadece personelse butonu gösteriyoruz
                    if authService.currentUser?.role == "personel" {
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
                    }
                } else {
                    // İş tamamlandıysa herkese yeşil göster
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
    
    // Yardımcı Fonksiyonlar
    
    var statusColor: Color {
        switch task.status {
        case "bekliyor", "devamEdiyor": return .blue
        case "tamamlandi": return .green
        default: return .gray
        }
    }
    
    var statusText: String {
        switch task.status {
        case "bekliyor", "devamEdiyor": return "Devam Ediyor"
        case "tamamlandi": return "Tamamlandı"
        default: return "Bilinmiyor"
        }
    }
    
    // Tarih Formatlayıcı
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "dd MMMM yyyy, HH:mm"
            displayFormatter.locale = Locale(identifier: "tr_TR")
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}

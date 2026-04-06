//
//  AdminNewTaskView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 23.03.2026.
//

import SwiftUI

struct AdminNewTaskView: View {
    @EnvironmentObject var taskService: TaskService
    @EnvironmentObject var companyService: CompanyService
    @EnvironmentObject var personnelService: PersonnelService
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var selectedCompany: APICompany? = nil
    @State private var description = ""
    @State private var selectedPersonnel: APIPersonnel? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 12) {
                        InputFieldView(title: "Görev Başlığı", placeholder: "Örn: Arıza", text: $title)
                        InputFieldView(title: "Açıklama", placeholder: "Detay yazın...", text: $description)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Firma Seç").font(.caption).padding(.horizontal)
                        VStack(spacing: 0) {
                            ForEach(companyService.companies) { company in
                                HStack {
                                    Text(company.firmaAdi)
                                    Spacer()
                                    if selectedCompany?.id == company.id { Image(systemName: "checkmark.circle.fill") }
                                }
                                .padding().background(Color.cardBackground)
                                .onTapGesture { selectedCompany = company }
                            }
                        }
                        .cornerRadius(16).padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Personel Seç").font(.caption).padding(.horizontal)
                        VStack(spacing: 0) {
                            ForEach(personnelService.personnelList.filter { $0.role == "personel" }) { personnel in
                                HStack {
                                    Text(personnel.name)
                                    Spacer()
                                    if selectedPersonnel?.id == personnel.id { Image(systemName: "checkmark.circle.fill") }
                                }
                                .padding().background(Color.cardBackground)
                                .onTapGesture { selectedPersonnel = personnel }
                            }
                        }
                        .cornerRadius(16).padding(.horizontal)
                    }
                    
                    Button {
                        _Concurrency.Task { await addTask() }
                    } label: {
                        Text("Görevi Ata").bold().foregroundStyle(.white).frame(maxWidth: .infinity).padding().background(isFormValid ? Color.accent : Color.gray).cornerRadius(16)
                    }
                    .disabled(!isFormValid).padding(.horizontal)
                }
            }
            .toolbar { ToolbarItem(placement: .principal) { Text("Yeni Görev").bold() } }
            // İŞTE UNUTTUĞUM VE SENİ ÇILDIRTAN KISIM BURASIYDI:
            .task {
                try? await companyService.fetchCompanies()
                try? await personnelService.fetchPersonnel()
            }
        }
    }
    
    var isFormValid: Bool { !title.isEmpty && !description.isEmpty && selectedCompany != nil && selectedPersonnel != nil }
    
    func addTask() async {
        guard let company = selectedCompany, let personnel = selectedPersonnel else { return }
        let newTask = NewTaskRequest(
            title: title, companyName: company.firmaAdi, address: company.adres,
            description: description, assignedTo: personnel.id, status: "devamEdiyor"
        )
        try? await taskService.createTask(task: newTask)
        dismiss()
    }
}

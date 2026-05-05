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
    @State private var description = ""
    @State private var selectedCompany: APICompany? = nil
    @State private var selectedPersonnel: APIPersonnel? = nil
    
    // ARAMA ÇUBUĞU İÇİN YENİ STATE'LER
    @State private var companySearchText = ""
    @State private var personnelSearchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 12) {
                        InputFieldView(title: "Görev Başlığı", placeholder: "Örn: Arıza", text: $title)
                        InputFieldView(title: "Açıklama", placeholder: "Detay yazın...", text: $description)
                    }
                    .padding(.horizontal)
                    
                    // FİRMA SEÇİMİ VE ARAMA
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Firma Seç").font(.caption).bold() .padding(.horizontal)
                        
                        // Firma Arama Çubuğu
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundColor(.gray)
                            TextField("Firma ara...", text: $companySearchText)
                        }
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        
                        // Firma Listesi
                        LazyVStack(spacing: 0) {
                            ForEach(filteredCompanies) { company in
                                HStack {
                                    Text(company.firmaAdi)
                                    Spacer()
                                    if selectedCompany?.id == company.id { Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.accent) }
                                }
                                .padding()
                                .background(Color.cardBackground)
                                .onTapGesture {
                                    selectedCompany = company
                                    // Seçim yapılınca klavyeyi kapatılması için gerekli metdod
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                            }
                        }
                        .cornerRadius(16).padding(.horizontal)
                    }
                    
                    // MARK: - PERSONEL SEÇİMİ VE ARAMA
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Personel Seç").font(.caption).bold() .padding(.horizontal)
                        
                        // Personel Arama Çubuğu
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundColor(.gray)
                            TextField("Personel ara...", text: $personnelSearchText)
                        }
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        
                        // Personel Listesi (Performans için LazyVStack yapıldı)
                        LazyVStack(spacing: 0) {
                            ForEach(filteredPersonnel) { personnel in
                                HStack {
                                    Text(personnel.name)
                                    Spacer()
                                    if selectedPersonnel?.id == personnel.id { Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.accent) }
                                }
                                .padding()
                                .background(Color.cardBackground)
                                .onTapGesture {
                                    selectedPersonnel = personnel
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                            }
                        }
                        .cornerRadius(16).padding(.horizontal)
                    }
                    
                    Button {
                        _Concurrency.Task { await addTask() }
                    } label: {
                        Text("Görevi Ata")
                            .bold()
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.accent : Color.gray)
                            .cornerRadius(16)
                    }
                    .disabled(!isFormValid).padding(.horizontal)
                }
                .padding(.bottom, 20) // Alt kısımda biraz boşluk bıraktık
            }
            .toolbar { ToolbarItem(placement: .principal) { Text("Yeni Görev").bold() } }
            .task {
                try? await companyService.fetchCompanies()
                try? await personnelService.fetchPersonnel()
            }
        }
    }
    
    // MARK: - HESAPLANMIŞ ÖZELLİKLER (FİLTRELEME MANTIĞI)
    
    var isFormValid: Bool { !title.isEmpty && !description.isEmpty && selectedCompany != nil && selectedPersonnel != nil }
    
    // Arama metnine göre filtrelenmiş şirketler
    var filteredCompanies: [APICompany] {
        if companySearchText.isEmpty {
            return companyService.companies
        } else {
            return companyService.companies.filter { $0.firmaAdi.localizedCaseInsensitiveContains(companySearchText) }
        }
    }
    
    // Arama metnine göre filtrelenmiş personeller
    var filteredPersonnel: [APIPersonnel] {
        let baseList = personnelService.personnelList.filter { $0.role == "personel" }
        if personnelSearchText.isEmpty {
            return baseList
        } else {
            return baseList.filter { $0.name.localizedCaseInsensitiveContains(personnelSearchText) }
        }
    }
    
    // MARK: - FONKSİYONLAR
    
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

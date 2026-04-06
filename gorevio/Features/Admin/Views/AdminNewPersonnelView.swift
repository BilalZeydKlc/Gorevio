//
//  AdminNewPersonnelView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 23.03.2026.
//

import SwiftUI

struct AdminNewPersonnelView: View {
    
    @EnvironmentObject var personnelService: PersonnelService
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // MARK: - Avatar Preview
                    ZStack {
                        Circle()
                            .fill(Color.accent.opacity(0.15))
                            .frame(width: 80, height: 80)
                        Text(name.isEmpty ? "?" : String(name.prefix(1)).uppercased())
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(Color.accent)
                    }
                    .padding(.top)
                    
                    // MARK: - Form
                    VStack(spacing: 12) {
                        InputFieldView(title: "Ad Soyad", placeholder: "Örn: Ahmet Yılmaz", text: $name)
                        InputFieldView(title: "E-Posta", placeholder: "ornek@gorevio.com", text: $email)
                        InputFieldView(title: "Şifre", placeholder: "••••••••", text: $password)
                        InputFieldView(title: "Şifre Tekrar", placeholder: "••••••••", text: $confirmPassword)
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Hata
                    if showError {
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundStyle(.red)
                            .padding(.horizontal)
                    }
                    
                    // MARK: - Kaydet Butonu
                    Button {
                        _Concurrency.Task { await addPersonnel() }
                    } label: {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accent)
                                .cornerRadius(16)
                        } else {
                            Text("Personel Ekle")
                                .font(.body)
                                .bold()
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isFormValid ? Color.accent : Color.secondaryText)
                                .cornerRadius(16)
                        }
                    }
                    .disabled(!isFormValid || isLoading)
                    .padding(.horizontal)
                }
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Yeni Personel")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.primaryText)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                    .foregroundStyle(.red)
                }
            }
        }
    }
    
    var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }
    
    func addPersonnel() async {
        guard password == confirmPassword else {
            errorMessage = "Şifreler eşleşmiyor!"
            showError = true
            return
        }
        
        guard email.contains("@") else {
            errorMessage = "Geçerli bir e-posta girin!"
            showError = true
            return
        }
        
        isLoading = true
        showError = false
        
        do {
            guard let adminId = authService.currentUser?.id else {
                errorMessage = "Yönetici bilgisi bulunamadı!"
                showError = true
                isLoading = false
                return
            }
            
            let request = NewPersonnelWithAdminRequest(
                name: name,
                email: email,
                password: password,
                adminId: adminId
            )
            try await personnelService.addPersonnelWithAdmin(personnel: request)
            dismiss()
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Personel eklenirken hata oluştu: \(error.localizedDescription)"
                self.showError = true
                self.isLoading = false
            }
        }
    }
}

#Preview {
    AdminNewPersonnelView()
}

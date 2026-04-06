//
//  LoginView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                // MARK: - Logo
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.accent.opacity(0.15))
                            .frame(width: 100, height: 100)
                        Text("G")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(Color.accent)
                    }
                    
                    Text("GöreviO")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color.primaryText)
                    
                    Text("Saha Servis Yönetim Uygulaması")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryText)
                }
                .padding(.top, 60)
                
                // MARK: - Form
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("E-Posta")
                            .font(.caption)
                            .foregroundStyle(Color.secondaryText)
                        TextField("ornek@gorevio.com", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.cardBackground)
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Şifre")
                            .font(.caption)
                            .foregroundStyle(Color.secondaryText)
                        SecureField("••••••••", text: $password)
                            .padding()
                            .background(Color.cardBackground)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Hata
                if showError {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }
                
                // MARK: - Giriş Butonu
                Button {
                    _Concurrency.Task { await login() }
                } label: {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accent)
                            .cornerRadius(16)
                    } else {
                        Text("Giriş Yap")
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
    }
    
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    func login() async {
        isLoading = true
        showError = false
        do {
            try await authService.login(email: email, password: password)
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "E-posta veya şifre hatalı!"
                self.showError = true
                self.isLoading = false
            }
        }
    }
}

//
//  AuthService.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import Foundation
import Combine

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var currentUser: APIUser?
    @Published var isLoggedIn = false
    @Published var isAdmin = false
    
    private init() {}
    
    func login(email: String, password: String) async throws {
        let body = LoginRequest(email: email, password: password)
        let user: APIUser = try await NetworkManager.shared.post(
            endpoint: "/api/auth/login",
            body: body
        )
        
        DispatchQueue.main.async {
            self.currentUser = user
            self.isAdmin = user.role == "admin"
            self.isLoggedIn = true
        }
    }
    
    func logout() {
        currentUser = nil
        isLoggedIn = false
        isAdmin = false
    }
}

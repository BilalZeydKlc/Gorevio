//
//  CompanyService.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 23.03.2026.
//

import Foundation
import Combine

class CompanyService: ObservableObject {
    static let shared = CompanyService()
    
    @Published var companies: [APICompany] = []
    @Published var isLoading = false
    
    private init() {}
    
    func fetchCompanies() async throws {
        DispatchQueue.main.async { self.isLoading = true }
        let companies: [APICompany] = try await NetworkManager.shared.get(endpoint: "/api/companies")
        DispatchQueue.main.async {
            self.companies = companies
            self.isLoading = false
        }
    }
}

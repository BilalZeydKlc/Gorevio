//
//  PersonnelService.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 23.03.2026.
//

import Foundation
import Combine

class PersonnelService: ObservableObject {
    static let shared = PersonnelService()
    
    @Published var personnelList: [APIPersonnel] = []
    @Published var isLoading = false
    
    private init() {}
    
    func fetchPersonnel() async throws {
        DispatchQueue.main.async { self.isLoading = true }
        let list: [APIPersonnel] = try await NetworkManager.shared.get(endpoint: "/api/personnel")
        
        DispatchQueue.main.async {
            // 1. Verileri çektikten sonra Türkçe karakterlere uygun A-Z sıralaması yapıyoruz
            self.personnelList = list.sorted {
                $0.name.localizedStandardCompare($1.name) == .orderedAscending
            }
            self.isLoading = false
        }
    }
    
    func addPersonnel(personnel: NewPersonnelRequest) async throws {
        // 1. Vercel'den gelen alt tiresiz 'id' yanıtını yeni modelle karşılıyoruz
        let response: NewPersonnelResponse = try await NetworkManager.shared.post(
            endpoint: "/api/personnel",
            body: personnel
        )
        
        // 2. Kendi sistemimizin beklediği APIPersonnel modeline çevirip listeye ekliyoruz
        DispatchQueue.main.async {
            let newPerson = APIPersonnel(id: response.id, name: response.name, email: response.email, role: response.role)
            self.personnelList.append(newPerson)
            
            // 3. Yeni kişi eklendikten sonra listeyi tekrar alfabetik olarak diziyoruz
            self.personnelList.sort {
                $0.name.localizedStandardCompare($1.name) == .orderedAscending
            }
        }
    }
    
    func addPersonnelWithAdmin(personnel: NewPersonnelWithAdminRequest) async throws {
        // Aynı şekilde Vercel'in alt tiresiz yanıtını karşılıyoruz
        let response: NewPersonnelResponse = try await NetworkManager.shared.post(
            endpoint: "/api/personnel",
            body: personnel
        )
        
        // Modele çevirip ekliyoruz
        DispatchQueue.main.async {
            let newPerson = APIPersonnel(id: response.id, name: response.name, email: response.email, role: response.role)
            self.personnelList.append(newPerson)
            
            // Yeni kişi eklendikten sonra listeyi tekrar alfabetik olarak diziyoruz
            self.personnelList.sort {
                $0.name.localizedStandardCompare($1.name) == .orderedAscending
            }
        }
    }
    
    func deletePersonnel(id: String) async throws {
        try await NetworkManager.shared.delete(endpoint: "/api/personnel/\(id)")
        
        DispatchQueue.main.async {
            self.personnelList.removeAll(where: { $0.id == id })
        }
    }
}

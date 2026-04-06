//
//  AdminTabView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 23.03.2026.
//

import SwiftUI

struct AdminTabView: View {
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var taskService: TaskService
    @EnvironmentObject var companyService: CompanyService
    @EnvironmentObject var personnelService: PersonnelService
    
    var body: some View {
        TabView {
            AdminHomeView()
                .tabItem {
                    Label("Ana Ekran", systemImage: "house.fill")
                }
            
            AdminPersonnelView()
                .tabItem {
                    Label("Personeller", systemImage: "person.2.fill")
                }
            
            AdminTasksView()
                .tabItem {
                    Label("Görevler", systemImage: "list.bullet.clipboard.fill")
                }
            
            AdminProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    AdminTabView()
        .environmentObject(AuthService.shared)
        .environmentObject(TaskService.shared)
        .environmentObject(CompanyService.shared)
        .environmentObject(PersonnelService.shared)
}

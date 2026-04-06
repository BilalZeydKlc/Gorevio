//
//  personnelTabView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import SwiftUI

struct PersonnelTabView: View {
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var taskService: TaskService
    
    var body: some View {
        TabView {
            PersonnelHomeView()
                .tabItem {
                    Label("Ana Ekran", systemImage: "house.fill")
                }
            
            PersonnelTasksView()
                .tabItem {
                    Label("İşlerim", systemImage: "list.bullet.clipboard.fill")
                }
            
            PersonnelProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
        }
    }
}

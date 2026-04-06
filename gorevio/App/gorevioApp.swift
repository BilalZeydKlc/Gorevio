//
//  gorevioApp.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import SwiftUI

@main
struct gorevioApp: App {
    @StateObject var authService = AuthService.shared
    @StateObject var taskService = TaskService.shared
    @StateObject var companyService = CompanyService.shared
    @StateObject var personnelService = PersonnelService.shared
    
    var body: some Scene {
        WindowGroup {
            if authService.isLoggedIn {
                if authService.isAdmin {
                    AdminTabView()
                        .environmentObject(authService)
                        .environmentObject(taskService)
                        .environmentObject(companyService)
                        .environmentObject(personnelService)
                } else {
                    PersonnelTabView()
                        .environmentObject(authService)
                        .environmentObject(taskService)
                }
            } else {
                LoginView()
                    .environmentObject(authService)
            }
        }
    }
}

//
//  gorevioApp.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import SwiftUI
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
}

@main
struct gorevioApp: App {
    @StateObject var authService = AuthService.shared
    @StateObject var taskService = TaskService.shared
    @StateObject var companyService = CompanyService.shared
    @StateObject var personnelService = PersonnelService.shared
    
    private let delegate = NotificationDelegate()
    
    init() {
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted { print("Bildirim izni verildi ✅") }
        }
        
        UNUserNotificationCenter.current().delegate = delegate
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
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
            .preferredColorScheme(.light)
        }
    }
}

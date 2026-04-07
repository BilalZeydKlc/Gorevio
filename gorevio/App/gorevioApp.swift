//
//  gorevioApp.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import SwiftUI
import UserNotifications

// 1. BU SINIF DIŞARIDA DURMALI: Uygulama açıkken bildirimi yukarıdan düşüren mekanizma
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Uygulama açık olsa bile banner (üstten düşen bildirim) ve ses gelsin
        completionHandler([.banner, .list, .sound])
    }
}

@main
struct gorevioApp: App {
    @StateObject var authService = AuthService.shared
    @StateObject var taskService = TaskService.shared
    @StateObject var companyService = CompanyService.shared
    @StateObject var personnelService = PersonnelService.shared
    
    // Delegate örneğini burada tutuyoruz
    private let delegate = NotificationDelegate()
    
    init() {
        // Bildirim izinlerini al
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted { print("Bildirim izni verildi ✅") }
        }
        
        // 2. KRİTİK NOKTA: iOS'a bu delegeyi mutlaka bildiriyoruz
        UNUserNotificationCenter.current().delegate = delegate
    }
    
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

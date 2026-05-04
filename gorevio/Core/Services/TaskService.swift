//
//  TaskService.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 23.03.2026.
//

import Foundation
import Combine
import UserNotifications

class TaskService: ObservableObject {
    static let shared = TaskService()
    
    @Published var tasks: [APITask] = []
    @Published var isLoading = false
    
    private init() {}
    
    // Tüm görevleri getir (Yönetici için)
    func fetchAllTasks() async throws {
        DispatchQueue.main.async { self.isLoading = true }
        let fetchedTasks: [APITask] = try await NetworkManager.shared.get(endpoint: "/api/tasks")
        DispatchQueue.main.async {
            self.tasks = fetchedTasks
            self.isLoading = false
        }
    }
    
    // Personel görevlerini getir ve yeni iş kontrolü yap
    func fetchPersonnelTasks(personnelId: String) async throws {
        let oldTaskCount = self.tasks.count
        
        DispatchQueue.main.async { self.isLoading = true }
        
        let fetchedTasks: [APITask] = try await NetworkManager.shared.get(
            endpoint: "/api/tasks/personnel/\(personnelId)"
        )
        
        DispatchQueue.main.async {
            self.tasks = fetchedTasks
            self.isLoading = false
            
            if self.tasks.count > oldTaskCount && oldTaskCount != 0 {
                if let lastTask = self.tasks.last {
                    self.triggerLocalNotification(taskTitle: lastTask.title)
                }
            }
        }
    }
    
    // Yeni görev oluştur
    func createTask(task: NewTaskRequest) async throws {
        let newTask: APITask = try await NetworkManager.shared.post(
            endpoint: "/api/tasks",
            body: task
        )
        DispatchQueue.main.async {
            self.tasks.append(newTask)
        }
    }
    
    
    func completeTask(taskId: String) async throws {
        let body = UpdateTaskRequest(status: "tamamlandi")
        let updatedTask: APITask = try await NetworkManager.shared.put(
            endpoint: "/api/tasks/\(taskId)",
            body: body
        )
        DispatchQueue.main.async {
            if let index = self.tasks.firstIndex(where: { $0.id == taskId }) {
                self.tasks[index] = updatedTask
            }
        }
    }
    
    // MARK: - Yerel Bildirim Tetikleyici
    func triggerLocalNotification(taskTitle: String) {
        let content = UNMutableNotificationContent()
        
        // Üst Başlık
        content.title = "Yeni Görev Atandı! 🛠️"
        
        // Alt Başlık
        content.body = "Yeni atanan görevinizi görmek için dokunun."
        
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

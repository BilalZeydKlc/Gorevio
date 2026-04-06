//
//  TaskService.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 23.03.2026.
//

import Foundation
import Combine

class TaskService: ObservableObject {
    static let shared = TaskService()
    
    @Published var tasks: [APITask] = []
    @Published var isLoading = false
    
    private init() {}
    
    func fetchAllTasks() async throws {
        DispatchQueue.main.async { self.isLoading = true }
        let tasks: [APITask] = try await NetworkManager.shared.get(endpoint: "/api/tasks")
        DispatchQueue.main.async {
            self.tasks = tasks
            self.isLoading = false
        }
    }
    
    func fetchPersonnelTasks(personnelId: String) async throws {
        DispatchQueue.main.async { self.isLoading = true }
        let tasks: [APITask] = try await NetworkManager.shared.get(
            endpoint: "/api/tasks/personnel/\(personnelId)"
        )
        DispatchQueue.main.async {
            self.tasks = tasks
            self.isLoading = false
        }
    }
    
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
}

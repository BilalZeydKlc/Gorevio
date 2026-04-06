//
//  NetworkManager.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://gorevio-backend.vercel.app"
    
    private init() {}
    
    func get<T: Decodable>(endpoint: String) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse { print("GET Status: \(httpResponse.statusCode)") }
        if let json = String(data: data, encoding: .utf8) { print("GET Response: \(json)") }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func post<T: Decodable, B: Encodable>(endpoint: String, body: B) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        request.timeoutInterval = 30
        
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse { print("POST Status: \(httpResponse.statusCode)") }
        if let json = String(data: data, encoding: .utf8) { print("POST Response: \(json)") }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func put<T: Decodable, B: Encodable>(endpoint: String, body: B) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        request.timeoutInterval = 30
        
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse { print("PUT Status: \(httpResponse.statusCode)") }
        if let json = String(data: data, encoding: .utf8) { print("PUT Response: \(json)") }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // Silme (DELETE) Fonksiyonu
    func delete(endpoint: String) async throws {
        guard let url = URL(string: baseURL + endpoint) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse { print("DELETE Status: \(httpResponse.statusCode)") }
        if let json = String(data: data, encoding: .utf8) { print("DELETE Response: \(json)") }
    }
}

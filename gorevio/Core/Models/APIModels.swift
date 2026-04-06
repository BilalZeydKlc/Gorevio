//
//  APIModels.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 23.03.2026.
//

import Foundation

// MARK: - User
struct APIUser: Codable {
    let id: String
    let name: String
    let email: String
    let role: String
}

// MARK: - Assigned Personnel
struct AssignedPersonnel: Codable {
    let id: String
    let name: String
    let email: String
    let role: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, email, role
    }
}

// MARK: - Task
struct APITask: Codable, Identifiable {
    let id: String
    let title: String
    let companyName: String
    let address: String
    let description: String
    let assignedTo: AssignedPersonnel
    var status: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, companyName, address, description, assignedTo, status, createdAt
    }
}

// MARK: - Company
struct APICompany: Codable, Identifiable {
    let id: String
    let firmaAdi: String
    let adres: String
    let telefon: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firmaAdi, adres, telefon
    }
}

// MARK: - Personnel
struct APIPersonnel: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let role: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, email, role
    }
}

// MARK: - Requests
struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct NewTaskRequest: Codable {
    let title: String
    let companyName: String
    let address: String
    let description: String
    let assignedTo: String
    let status: String
}

struct UpdateTaskRequest: Codable {
    let status: String
}

struct NewPersonnelRequest: Codable {
    let name: String
    let email: String
    let password: String
    let role: String
}

struct NewPersonnelWithAdminRequest: Codable {
    let name: String
    let email: String
    let password: String
    let adminId: String
}

struct NewPersonnelResponse: Codable {
    let id: String
    let name: String
    let email: String
    let role: String
}

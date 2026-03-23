//
//  Task.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import Foundation

struct Task: Identifiable{
    let id: String
    let title: String
    let companyName: String
    let address: String
    let description: String
    let assingnedTo: String
    let status: TaskStatus
    let createdAt: Date
}

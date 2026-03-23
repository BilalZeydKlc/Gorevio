//
//  TaskCardView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import SwiftUI

struct TaskCardView: View{
    let task: Task
    
    var body: some View{
        
        VStack(alignment: .leading, spacing: 8){
            Text(task.title)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text(task.companyName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(task.address)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack{
                Circle()
                    .fill(statusColor)
                    .frame(width: 8, height: 8)
                Text(statusText)
                    .font(.caption)
                    .foregroundStyle(statusColor)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    var statusColor: Color{
        switch task.status{
            case .bekliyor: return .orange
            case .devamEdiyor: return .blue
            case .tamamlandi: return .yellow
        }
    }
    var statusText: String{
        switch task.status{
        case .bekliyor: return "Bekliyor"
        case .devamEdiyor: return "Devam Ediyor"
        case .tamamlandi: return "Tamamlandı"
        }
    }
}

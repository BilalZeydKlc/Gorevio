//
//  TaskRowView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 23.03.2026.
//

import SwiftUI

struct TaskRowView: View {
    
    let task: APITask
    
    var body: some View {
        HStack(spacing: 16) {
            
            RoundedRectangle(cornerRadius: 4)
                .fill(statusColor)
                .frame(width: 4, height: 60)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(task.companyName)
                    .font(.headline)
                    .foregroundStyle(Color.primaryText)
                
                Text(task.description)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryText)
                    .lineLimit(1)
                
                Text(task.address)
                    .font(.caption)
                    .foregroundStyle(Color.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.secondaryText)
                .font(.caption)
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    
    var statusColor: Color {
        switch task.status {
        case "bekliyor", "devamEdiyor": return .blue // İkisi de mavi
        case "tamamlandi": return .green
        default: return .gray
        }
    }
}

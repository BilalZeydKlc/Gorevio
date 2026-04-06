//
//  BigTaskCardView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import SwiftUI

struct BigTaskCardView: View {
    
    let task: APITask
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // MARK: - Üst Kısım
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.companyName)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.primaryText)
                    
                    Label(task.address, systemImage: "mappin.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryText)
                }
                
                Spacer()
                
                Text("Devam Ediyor")
                    .font(.caption)
                    .bold()
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.accent.opacity(0.12))
                    .foregroundStyle(Color.accent)
                    .clipShape(Capsule())
            }
            
            Divider()
                .background(Color.divider)
            
            // MARK: - Arıza
            VStack(alignment: .leading, spacing: 6) {
                Text("Arıza")
                    .font(.caption)
                    .foregroundStyle(Color.secondaryText)
                Text(task.description)
                    .font(.body)
                    .foregroundStyle(Color.primaryText)
                    .lineLimit(3)
            }
            
            // MARK: - Tarih & Detay
            HStack {
                Image(systemName: "calendar")
                    .foregroundStyle(Color.secondaryText)
                Text(task.createdAt)
                    .font(.caption)
                    .foregroundStyle(Color.secondaryText)
                
                Spacer()
                
                Text("Detay →")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(Color.accent)
            }
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

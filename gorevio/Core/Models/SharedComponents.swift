//
//  SharedComponents.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 24.03.2026.
//

import SwiftUI

struct StatCardView: View {
    let count: Int
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(count)")
                .font(.title)
                .bold()
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(Color.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.cardBackground)
        .cornerRadius(16)
    }
}

struct ProfileRowView: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundStyle(Color.accent)
                .frame(width: 20)
                .padding(.leading, 16)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(Color.secondaryText)
                Text(value)
                    .font(.body)
                    .foregroundStyle(Color.primaryText)
            }
            Spacer()
        }
        .padding(.vertical, 12)
    }
}
struct InputFieldView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(Color.secondaryText)
            TextField(placeholder, text: $text)
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(12)
        }
    }
}

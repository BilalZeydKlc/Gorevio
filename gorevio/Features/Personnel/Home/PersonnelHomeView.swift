//
//  PersonnelHomeView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import SwiftUI

struct PersonnelHomeView: View {
    
    let tasks = MockData.tasks
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Merhaba, Bilal 👋")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color.primaryText)
                        .padding(.horizontal)
                    
                    Text("Mevcut İşler")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.primaryText)
                        .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        ForEach(tasks.filter { $0.status == .devamEdiyor }) { task in
                            NavigationLink(destination: TaskDetailView(task: task)) {
                                BigTaskCardView(task: task)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("GöreviO")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.primaryText)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "bell.fill")
                            .foregroundStyle(Color.primaryText)
                    }
                }
            }
        }
    }
}

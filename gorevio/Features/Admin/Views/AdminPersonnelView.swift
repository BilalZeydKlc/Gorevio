//
//  AdminPersonnelView.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 23.03.2026.
//

import SwiftUI

struct AdminPersonnelView: View {
    @EnvironmentObject var personnelService: PersonnelService
    @State private var showNewPersonnel = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(personnelService.personnelList) { personnel in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(personnel.name)
                                .font(.headline)
                                .foregroundStyle(Color.primaryText)
                            Text(personnel.email)
                                .font(.subheadline)
                                .foregroundStyle(Color.secondaryText)
                        }
                        Spacer()
                        
                        Text(personnel.role.capitalized)
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(personnel.role == "admin" ? Color.accent.opacity(0.15) : Color.blue.opacity(0.15))
                            .foregroundStyle(personnel.role == "admin" ? Color.accent : Color.blue)
                            .cornerRadius(8)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deletePersonnel)
            }
            .listStyle(.plain)
            .background(Color.appBackground)
            .navigationTitle("Personeller")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewPersonnel = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.accent)
                    }
                }
            }
            .sheet(isPresented: $showNewPersonnel) {
                AdminNewPersonnelView()
                    .environmentObject(personnelService)
            }
            .task {
                try? await personnelService.fetchPersonnel()
            }
        }
    }
    
    private func deletePersonnel(at offsets: IndexSet) {
        let idsToDelete = offsets.map { personnelService.personnelList[$0].id }
        personnelService.personnelList.remove(atOffsets: offsets)
        
        for id in idsToDelete {
            // İŞTE SİHİRLİ DOKUNUŞ BURADA: Kendi Task modelinle karışmasını engelliyoruz
            _Concurrency.Task {
                try? await personnelService.deletePersonnel(id: id)
            }
        }
    }
}

#Preview {
    AdminPersonnelView()
        .environmentObject(PersonnelService.shared)
}

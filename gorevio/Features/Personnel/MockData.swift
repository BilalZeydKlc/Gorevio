//
//  MockData.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 10.03.2026.
//

import Foundation

struct MockData{
    static let tasks: [Task] = [
        Task(
            id: "1",
            title: "Bilgisayar Arızası",
            companyName: "ABC Teknoloji",
            address: "Kadıköy İstanbul",
            description: "Bilgisayar Açılmıyor",
            assingnedTo: "personel1",
            status: .devamEdiyor,
            createdAt: Date()
        ),
        Task(
            id: "2",
            title: "Yazıcı Arızası",
            companyName: "XYZ Teknoloji",
            address: "Sultanbeyli İstanbul",
            description: "Yazıcı Açılmıyor",
            assingnedTo: "personel1",
            status: .devamEdiyor,
            createdAt: Date()
        ),
        Task(
            id: "3",
            title: "Ağ Sorunu",
            companyName: "TECH Teknoloji",
            address: "Şişli İstanbul",
            description: "Ağ Açılmıyor",
            assingnedTo: "personel1",
            status: .tamamlandi,
            createdAt: Date()
        ),
        Task(
            id: "4",
            title: "Elektrik Kesintisi",
            companyName: "A Holding",
            address: "Bağcılar İstanbul",
            description: "Elektrik Açılmıyor",
            assingnedTo: "personel1",
            status: .devamEdiyor,
            createdAt: Date()
        ),
        Task(
            id: "5",
            title: "Laptop Arızası",
            companyName: "ZEN Teknoloji",
            address: "Üsküdar İstanbul",
            description: "Laptop Açılmıyor",
            assingnedTo: "personel1",
            status: .devamEdiyor,
            createdAt: Date()
        ),
        Task(
            id: "6",
            title: "Fare Arızası",
            companyName: "BZK Teknoloji",
            address: "Sancaktepe İstanbul",
            description: "Fare Bağlanmıyor",
            assingnedTo: "personel1",
            status: .bekliyor,
            createdAt: Date()
        ),
        
    ]
}

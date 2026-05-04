//
//  Bundle+Extension.swift
//  gorevio
//
//  Created by Bilal Zeyd Kılıç on 14.04.2026.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

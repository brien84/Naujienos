//
//  Settings.swift
//  Naujienos
//
//  Created by Marius on 11/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

class SettingsItem: Codable {
    var provider: String
    var categories: [String: Bool]
}

/// When Settings instance is created, it decodes Settings.plist to array of SettingsItems.
/// Settings encode items array back to Settings.plist, when the save() method is called.
///
/// - Note: Settings.plist default values are created using DefaultSettings.plist,
/// when application is launched for the first time (check AppDelegate).
/// DefaultSettings.plist can be found in app bundle.
struct Settings {
    
    var items = [SettingsItem]()
    
    /// Called on init!
    private mutating func load() {
        guard let filePath = Constants.URLs.settings else { return }
        if let data = try? Data(contentsOf: filePath) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([SettingsItem].self, from: data)
            } catch {
                print("Error decoding settings, \(error)")
            }
        }
    }
    
    func save() {
        guard let filePath = Constants.URLs.settings else { return }
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: filePath)
        } catch {
            print("Error encoding settings, \(error)")
        }
    }
    
    init() {
        self.load()
    }
}

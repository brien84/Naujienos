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

struct Settings {
    
    var items = [SettingsItem]()
    
    /// Decodes SettingsItems from Settings file to items array.
    /// Is called on init!
    mutating func load() {
        guard let filePath = Constants.Paths.settings else { return }
        if let data = try? Data(contentsOf: filePath) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([SettingsItem].self, from: data)
            } catch {
                print("Error decoding settings, \(error)")
            }
        }
    }
    
    /// Encodes items array and writes to Settings file.
    func save() {
        guard let filePath = Constants.Paths.settings else { return }
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

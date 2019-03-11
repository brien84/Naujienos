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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
    
    mutating func load() {
        guard let dataFilePath = dataFilePath else { return }
        if let data = try? Data(contentsOf: dataFilePath) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([SettingsItem].self, from: data)
            } catch {
                print("Error decoding settings, \(error)")
            }
        }
    }
    
    func save() {
        guard let dataFilePath = dataFilePath else { return }
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath)
        } catch {
            print("Error encoding settings, \(error)")
        }
    }
    
    init() {
        self.load()
    }
}

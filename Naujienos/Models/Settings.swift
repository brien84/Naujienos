//
//  Settings.swift
//  Naujienos
//
//  Created by Marius on 11/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

class SettingsItem: Codable {
    let provider: String
    var categories: [String : Bool]
    
    init(provider: String, categories: [String : Bool]) {
        self.provider = provider
        self.categories = categories
    }
    
    func getEnabledCategories() -> [String] {
        return categories.compactMap { $0.value ? $0.key : nil }
    }
}

protocol SettingsProtocol {
    var plist: URL { get set }
    var items: [SettingsItem] { get set }
    
    mutating func load()
    func save()
}

/// When Settings instance is created, it decodes Settings.plist to array of SettingsItems.
/// Settings encode items array back to Settings.plist, when the save() method is called.
///
/// - Note: Settings.plist default values are created using DefaultSettings.plist,
/// when application is launched for the first time (check AppDelegate).
/// DefaultSettings.plist can be found in app bundle.
struct Settings: SettingsProtocol {
    
    var plist: URL
    var items = [SettingsItem]()
    
    init(plist: URL = Constants.URLs.settings) {
        self.plist = plist
        self.load()
    }
    
    mutating func load() {
        if let data = try? Data(contentsOf: plist) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([SettingsItem].self, from: data)
            } catch {
                print("Settings: \(error)")
            }
        }
    }
    
    func save() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: plist)
        } catch {
            print("Settings: \(error)")
        }
    }
}

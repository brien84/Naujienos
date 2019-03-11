//
//  AppDelegate.swift
//  Naujienos
//
//  Created by Marius on 09/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        createDefaultSettings()
        
        return true
    }
    
    /// Check if Settings file already exists and if not create Settings.plist from bundle file DefaultSettings.plist.
    private func createDefaultSettings() {
        let fileManager = FileManager.default
        
        guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Could not find documentDirectory.")
        }
        
        let settingsFilePath = directory.appendingPathComponent("Settings.plist").path
        
        if !fileManager.fileExists(atPath: settingsFilePath) {
            guard let defaultsPath = Bundle.main.path(forResource: "DefaultSettings", ofType: "plist") else {
                fatalError("Could not find DefaultSettings.plist in bundle.")
            }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: defaultsPath))
                fileManager.createFile(atPath: settingsFilePath, contents: data)
            } catch {
                fatalError("Could not create default settings.")
            }
        }
    }
}

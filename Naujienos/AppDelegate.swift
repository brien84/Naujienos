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
        
        guard let settingsFilePath = Constants.URLs.settings?.path else {
            fatalError("Could not construct Settings file path.")
        }
        
        let fileManager = FileManager.default
        
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

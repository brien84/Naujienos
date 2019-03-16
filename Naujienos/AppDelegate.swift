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
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = createNavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func createNavigationController() -> UINavigationController {
        let navController = UINavigationController(rootViewController: MainFeedViewController())
        
        navController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:Constants.Colors.dark,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 20)!
        ]
        navController.navigationBar.backgroundColor = Constants.Colors.backgroundWhite
        navController.navigationBar.tintColor = Constants.Colors.red
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.topItem?.title = ""
        
        return navController
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

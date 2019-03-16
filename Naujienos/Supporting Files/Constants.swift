//
//  Constants.swift
//  Naujienos
//
//  Created by Marius on 11/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

struct Constants {
    
    struct TableView {
        struct Settings {
            static let sectionHeaderHeight: CGFloat = 44.0
            static let sectionFooterHeight: CGFloat = 0.0
        }
    }
    
    struct Colors {
        static let red = UIColor(red: 255/255, green: 71/255, blue: 87/255, alpha: 1.0) //rgb(255, 71, 87)
        static let background = UIColor(red: 241/255, green: 242/255, blue: 246/255, alpha: 1.0)
    }
    
    struct URLs {
        static let server: URL? = URL(string: "http://142.93.60.232:8080/filter")
        
        static let settings: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
        static let bookmarks: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Bookmarks.plist")
    }
    
}

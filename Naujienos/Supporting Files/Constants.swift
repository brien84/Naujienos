//
//  Constants.swift
//  Naujienos
//
//  Created by Marius on 11/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

struct Constants {
    
    struct Colors {
        static let red = UIColor(red: 255/255, green: 71/255, blue: 87/255, alpha: 1.0)                 //#ff4757
        static let dark = UIColor(red: 47/255, green: 53/255, blue: 66/255, alpha: 1.0)                 //#2f3542
        static let gray = UIColor(red: 87/255, green: 96/255, blue: 111/255, alpha: 1.0)                //#57606f
        static let backgroundGray = UIColor(red: 241/255, green: 242/255, blue: 246/255, alpha: 1.0)    //#f1f2f6
        static let backgroundWhite = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)   //#ffffff
    }
    
    struct Fonts {
        static let navigationControllerTitle = UIFont(name: "HelveticaNeue-Light", size: 20)!
        static let errorLabel = UIFont(name: "HelveticaNeue-Light", size: 21)!
    }
    
    struct NavigationControllerTitles {
        static let bookmarks = "Išsaugoti"
        static let settings = "Rubrikos"
    }
    
    struct TableView {
        struct Article {
            static let estimatedRowHeight: CGFloat = 600.0
        }
        
        struct Settings {
            static let sectionHeaderHeight: CGFloat = 50.0
            static let sectionFooterHeight: CGFloat = 0.0
            static let rowHeight: CGFloat = 50.0
        }
    }
    
    struct URLs {
        static let server: URL? = URL(string: "http://142.93.60.232:8080/filter")
        static let settings: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
        static let bookmarks: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Bookmarks.plist")
    }
}

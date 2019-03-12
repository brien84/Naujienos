//
//  Constants.swift
//  Naujienos
//
//  Created by Marius on 11/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

struct Constants {
    
    struct URLs {
        static let server: URL? = URL(string: "http://142.93.60.232:8080/filter")
        static let settings: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
    }
    
}

//
//  Article.swift
//  Naujienos
//
//  Created by Marius on 12/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

struct Article: Codable {
    
    let url: URL
    let title: String
    let date: Date
    let description: String
    let imageURL: URL
    let provider: String
    
    var timeSincePublished: String {
        return date.timeSincePublished
    }
}

extension Date {
    var timeSincePublished: String {
        
        let now = Date()
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: self, to: now)
        
        if let days = components.day, days > 0 {
            let remainder = days % 10
            switch true {
            case remainder == 0,
                 11...19 ~= days:
                return "prieš \(days) dienų"
            case remainder == 1:
                return "prieš \(days) dieną"
            default:
                return "prieš \(days) dienas"
            }
        }
        
        if let hours = components.hour, hours > 0 {
            let remainder = hours % 10
            switch true {
            case remainder == 0,
                 11...19 ~= hours:
                return "prieš \(hours) valandų"
            case remainder == 1:
                return "prieš \(hours) valandą"
            default:
                return "prieš \(hours) valandas"
            }
        }
        
        if let minutes = components.minute, minutes > 0 {
            let remainder = minutes % 10
            switch true {
            case remainder == 0,
                 11...19 ~= minutes:
                return "prieš \(minutes) minučių"
            case remainder == 1:
                return "prieš \(minutes) minutę"
            default:
                return "prieš \(minutes) minutes"
            }
        }
        
        return "dabar"
    }
}

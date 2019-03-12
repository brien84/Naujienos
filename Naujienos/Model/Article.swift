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
    let category: String
    
}

//
//  Bookmarks.swift
//  Naujienos
//
//  Created by Marius on 12/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

struct Bookmarks {
    
    var articles = [Article]()
    
    private mutating func load() {
        guard let filePath = Constants.URLs.bookmarks else { return }
        if let data = try? Data(contentsOf: filePath) {
            let decoder = PropertyListDecoder()
            do {
                articles = try decoder.decode([Article].self, from: data)
            } catch {
                print("Error decoding articles, \(error)")
            }
        }
    }
    
    private func save() {
        guard let filePath = Constants.URLs.bookmarks else { return }
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(articles)
            try data.write(to: filePath)
        } catch {
            print("Error encoding articles, \(error)")
        }
    }
    
    mutating func add(_ article: Article) {
        articles.append(article)
        self.save()
    }
    
    mutating func remove(_ article: Article) {
        articles = articles.filter { $0.url != article.url }
        self.save()
    }
    
    func contains(_ article: Article) -> Bool {
        if articles.contains(where: { $0.url == article.url }) {
            return true
        } else {
            return false
        }
    }
    
    init() {
        self.load()
    }
    
}

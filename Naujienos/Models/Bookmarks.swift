//
//  Bookmarks.swift
//  Naujienos
//
//  Created by Marius on 12/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

/// Manages bookmarked Articles and persists them in Bookmarks.plist file.
/// When instance of Bookmarks is created, it decodes data from plist file into array of Article.
/// Once Article is added to or removed from the array, instance encodes modified array to the Bookmarks.plist.
class Bookmarks {
    
    private var plist: URL!
    
    private var articles = [Article]()
    
    init(plist: URL = Constants.URLs.bookmarks) {
        self.plist = plist
        self.load()
    }
    
    func load() {
        if let data = try? Data(contentsOf: plist) {
            let decoder = PropertyListDecoder()
            do {
                articles = try decoder.decode([Article].self, from: data)
            } catch {
                print("Bookmarks: \(error)")
            }
        }
    }
    
    private func save() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(articles)
            try data.write(to: plist)
        } catch {
            print("Bookmarks: \(error)")
        }
    }
    
    func getArticles() -> [Article] {
        return articles
    }
    
    func add(_ article: Article) {
        articles.append(article)
        self.save()
        sendUpdateNotification()
    }
    
    func remove(_ article: Article) {
        articles = articles.filter { $0.url != article.url }
        self.save()
        sendUpdateNotification()
    }
    
    func contains(_ article: Article) -> Bool {
        if articles.contains(where: { $0.url == article.url }) {
            return true
        } else {
            return false
        }
    }
    
    private func sendUpdateNotification() {
        NotificationCenter.default.post(name: .bookmarksDidUpdate, object: nil)
    }
}

extension Notification.Name {
    static let bookmarksDidUpdate = Notification.Name("bookmarksDidUpdate")
}

//
//  ArticleManager.swift
//  Naujienos
//
//  Created by Marius on 07/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

private enum NetworkError: Error {
    case badData
}

protocol ArticleManagerProtocol {
    var articles: [Article] { get set }
    
    func getArticles(with settings: [SettingsItem]) -> [Article]
    func fetch(using session: URLSession, completionHandler: @escaping (Result<Void, Error>) -> Void)
}

class ArticleManager: ArticleManagerProtocol {
    
    var articles = [Article]()
    
    func getArticles(with settings: [SettingsItem]) -> [Article] {
        return settings.flatMap { item  -> [Article] in
            let categories = item.getEnabledCategories()
            
            return articles.filter { $0.provider == item.provider && categories.contains($0.category) }
        }
    }
    
    func fetch(using session: URLSession = .shared, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        
        articles.removeAll()
        
        let task = session.dataTask(with: Constants.URLs.API) { data, response, error in
            if let data = data {
                
                let decoder = JSONDecoder()
                /// Decoded dates with .iso8601 look like this: "2018-12-25T17:30:00Z".
                decoder.dateDecodingStrategy = .iso8601
                
                do {
                    self.articles = try decoder.decode([Article].self, from: data)
                    completionHandler(.success(()))
                } catch {
                    completionHandler(.failure(error))
                }
                
            } else {
                completionHandler(.failure(NetworkError.badData))
            }
        }

        task.resume()
    }
}

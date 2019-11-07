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

class ArticleManager {
    
    var articles = [Article]()
    
    func fetch(using session: URLSession = .shared, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        let task = session.dataTask(with: Constants.URLs.API) { data, response, error in
            if let data = data {
                
                let decoder = JSONDecoder()
                /// Decoded dates with .iso8601 look like this: "2018-12-25T17:30:00Z".
                decoder.dateDecodingStrategy = .iso8601
                
                do {
                    self.articles = try decoder.decode([Article].self, from: data)
                    completionHandler(.success(()))
                } catch {
                    print("Error decoding articles, \(error)")
                    completionHandler(.failure(error))
                }
                
            } else {
                completionHandler(.failure(NetworkError.badData))
            }
        }

        task.resume()
    }
}

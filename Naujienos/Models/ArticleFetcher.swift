//
//  ArticleFetcher.swift
//  Naujienos
//
//  Created by Marius on 12/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

private enum FetchingError: Error {
    case prepareRequest
    case urlSession
}

protocol FetcherDelegate: AnyObject {
    func finishedFetching(_ articles: [Article], with error: Error?)
}

class ArticleFetcher {
    
    weak var delegate: FetcherDelegate?

    private func dispatchDelegate(_ articles: [Article], with error: Error?) {
        DispatchQueue.main.async {
            self.delegate?.finishedFetching(articles, with: error)
        }
    }
    
    /// Sends request to the API.
    ///
    /// If request is succesful, response data is decoded to array of Article, sorted by most recent.
    /// Then delegate method is called with the array passed as an argument.
    ///
    /// If function failed to get data, delegate method is called with an empty articles array and an FetchingError.
    func fetch() {
        var articles = [Article]()
        
        guard let request = prepareRequest() else {
            self.dispatchDelegate(articles, with: FetchingError.prepareRequest)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                self.dispatchDelegate(articles, with: FetchingError.urlSession)
                return
            }
            
            let decoder = JSONDecoder()
            /// Decoded dates with .iso8601 look like this: "2018-12-25T17:30:00Z".
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                articles = try decoder.decode([Article].self, from: data)
            } catch {
                print("Error decoding articles, \(error)")
            }
            
            articles = articles.sorted(by: { $0.date > $1.date})
            self.dispatchDelegate(articles, with: nil)
        }.resume()
    }
    
    /// Loads Settings items and encodes them to JSON. Then creates an URLRequest with the JSON in URLRequest's body.
    ///
    /// - Note: The JSON data is used for querying the API. API will only return articles under categories, which are marked as true.
    ///
    /// This is an example of the JSON:
    ///
    /// [{"categories":{"_main":true,"business":false},"provider":"delfi"},{"categories":{"_main":true,"business":false},"provider":"15min"}]
    ///
    /// - Returns: URLRequest or nil if conversion to JSON fails.
    private func prepareRequest() -> URLRequest? {
        do {
            let settings = Settings()
            let settingsJSON = try JSONEncoder().encode(settings.items)
            
            guard let url = Constants.URLs.server else { return nil }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = settingsJSON
            
            return request
        } catch {
            print("Error preparing URLRequest in ArticleFetcher: \(error)")
            return nil
        }
    }
}

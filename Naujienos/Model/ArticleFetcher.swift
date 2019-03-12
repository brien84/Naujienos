//
//  ArticleFetcher.swift
//  Naujienos
//
//  Created by Marius on 12/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

protocol FetcherProtocol: AnyObject {
    func finishedFetching()
}

class ArticleFetcher {
    
    weak var delegate: FetcherProtocol?

    var articles = [Article]()
    
    /// Sends request to the API. If request is succesful, response data is decoded to array of Article and sorted by most recent.
    func fetch() {
        articles.removeAll()
        
        guard let request = prepareRequest() else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                self.articles = try decoder.decode([Article].self, from: data)
            } catch {
                print("Error decoding articles, \(error)")
            }
            
            self.articles = self.articles.sorted(by: { $0.date > $1.date})
            DispatchQueue.main.async {
                self.delegate?.finishedFetching()
            }
            
        }.resume()
    }
    
    /**
     Loads Settings items and encodes them to JSON. Then creates an URLRequest with the JSON in URLRequest's body.
    
     - Note: The JSON data is used for querying the API. API will only return articles under categories, which are marked as true.
     
     This is an example of the JSON:
     
     [{"categories":{"_main":true,"business":false},"provider":"delfi"},{"categories":{"_main":true,"business":false},"provider":"15min"}]
    
     - Returns: URLRequest or nil if conversion to JSON fails.
  
     */
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

//
//  NetworkImageView.swift
//  Naujienos
//
//  Created by Marius on 13/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class NetworkImageView: UIImageView {

    private let cache = NSCache<NSString, NSData>()
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    
    var url: URL? {
        didSet {
            self.loadImage()
        }
    }
    
    override var image: UIImage? {
        didSet {
            if image != nil {
                activityIndicator.stopAnimating()
            } else {
                activityIndicator.startAnimating()
            }
        }
    }
    
    override func awakeFromNib() {
        activityIndicator.color = Constants.Colors.red
        activityIndicator.center = self.center
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
    }
    
    private func loadImage() {
        guard let url = url else {
            self.image = nil
            return
        }
        
        if let cachedData = cache.object(forKey: url.absoluteString as NSString) {
            guard let image = UIImage(data: cachedData as Data) else { return }
            self.image = image
        } else {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data) else { return }
                    self?.cache.setObject(data as NSData, forKey: url.absoluteString as NSString)
                    self?.image = image
                }
            }.resume()
        }
    }

}

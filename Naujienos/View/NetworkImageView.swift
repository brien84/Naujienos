//
//  NetworkImageView.swift
//  Naujienos
//
//  Created by Marius on 13/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

/// Class for downloading and displaying images.
/// When url property is set, first checks if image is cached, then either
/// displays image from cache or downloads image.
///
/// - Note: Images are cached as Data to significantly lower memory usage.
class NetworkImageView: UIImageView {

    private let cache = NSCache<NSString, NSData>()
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    
    var url: URL? {
        didSet {
            self.loadImage()
        }
    }
    
    /// If image is nil, displays spinning activityIndicator.
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
        /// Setup activityIndicator.
        activityIndicator.color = Constants.Colors.red
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.center = self.center
    }

    private func loadImage() {
        guard let url = url else {
            self.image = nil
            return
        }
        
        /// If image data is found in cache.
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

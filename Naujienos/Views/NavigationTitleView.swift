//
//  NavigationTitleView.swift
//  Naujienos
//
//  Created by Marius on 16/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

/// Custom navigationItem titleView.
/// Frame and indicator scale are hard coded to fit in Navigation bar.
/// When isLoading set to true, view displays spinning activity indicator.
/// When isLoading set to false, view displays app icon.
class NavigationTitleView: UIView {
    
    var isLoading = false {
        didSet {
            updateView()
        }
    }
    
    lazy private var icon = { () -> UIImageView in
        let icon = UIImageView(image: UIImage(named: "newspaper"))
        icon.frame = self.frame
        icon.contentMode = .scaleAspectFit
        addSubview(icon)
        return icon
    }()
    
    lazy private var indicator = { () -> UIActivityIndicatorView in
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.frame = self.frame
        indicator.center = self.center
        indicator.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        indicator.color = Constants.Colors.red
        addSubview(indicator)
        return indicator
    }()
    
    private func updateView() {
        if isLoading {
            icon.isHidden = true
            indicator.startAnimating()
        } else {
            icon.isHidden = false
            indicator.stopAnimating()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//
//  NavigationTitleView.swift
//  Naujienos
//
//  Created by Marius on 16/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class NavigationTitleView: UIView {
    
    var isLoading = false {
        didSet {
            updateView()
        }
    }
    
    lazy private var icon = { () -> UIImageView in
        print("Setting Up Icon!")
        let icon = UIImageView(image: UIImage(named: "newspaper"))
        icon.frame = self.frame
        icon.contentMode = .scaleAspectFit
        addSubview(icon)
        return icon
    }()
    
    lazy private var indicator = { () -> UIActivityIndicatorView in
        print("Setting Up Indicator!")
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

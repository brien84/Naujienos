//
//  BookmarksButton.swift
//  Naujienos
//
//  Created by Marius on 12/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

protocol BookmarkButtonProtocol: AnyObject {
    func bookmarkButtonTapped(_ sender: BookmarkButton, _ gestureRecognizer: UITapGestureRecognizer)
}

class BookmarkButton: UIButton {

    weak var delegate: BookmarkButtonProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        
        self.setImage(UIImage(named: "bookmarkOff"), for: .normal)
        self.setImage(UIImage(named: "bookmarkOn"), for: .selected)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped)))
    }
    
    @objc private func buttonTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.bookmarkButtonTapped(self, gestureRecognizer)
    }

}

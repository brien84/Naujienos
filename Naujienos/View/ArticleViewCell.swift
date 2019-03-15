//
//  ArticleViewCell.swift
//  Naujienos
//
//  Created by Marius on 12/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class ArticleViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var timeSincePublished: UILabel!
    @IBOutlet weak var articleDescription: UILabel!

    @IBOutlet weak var articleImage: NetworkImageView!
    
    @IBOutlet weak var providerIcon: UIImageView!
    
    @IBOutlet weak var bookmarkButton: BookmarkButton!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        self.articleImage.image = nil
        self.bookmarkButton.isSelected = false
    }
}

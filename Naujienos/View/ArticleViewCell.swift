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
    
    @IBOutlet weak var bookmarkButton: BookmarkButton!

    override func layoutSubviews() {
        super.layoutSubviews()
        // adds spacing between cells
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: Constants.TableView.spacingBetweenCells, right: 0))
    }
    
    override func prepareForReuse() {
        self.articleImage.image = nil
        self.bookmarkButton.isSelected = false
    }
}

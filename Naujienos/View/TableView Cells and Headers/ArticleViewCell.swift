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
    @IBOutlet weak var providerIcon: UIImageView!
    @IBOutlet weak var articleImage: NetworkImageView!
    @IBOutlet weak var bookmarkButton: BookmarkButton!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        self.articleImage.image = nil
        self.bookmarkButton.isSelected = false
    }
    
    /// Resize Font sizes according to Accessibility settings.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let pointSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1).pointSize
        title.font = Constants.Fonts.articleViewCellTitle.resizeFontAccording(to: pointSize)
        timeSincePublished.font = Constants.Fonts.articleViewCelltimeSincePublished.resizeFontAccording(to: pointSize)
        articleDescription.font = Constants.Fonts.articleViewCellDescription.resizeFontAccording(to: pointSize)
    }
}

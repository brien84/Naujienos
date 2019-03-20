//
//  SettingsViewCell.swift
//  Naujienos
//
//  Created by Marius on 16/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class SettingsViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.tintColor = Constants.Colors.red
    }
    
    /// Resizes Font sizes according to Accessibility settings.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let pointSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1).pointSize
        title.font = Constants.Fonts.settingsViewCellTitle.resizeFontAccording(to: pointSize)
    }
}

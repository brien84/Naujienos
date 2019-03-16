//
//  SettingsViewCell.swift
//  Naujienos
//
//  Created by Marius on 16/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class SettingsViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = Constants.Colors.red
        self.selectionStyle = .none
    }

    @IBOutlet weak var title: UILabel!
    

    
}

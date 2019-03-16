//
//  SettingsSectionHeader.swift
//  Naujienos
//
//  Created by Marius on 15/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

protocol SettingsSectionHeaderDelegate: AnyObject {
    func toggleCollapse(for header: SettingsSectionHeader, at section: Int)
}

class SettingsSectionHeader: UITableViewHeaderFooterView {
    
    weak var delegate: SettingsSectionHeaderDelegate?
    
    var section = 0

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var collapsionIndicator: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader)))
    }
    
    @objc private func tapHeader() {
        delegate?.toggleCollapse(for: self, at: section)
    }
    
    func setCollapsed(to isCollapsed: Bool) {
        collapsionIndicator.image = isCollapsed ? UIImage(named: "sectionCollapsed") : UIImage(named: "sectionExpanded")
    }
}
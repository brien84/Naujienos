//
//  ErrorLabel.swift
//  Naujienos
//
//  Created by Marius on 17/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class ErrorLabel: UILabel {

    enum Error: String {
        case network = "Nepavyko pasiekti naujienų serverio"
        case emptyDatasource = "Pasirinktoms rubrikoms naujienų nėra"
        case emptyBookmarks = "Išsaugotų naujienų nėra"
        case webViewError = "Nepavyko atidaryti naujienos"
    }
    
    init(frame: CGRect, error: Error) {
        super.init(frame: frame)
        
        self.text = error.rawValue
        self.textColor = Constants.Colors.red
        self.font = Constants.Fonts.errorLabel
        self.textAlignment = .center
        self.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Resizes Font sizes according to Accessibility settings.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let pointSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1).pointSize
        self.font = Constants.Fonts.settingsViewCellTitle.resizeFontAccording(to: pointSize)
    }
}

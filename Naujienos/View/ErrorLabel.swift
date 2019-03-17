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
        case Network = "Nepavyko pasiekti Naujienų serverio"
        case EmptyDatasource = "Pasirinktoms rubrikoms Naujienų nėra"
        case EmptyBookmarks = "Išsaugotų Naujienų nėra"
        case WebViewError = "Nepavyko atidaryti Naujienos"
    }
    
    init(frame: CGRect, error: Error) {
        super.init(frame: frame)
        
        self.text = error.rawValue
        self.textColor = Constants.Colors.red
        self.font = Constants.Fonts.errorLabel
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

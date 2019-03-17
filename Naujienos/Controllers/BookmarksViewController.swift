//
//  BookmarksViewController.swift
//  Naujienos
//
//  Created by Marius on 13/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class BookmarksViewController: ArticleViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Išsaugoti"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datasource = bookmarks.articles
        if datasource.count == 0 {
            let label = ErrorLabel(frame: self.view.bounds, error: .EmptyBookmarks)
            self.view.addSubview(label)
        }
    }
}

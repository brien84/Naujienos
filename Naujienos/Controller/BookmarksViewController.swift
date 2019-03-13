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

        datasource = bookmarks.articles
    }
}

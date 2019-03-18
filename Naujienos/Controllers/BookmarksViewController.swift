//
//  BookmarksViewController.swift
//  Naujienos
//
//  Created by Marius on 13/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

/// Displays bookmarked Articles in TableView.
/// - Note: Articles are shown by the order they were bookmarked.
class BookmarksViewController: ArticleViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constants.NavigationController.Bookmarks.title
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// datasource is set, after bookmarks are loaded in superclass.
        datasource = bookmarks.articles
        
        /// If datasource is empty, displays an error.
        if datasource.count == 0 {
            let label = ErrorLabel(frame: self.view.bounds, error: .EmptyBookmarks)
            self.view.addSubview(label)
        }
    }
}

//
//  BookmarksViewController.swift
//  Naujienos
//
//  Created by Marius on 13/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

/// Displays bookmarked Articles in TableView.
class BookmarksViewController: ArticleViewController {
    
    init(style: UITableView.Style = .plain, bookmarks: BookmarksProtocol = Bookmarks()) {
        super.init(style: style)
        
        self.bookmarks = bookmarks
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = Constants.NavigationControllerTitles.bookmarks
        
        datasource = bookmarks.getArticles()
        
        if datasource.count == 0 {
            let label = ErrorLabel(frame: self.view.bounds, error: .emptyBookmarks)
            self.tableView.backgroundView = label
        }
    }
}

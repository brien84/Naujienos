//
//  ArticleViewController.swift
//  Naujienos
//
//  Created by Marius on 12/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class ArticleViewController: UITableViewController {
    
    var datasource = [Article]()
    var bookmarks = Bookmarks()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ArticleViewCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    }
        
    // MARK: - TableView methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleViewCell
        
        cell.bookmarkButton.delegate = self
    
        let item = datasource[indexPath.row]
        
        cell.bookmarkButton.isSelected = bookmarks.contains(item)
        
        cell.title.text = item.title
        cell.timeSincePublished.text = item.timeSincePublished
        cell.articleDescription.text = item.description
        cell.provider.text = item.provider
        cell.category.text = item.category
        
        return cell
    }
}

extension ArticleViewController: BookmarkButtonProtocol {
    func bookmarkButtonTapped(_ sender: BookmarkButton, _ gestureRecognizer: UITapGestureRecognizer) {
        if let indexPath = self.tableView?.indexPathForRow(at: gestureRecognizer.location(in: self.tableView)) {
            
            let item = datasource[indexPath.row]
            
            if bookmarks.contains(item) {
                bookmarks.remove(item)
            } else {
                bookmarks.add(item)
            }
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

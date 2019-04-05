//
//  ArticleViewController.swift
//  Naujienos
//
//  Created by Marius on 12/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

/// Displays an array of Article in TableView.
class ArticleViewController: UITableViewController {
    
    var datasource = [Article]()
    var bookmarks: Bookmarks!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ArticleViewCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
        tableView.backgroundColor = Constants.Colors.backgroundGray
        tableView.estimatedRowHeight = Constants.TableView.Article.estimatedRowHeight
        tableView.separatorStyle = .none
    }
    
    /// bookmarks property is set in viewWillAppear,
    /// so it could conveniently be updated on return to root ViewController.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookmarks = Bookmarks()
    }
        
    // MARK: - TableView methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleViewCell
        
        cell.bookmarkButton.delegate = self
    
        let item = datasource[indexPath.row]
        
        cell.title.text = item.title
        cell.timeSincePublished.text = item.timeSincePublished
        cell.articleDescription.text = item.description
        cell.articleImage.url = item.imageURL
        cell.providerIcon.image = UIImage(named: item.provider)
        cell.bookmarkButton.isSelected = bookmarks.contains(item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WebViewController()
        vc.articleToDisplay = datasource[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ArticleViewController: BookmarkButtonDelegate {
    /// When BookmarkButton is tapped, Article is added to/removed from bookmarks.
    func bookmarkButtonTapped(_ sender: BookmarkButton, _ gestureRecognizer: UITapGestureRecognizer) {
        if let indexPath = self.tableView?.indexPathForRow(at: gestureRecognizer.location(in: self.tableView)) {
            
            let item = datasource[indexPath.row]
            
            if bookmarks.contains(item) {
                bookmarks.remove(item)
            } else {
                bookmarks.add(item)
            }
            
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

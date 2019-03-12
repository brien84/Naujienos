//
//  ArticleViewController.swift
//  Naujienos
//
//  Created by Marius on 12/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class ArticleViewController: UITableViewController {
    
    let fetcher = ArticleFetcher()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()

        tableView.register(UINib(nibName: "ArticleViewCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
        
        fetcher.delegate = self
        fetcher.fetch()
    }
    
    private func setupNavigationBarItems() {
        let settingsButton = UIButton(type: .contactAdd)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: settingsButton)
        
        let bookmarksButton = UIButton(type: .contactAdd)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarksButton)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetcher.articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleViewCell
        
        let item = fetcher.articles[indexPath.row]
        
        cell.title.text = item.title
        cell.timeSincePublished.text = item.timeSincePublished
        cell.articleDescription.text = item.description
        cell.provider.text = item.provider
        cell.category.text = item.category
        
        return cell
    }
    
}

extension ArticleViewController: FetcherDelegate {
    func finishedFetching() {
        tableView.reloadData()
    }
}

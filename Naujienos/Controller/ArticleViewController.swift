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
        setupRefreshControl()

        tableView.register(UINib(nibName: "ArticleViewCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
        
        fetcher.delegate = self
        
        refreshData()
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
    }
    
    @objc private func refreshData() {
        refreshControl?.beginRefreshing()
        fetcher.fetch()
    }
    
    private func setupNavigationBarItems() {
        let settingsButton = UIButton(type: .contactAdd)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: settingsButton)
        
        let bookmarksButton = UIButton(type: .contactAdd)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarksButton)
    }
    
    // MARK: - TableView methods
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
    
    // MARK: - Navigation methods
    @objc private func openSettings() {
        let vc = SettingsViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ArticleViewController: FetcherProtocol {
    func finishedFetching() {
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
}

extension ArticleViewController: SettingsProtocol {
    func settingsUpdated() {
        refreshData()
    }
}

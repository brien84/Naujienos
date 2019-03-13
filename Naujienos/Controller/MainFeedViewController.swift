//
//  MainFeedViewController.swift
//  Naujienos
//
//  Created by Marius on 13/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class MainFeedViewController: ArticleViewController {
    
    let fetcher = ArticleFetcher()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        setupRefreshControl()

        fetcher.delegate = self
        
        refreshData()
    }
    
    /// Reloads Bookmarks when app returns from other VCs, which might have modified Bookmarks
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookmarks = Bookmarks()
    }
    
    @objc private func refreshData() {
        refreshControl?.beginRefreshing()
        fetcher.fetch()
    }
    
    // MARK: - Setup methods
    private func setupNavigationBarItems() {
        let settingsButton = UIButton(type: .contactAdd)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: settingsButton)
        
        let bookmarksButton = UIButton(type: .contactAdd)
        bookmarksButton.addTarget(self, action: #selector(openBookmarks), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarksButton)
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
    }
    
    // MARK: - Navigation methods
    @objc private func openSettings() {
        let vc = SettingsViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func openBookmarks() {
        let vc = BookmarksViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainFeedViewController: FetcherProtocol {
    func finishedFetching() {
        datasource = fetcher.articles
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
}

extension MainFeedViewController: SettingsProtocol {
    func settingsUpdated() {
        refreshData()
    }
}

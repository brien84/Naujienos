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
    let titleView = NavigationTitleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        setupRefreshControl()

        fetcher.delegate = self
        
        refreshData()
    }
    
    /// Overrides with tableView.reloadData incase Bookmarks changed before returning to this VC
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc private func refreshData() {
        refreshControl?.beginRefreshing()
        titleView.isLoading = true
        fetcher.fetch()
    }
    
    // MARK: - Setup methods
    
    private func setupNavigationBarItems() {
    
        navigationItem.titleView = titleView
        
        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(UIImage(named: "settingsGear"), for: .normal)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: settingsButton)
        
        let bookmarksButton = UIButton(type: .custom)
        bookmarksButton.setImage(UIImage(named: "bookmarkOff"), for: .normal)
        bookmarksButton.addTarget(self, action: #selector(openBookmarks), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarksButton)
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
    }
    
    // MARK: - Navigation methods
    
    @objc private func openSettings() {
        let vc = SettingsViewController(style: .grouped)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func openBookmarks() {
        let vc = BookmarksViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainFeedViewController: FetcherDelegate {
    func finishedFetching() {
        datasource = fetcher.articles
        tableView.reloadData()
        refreshControl?.endRefreshing()
        titleView.isLoading = false
    }
}

extension MainFeedViewController: SettingsDelegate {
    func settingsUpdated() {
        refreshData()
    }
}

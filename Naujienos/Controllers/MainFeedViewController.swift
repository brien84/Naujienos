//
//  MainFeedViewController.swift
//  Naujienos
//
//  Created by Marius on 13/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

/// Acts as a root ViewController.
/// Fetches Articles with ArticleFetcher, then displays them in TableView.
/// Handles navigation to SettingsViewController and BookmarksViewController.
class MainFeedViewController: ArticleViewController {
    
    let fetcher = ArticleFetcher()
    let titleView = NavigationTitleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        setupRefreshControl()

        fetcher.delegate = self
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /// bookmarks property is set in superclass, everytime app returns to this ViewController.
        super.viewWillAppear(animated)
        /// Reloads data, since bookmarks might have been updated.
        tableView.reloadData()
    }
    
    @objc private func fetchData() {
        /// Immediately stops refreshControl animation and disables refreshControl
        /// to prevent it from being called again, while fetching is in progress.
        /// refreshControl will be re-setup after fetching has finished.
        refreshControl?.endRefreshing()
        refreshControl = nil
        
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
        refreshControl?.tintColor = Constants.Colors.red
        let refreshTitle = NSAttributedString(string: "Atnaujinti",
                                              attributes: [NSAttributedString.Key.foregroundColor:Constants.Colors.red])
        refreshControl?.attributedTitle = refreshTitle
        refreshControl?.addTarget(self, action: #selector(fetchData), for: UIControl.Event.valueChanged)
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
    func finishedFetching(_ articles: [Article], with error: Error?) {
        datasource = articles
        
        /// Sets backgroundView to nil to remove previous error label.
        tableView.backgroundView = nil
        
        /// If ArticleFetcher returns error or if datasource is empty, displays respective error.
        if error != nil {
            let label = ErrorLabel(frame: tableView.bounds, error: .Network)
            tableView.backgroundView = label
        } else if datasource.count == 0 {
            let label = ErrorLabel(frame: tableView.bounds, error: .EmptyDatasource)
            tableView.backgroundView = label
        }
        
        tableView.reloadData()
        titleView.isLoading = false
        /// Re-setups refreshControl after fetching is finished.
        setupRefreshControl()
    }
}

extension MainFeedViewController: SettingsDelegate {
    func settingsUpdated() {
        fetchData()
    }
}

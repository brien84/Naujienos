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
        refreshControl?.endRefreshing()
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
    func finishedFetching(with error: Error?) {
        tableView.backgroundView = nil
        datasource = fetcher.articles
        if error != nil {
            let label = ErrorLabel(frame: tableView.frame, error: .Network)
            tableView.backgroundView = label
        } else if datasource.count == 0 {
            let label = ErrorLabel(frame: tableView.frame, error: .EmptyDatasource)
            tableView.backgroundView = label
        }
        tableView.reloadData()
        titleView.isLoading = false
    }
}

extension MainFeedViewController: SettingsDelegate {
    func settingsUpdated() {
        refreshData()
    }
}

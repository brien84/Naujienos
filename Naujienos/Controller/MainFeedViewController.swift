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
    
    private func setupNavigationBarItems() {
        let settingsButton = UIButton(type: .contactAdd)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: settingsButton)
        
        let bookmarksButton = UIButton(type: .contactAdd)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarksButton)
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
    }
    
    @objc private func refreshData() {
        refreshControl?.beginRefreshing()
        fetcher.fetch()
    }
    
    // MARK: - Navigation methods
    @objc private func openSettings() {
        let vc = SettingsViewController()
        vc.delegate = self
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

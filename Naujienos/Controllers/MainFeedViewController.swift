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
    
    private var articles: ArticleManagerProtocol!
    private var settings: SettingsProtocol!
    private let titleView = NavigationTitleView()
    
    init(style: UITableView.Style = .plain, articleManager: ArticleManagerProtocol = ArticleManager(), settings: SettingsProtocol = Settings()) {
        super.init(style: style)
        
        self.articles = articleManager
        self.settings = settings
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        fetchArticles()
    }
    
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
        refreshControl?.addTarget(self, action: #selector(fetchArticles), for: UIControl.Event.valueChanged)
    }
    
    @objc private func fetchArticles() {
        /// Immediately stops refreshControl animation and disables refreshControl
        /// to prevent it from being called again, while fetching is in progress.
        /// refreshControl will be re-setup after fetching has finished.
        refreshControl?.endRefreshing()
        refreshControl = nil
        
        titleView.isLoading = true
        
        self.articles.fetch(using: .shared) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.setDatasource()
                    
                case .failure(let error):
                    self.tableView.backgroundView = nil
                    let label = ErrorLabel(frame: self.tableView.bounds, error: .network)
                    self.tableView.backgroundView = label
                    print("MainFeedViewController.fetchArticles: \(error)")
                }
                
                self.titleView.isLoading = false
                self.setupRefreshControl()
            }
        }
    }
    
    private func setDatasource() {
        self.datasource = self.articles.getArticles(with: self.settings.items)
        
        if self.datasource.count == 0 {
            self.tableView.backgroundView = nil
            let label = ErrorLabel(frame: self.tableView.bounds, error: .emptyDatasource)
            self.tableView.backgroundView = label
        }
 
        self.tableView.reloadData()
    }
    
    // MARK: - NotificationCenter methods
    
    weak var observer: NSObjectProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let observer = observer else { return }
        
        NotificationCenter.default.removeObserver(observer)
    }
    
    private func refreshSettings() {
        settings.load()
        setDatasource()
        tableView.reloadData()
    }
    
    private func refreshBookmarks() {
        bookmarks.load()
        tableView.reloadData()
    }
    
    // MARK: - Navigation methods
    
    @objc private func openSettings() {
        observer = NotificationCenter.default.addObserver(forName: .settingsDidUpdate, object: nil, queue: .main) { _ in
            self.refreshSettings()
        }
        let vc = SettingsViewController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func openBookmarks() {
        observer = NotificationCenter.default.addObserver(forName: .bookmarksDidUpdate, object: nil, queue: .main) { _ in
            self.refreshBookmarks()
        }
        let vc = BookmarksViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

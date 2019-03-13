//
//  WebViewController.swift
//  Naujienos
//
//  Created by Marius on 13/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit
import SafariServices
import WebKit

class WebViewController: UIViewController {

    var articleToDisplay: Article!
    private var bookmarks = Bookmarks()
    
    private var webView: WKWebView!
    private var loadingBar: UIProgressView!
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        loadingBar.removeFromSuperview()
    }
    
    override func loadView() {
        setupWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        
        guard let url = articleToDisplay?.url else { return }
        openArticle(with: url)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            loadingBar.progress =  Float(webView.estimatedProgress)
        }
    }
    
    private func openArticle(with url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func setupWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.allowsBackForwardNavigationGestures = true
        self.view = webView
    }
    
    private func setupNavigationController() {
        /// Setup loading bar.
        loadingBar = UIProgressView(progressViewStyle: .default)
        if let navigationBarBounds = self.navigationController?.navigationBar.bounds {
            /// Sets loading bar position to the bottom of navigation bar.
            loadingBar.frame = CGRect(x: 0, y: navigationBarBounds.maxY, width: navigationBarBounds.size.width, height: navigationBarBounds.size.height)
            /// Makes loading bar a bit more 'thicker'.
            loadingBar.transform = loadingBar.transform.scaledBy(x: 1, y: 1.3)
        }
        navigationController?.navigationBar.addSubview(loadingBar)
        
        // FIXME: bookmarkButton does visibly appear in navigation bar
        /// Setup bookmark button.
        let bookmarkButton = BookmarkButton()
        bookmarkButton.delegate = self
        bookmarkButton.isSelected = bookmarks.contains(articleToDisplay)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarkButton)
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingBar.isHidden = true
    }
    
    /// Opens link tapped inside WebView in a Safari browser.
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

extension WebViewController: BookmarkButtonProtocol {
    func bookmarkButtonTapped(_ sender: BookmarkButton, _ gestureRecognizer: UITapGestureRecognizer) {
        if bookmarks.contains(articleToDisplay) {
            bookmarks.remove(articleToDisplay)
        } else {
            bookmarks.add(articleToDisplay)
        }
        sender.isSelected = !sender.isSelected
    }
}


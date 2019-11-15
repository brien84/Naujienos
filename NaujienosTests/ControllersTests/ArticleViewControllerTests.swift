//
//  ArticleViewController.swift
//  NaujienosTests
//
//  Created by Marius on 07/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Naujienos

class ArticleViewControllerTests: XCTestCase {

    var sut: ArticleViewController!
    
    override func setUp() {
        sut = ArticleViewController()
    }

    override func tearDown() {
        sut = nil
    }

    func testTableViewExists() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertNotNil(sut.tableView)
    }
    
    func testTableViewRegistersArticleViewCell() {
        /// given
        let reuseIdentifier = "ArticleCell"

        /// when
        sut.loadViewIfNeeded()
        guard let registeredNibs = sut.tableView.value(forKey: "_nibMap") as? [String : UINib]
            else { return XCTFail()}

        /// then
        XCTAssertTrue(registeredNibs.contains { $0.key == reuseIdentifier })
    }
    
    func testTableViewBackgroundColorIsBackgroundGray() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.tableView.backgroundColor, Constants.Colors.backgroundGray)
    }
    
    func testTableViewEstimatedRowHeight() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.tableView.estimatedRowHeight, Constants.TableView.Article.estimatedRowHeight)
    }
    
    func testTableViewSeparatorStyleIsNone() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.tableView.separatorStyle, .none)
    }
    
    func testTableViewHasCorrectRowCount() {
        /// given
        sut.datasource = createTestArticles(count: 69)
        
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        let rowCount = sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rowCount, sut.datasource.count)
    }
    
    func testEachCellHasCorrectValuesSet() {
        /// given
        sut.datasource = createTestArticles(count: 6)
        sut.bookmarks = BookmarksMock()

        /// when
        sut.loadViewIfNeeded()
        
        /// then
        for (index, article) in sut.datasource.enumerated() {
            let indexPath = IndexPath(item: index, section: 0)
            let cell = sut.tableView(sut.tableView, cellForRowAt: indexPath) as! ArticleViewCell
            
            XCTAssertTrue(cell.bookmarkButton.delegate is ArticleViewController)
            XCTAssertEqual(cell.title.text, article.title)
            XCTAssertEqual(cell.timeSincePublished.text, article.timeSincePublished)
            XCTAssertEqual(cell.articleDescription.text, article.description)
            XCTAssertEqual(cell.articleImage.url, article.imageURL)
            XCTAssertEqual(cell.providerIcon.image, UIImage(named: article.provider))
            XCTAssertEqual(cell.timeSincePublished.text, article.timeSincePublished)
            XCTAssertEqual(cell.bookmarkButton.isSelected, sut.bookmarks.contains(article))
        }
    }
    
    func testSelectingCellOpensWebViewController() {
        /// given
        sut.datasource = createTestArticles(count: 6)
        _ = UINavigationController(rootViewController: sut)
        let testIndexPath = IndexPath(row: 0, section: 0)
        let expectation = XCTestExpectation(description: "Wait for UI to update.")
        
        /// when
        sut.loadViewIfNeeded()
        sut.tableView(sut.tableView, didSelectRowAt: testIndexPath)

        DispatchQueue.main.async {
            XCTAssertTrue(self.sut.navigationController?.topViewController is WebViewController)
            self.sut.navigationController?.topViewController?.loadViewIfNeeded()
            expectation.fulfill()
        }
        
        /// then
        wait(for: [expectation], timeout: 3)
    }
    
    // MARK: - Test Helpers
    
    private struct BookmarksMock: BookmarksProtocol {
        var plist: URL = URL(string: "some.url")!
        
        var articles: [Article] = []
        
        mutating func load() { }
            
        func save() { }
            
        func getArticles() -> [Article] { return [] }
    
        mutating func add(_ article: Article) { }
        
        mutating func remove(_ article: Article) { }
        
        func contains(_ article: Article) -> Bool {
            return false
        }
        
        func sendUpdateNotification() { }
    }

    private func createTestArticles(count: Int) -> [Article] {
        var articles = [Article]()
        
        guard count > 0 else { return articles }

        for article in 1...count {
            let newArticle = Article(url: URL(string: "some.url/\(article)")!,
                                  title: "someTitle",
                                  date: Date(),
                                  description: "someDescription",
                                  imageURL: URL(string: "some.url")!,
                                  provider: "someProvider",
                                  category: "someCategory")
            articles.append(newArticle)
        }
        
        return articles
    }
}

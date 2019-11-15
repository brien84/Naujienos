//
//  BookmarksViewControllerTests.swift
//  NaujienosTests
//
//  Created by Marius on 11/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Naujienos

class BookmarksViewControllerTests: XCTestCase {
    
    var sut: BookmarksViewController!

    override func tearDown() {
        sut = nil
    }

    func testTableViewExists() {
        /// given
        let bookmarks = BookmarksMock()
        sut = BookmarksViewController(style: .plain, bookmarks: bookmarks)
        
        /// when
        sut.loadViewIfNeeded()

        /// then
        XCTAssertNotNil(sut.tableView)
    }
    
    func testNavigationItemTitleIsSetCorrectly() {
        /// given
        let bookmarks = BookmarksMock()
        sut = BookmarksViewController(style: .plain, bookmarks: bookmarks)
        
        /// when
        sut.loadViewIfNeeded()

        /// then
        XCTAssertEqual(sut.navigationItem.title, Constants.NavigationControllerTitles.bookmarks)
    }
    
    func testDatasourceIsSet() {
        /// given
        let articles = createTestArticles(count: 69)
        let bookmarks = BookmarksMock(with: articles)
        sut = BookmarksViewController(style: .plain, bookmarks: bookmarks)
           
        /// when
        sut.loadViewIfNeeded()

        /// then
        XCTAssertEqual(sut.datasource.count, articles.count)
    }
    
    func testTableViewBackgroundViewIsErrorLabelWhenDatasourceIsEmpty() {
        /// given
        let bookmarks = BookmarksMock()
        sut = BookmarksViewController(style: .plain, bookmarks: bookmarks)
        
        /// when
        sut.loadViewIfNeeded()
        let label = sut.tableView.backgroundView as? ErrorLabel
        
        /// then
        XCTAssertEqual(label?.text, "Išsaugotų naujienų nėra")
    }
    
    // MARK: - Test Helpers
    
    private struct BookmarksMock: BookmarksProtocol {
        var plist = URL(string: "some.url")!
        var articles = [Article]()
        
        init(with articles: [Article] = []) {
            self.articles = articles
        }
        
        func load() { }
        func save() { }
        
        func getArticles() -> [Article] {
            return articles
        }
        
        func add(_ article: Article) { }
        func remove(_ article: Article) { }
        func contains(_ article: Article) -> Bool { return true }
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

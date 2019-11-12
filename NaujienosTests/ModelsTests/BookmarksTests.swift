//
//  BookmarksTests.swift
//  NaujienosTests
//
//  Created by Marius on 11/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Naujienos

class BookmarksTests: XCTestCase {
    
    var sut: Bookmarks!

    override func tearDown() {
        sut = nil
        deleteBookmarksTestFile()
    }
    
    func testBookmarksLoadsEmptyFile() {
        /// given
        createBookmarksTestFile(with: TestData.empty)
        sut = Bookmarks(plist: bookmarksTestFile)
        
        /// then
        XCTAssertEqual(sut.getArticles().count, 0)
    }
    
    func testBookmarksLoadsFileWithContent() {
        /// given
        createBookmarksTestFile(with: TestData.oneEntry)
        sut = Bookmarks(plist: bookmarksTestFile)
        
        /// then
        XCTAssertGreaterThan(sut.getArticles().count, 0)
    }
    
    func testBookmarksGetArticlesReturnsEmptyArticleArray() {
        /// given
        createBookmarksTestFile(with: TestData.empty)
        sut = Bookmarks(plist: bookmarksTestFile)
        
        /// when
        let articles = sut.getArticles()
        
        /// then
        XCTAssertEqual(articles.count, 0)
    }
    
    func testBookmarksGetArticlesReturnsArticles() {
        /// given
        createBookmarksTestFile(with: TestData.oneEntry)
        sut = Bookmarks(plist: bookmarksTestFile)
        
        /// when
        let articles = sut.getArticles()
        
        /// then
        XCTAssertGreaterThan(articles.count, 0)
    }
    
    func testBookmarksSavesArticlesToFile() {
        /// given
        createBookmarksTestFile(with: TestData.empty)
        sut = Bookmarks(plist: bookmarksTestFile)
        let articleCount = sut.getArticles().count
        
        /// when
        sut.add(newArticle)
        sut = nil
        sut = Bookmarks(plist: bookmarksTestFile)
        
        /// then
        XCTAssertGreaterThan(sut.getArticles().count, articleCount)
    }
    
    func testBookmarksAddsArticle() {
        /// given
        createBookmarksTestFile(with: TestData.empty)
        sut = Bookmarks(plist: bookmarksTestFile)
        let articleCount = sut.getArticles().count
        
        /// when
        sut.add(newArticle)
        
        /// then
        XCTAssertGreaterThan(sut.getArticles().count, articleCount)
    }
    
    func testBookmarksAddArticleSendsNotification() {
        /// given
        createBookmarksTestFile(with: TestData.empty)
        sut = Bookmarks(plist: bookmarksTestFile)
        let notificationExpectation = expectation(forNotification: .bookmarksDidUpdate, object: nil, handler: nil)
        
        /// when
        sut.add(newArticle)

        /// then
        wait(for: [notificationExpectation], timeout: 3)
    }
    
    func testBookmarksRemovesArticle() {
        /// given
        createBookmarksTestFile(with: TestData.oneEntry)
        sut = Bookmarks(plist: bookmarksTestFile)
        let articleCount = sut.getArticles().count
        
        /// when
        guard let article = sut.getArticles().first else { return XCTFail() }
        sut.remove(article)
        
        /// then
        XCTAssertLessThan(sut.getArticles().count, articleCount)
    }
    
    func testBookmarksRemoveArticleSendsNotification() {
        /// given
        createBookmarksTestFile(with: TestData.oneEntry)
        sut = Bookmarks(plist: bookmarksTestFile)
        let notificationExpectation = expectation(forNotification: .bookmarksDidUpdate, object: nil, handler: nil)

        /// when
        guard let article = sut.getArticles().first else { return XCTFail() }
        sut.remove(article)

        /// then
        wait(for: [notificationExpectation], timeout: 3)
    }
    
    func testBookmarksContainsArticle() {
        /// given
        createBookmarksTestFile(with: TestData.oneEntry)
        sut = Bookmarks(plist: bookmarksTestFile)
        
        /// when
        guard let article = sut.getArticles().first else { return XCTFail() }
        
        /// then
        XCTAssertTrue(sut.contains(article))
    }
    
    func testBookmarksDoesNotContainArticle() {
        /// given
        createBookmarksTestFile(with: TestData.oneEntry)
        sut = Bookmarks(plist: bookmarksTestFile)
        
        /// when
        let article = newArticle
        
        /// then
        XCTAssertFalse(sut.contains(article))
    }

    // MARK: - Test Helpers
    
    private let bookmarksTestFile = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TestBookmarks.plist"))!
    
    private func createBookmarksTestFile(with data: Any) {
        FileManager.default.createFile(atPath: bookmarksTestFile.path, contents: Data())
        
        let plistData = try? PropertyListSerialization.data(fromPropertyList: data, format: .xml, options: 0)
        try? plistData?.write(to: bookmarksTestFile)
    }

    private func deleteBookmarksTestFile() {
        try? FileManager.default.removeItem(at: bookmarksTestFile)
    }
    
    private var newArticle: Article {
        return Article(url: URL(string: "someUrl.url")!,
                       title: "someTitle",
                       date: Date(),
                       description: "someDescription",
                       imageURL: URL(string: "someUrl.url")!,
                       provider: "someProvider",
                       category: "someCategory")
    }

    private struct TestData {
        static let empty = [[String: Any]]()
        static let oneEntry = [["category": "_main",
                                "provider": "15min",
                                "title": "someTitle",
                                "date": Date(),
                                "imageURL": ["relative": "lpdsa.lt"],
                                "description": "someDescription",
                                "url": ["relative": "sssss.lt"]
                            ]]
    }
}

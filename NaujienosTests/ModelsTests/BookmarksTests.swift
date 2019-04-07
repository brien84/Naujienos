//
//  BookmarksTests.swift
//  NaujienosTests
//
//  Created by Marius on 12/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Naujienos

class BookmarksMock: Bookmarks {
    
    var articlesAsData: Data?
    
    override func load() {
        if let data = articlesAsData {
            let decoder = PropertyListDecoder()
            do {
                articles = try decoder.decode([Article].self, from: data)
            } catch {
                print("Error decoding articles, \(error)")
            }
        }
    }
    
    override func save() {
        let encoder = PropertyListEncoder()
        do {
            articlesAsData = try encoder.encode(articles)
        } catch {
            print("Error encoding articles, \(error)")
        }
    }
    
    override func add(_ article: Article) {
        articles.append(article)
    }
    
    override func remove(_ article: Article) {
        articles = articles.filter { $0.url != article.url }
    }
}

class BookmarksTests: XCTestCase {
    
    var sut: BookmarksMock!
    
    override func setUp() {
        sut = BookmarksMock()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testSavingAndLoadingArticle() {
        let newArticle = createArticle()
        sut.add(newArticle)
        
        sut.save()
        let savedData = sut.articlesAsData
        sut.load()
        let articleCount = sut.articles.count
        
        XCTAssertGreaterThan(savedData?.count ?? 0, 0)
        XCTAssertEqual(articleCount, 1)
    }
    
    func testAddArticleToBookmarks() {
        let newArticle = createArticle()
        let articleCount = sut.articles.count
        
        sut.add(newArticle)
 
        XCTAssertEqual(sut.articles.count, articleCount + 1)
    }
    
    func testRemoveArticleFromBookmarks() {
        let newArticle = createArticle()
        sut.add(newArticle)
        let articleCount = sut.articles.count
        
        sut.remove(newArticle)

        XCTAssertEqual(sut.articles.count, articleCount - 1)
    }
    
    func testBookmarksContainsArticle() {
        let newArticle = createArticle()
        sut.add(newArticle)
        
        let contains = sut.contains(newArticle)
        
        XCTAssertTrue(contains)
    }
    
    func testBookmarksDoesNotContainArticle() {
        let newArticle = createArticle()
        
        let contains = sut.contains(newArticle)
        
        XCTAssertFalse(contains)
    }
}

extension BookmarksTests {
    func createArticle() -> Article {
        return Article(url: URL(fileURLWithPath: UUID().uuidString),
                       title: UUID().uuidString,
                       date: Date(),
                       description: UUID().uuidString,
                       imageURL: URL(fileURLWithPath: UUID().uuidString),
                       provider: UUID().uuidString)
    }
}

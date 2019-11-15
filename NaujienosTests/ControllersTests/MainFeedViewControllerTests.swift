//
//  MainFeedViewControllerTests.swift
//  NaujienosTests
//
//  Created by Marius on 07/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Naujienos

class MainFeedViewControllerTests: XCTestCase {
    
    var sut: MainFeedViewController!

    override func setUp() {
        sut = MainFeedViewController()
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
    
    func testNavigationItemTitleViewIsNavigationTitleView() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertTrue(sut.navigationItem.titleView is NavigationTitleView)
    }
    
    func testLeftNavigationButtonHasImageNamedSettingsGear() {
        /// when
        sut.loadViewIfNeeded()
        guard let button = sut.navigationItem.leftBarButtonItems?.first?.customView as? UIButton
            else { return XCTFail("Left navigation item button is nil!") }
        
        /// then
        XCTAssertEqual(button.currentImage, UIImage(named: "settingsGear"))
    }
    
    func testLeftNavigationButtonHasTargetSet() {
        /// when
        sut.loadViewIfNeeded()
        guard let button = sut.navigationItem.leftBarButtonItems?.first?.customView as? UIButton
            else { return XCTFail("Left navigation item button is nil!") }
        
        /// then
        XCTAssertGreaterThan(button.allTargets.count, 0)
    }
    
    func testLeftNavigationButtonOpensSettingsViewController() {
        /// given
        _ = UINavigationController(rootViewController: sut)
        let expectation = XCTestExpectation(description: "Wait for UI to update.")
        
        /// when
        sut.loadViewIfNeeded()
        guard let button = sut.navigationItem.leftBarButtonItems?.first?.customView as? UIButton
            else { return XCTFail("Left navigation item button is nil!") }
        
        button.sendActions(for: .touchUpInside)

        DispatchQueue.main.async {
            XCTAssertTrue(self.sut.navigationController?.topViewController is SettingsViewController)
            expectation.fulfill()
        }
        
        /// then
        wait(for: [expectation], timeout: 3)
    }
    
    func testRightNavigationButtonHasImageNamedBookmarkOff() {
        /// when
        sut.loadViewIfNeeded()
        guard let button = sut.navigationItem.rightBarButtonItems?.first?.customView as? UIButton
            else { return XCTFail("Right navigation item button is nil!") }
        
        /// then
        XCTAssertEqual(button.currentImage, UIImage(named: "bookmarkOff"))
    }
    
    func testRightNavigationButtonHasTargetSet() {
        /// when
        sut.loadViewIfNeeded()
        guard let button = sut.navigationItem.rightBarButtonItems?.first?.customView as? UIButton
            else { return XCTFail("Right navigation item button is nil!") }
        
        /// then
        XCTAssertGreaterThan(button.allTargets.count, 0)
    }
    
    func testLeftNavigationButtonOpensBookmarksViewController() {
        /// given
        _ = UINavigationController(rootViewController: sut)
        let expectation = XCTestExpectation(description: "Wait for UI to update.")
        
        /// when
        sut.loadViewIfNeeded()
        guard let button = sut.navigationItem.rightBarButtonItems?.first?.customView as? UIButton
            else { return XCTFail("Right navigation item button is nil!") }
        
        button.sendActions(for: .touchUpInside)

        DispatchQueue.main.async {
            XCTAssertTrue(self.sut.navigationController?.topViewController is BookmarksViewController)
            expectation.fulfill()
        }
        
        /// then
        wait(for: [expectation], timeout: 3)
    }
    
    func testRefreshControlIsNilWhileFetching() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertNil(sut.refreshControl)
    }
    
    func testTitleViewIsLoadingWhileFetching() {
        /// when
        sut.loadViewIfNeeded()
        /// force casting, because we confirm that NavigationTitleView exists in other test.
        let titleView = sut.navigationItem.titleView as! NavigationTitleView
        
        /// then
        XCTAssertTrue(titleView.isLoading)
    }
    
    func testTableViewDatasourceIsSetAfterFetching() {
        /// given
        let articleCount = 69
        let articleManager = ArticleManagerMock(isFetchSuccessful: true, articleCount: articleCount)
        sut = MainFeedViewController(style: .plain, articleManager: articleManager, settings: SettingsMock())
        let expectation = XCTestExpectation(description: "Wait for async to complete.")

        /// when
        sut.loadViewIfNeeded()
        DispatchQueue.main.async {
            XCTAssertEqual(self.sut.datasource.count, articleCount)
            expectation.fulfill()
        }

        /// then
        wait(for: [expectation], timeout: 3)
    }

    func testTableViewBackgroundViewIsEmptyDatasourceErrorLabel() {
        /// given
        let articleManager = ArticleManagerMock(isFetchSuccessful: true, articleCount: 0)
        sut = MainFeedViewController(style: .plain, articleManager: articleManager)
        let expectation = XCTestExpectation(description: "Wait for UI to update.")

        /// when
        sut.loadViewIfNeeded()
        
        DispatchQueue.main.async {
            let label = self.sut.tableView.backgroundView as? ErrorLabel
            XCTAssertEqual(label?.text, "Pasirinktoms rubrikoms naujienų nėra")
            expectation.fulfill()
        }

        /// then
        wait(for: [expectation], timeout: 3)
    }

    func testTableViewBackgroundViewIsNetworkErrorLabel() {
        /// given
        let articleManager = ArticleManagerMock(isFetchSuccessful: false, articleCount: 0)
        sut = MainFeedViewController(style: .plain, articleManager: articleManager)
        let expectation = XCTestExpectation(description: "Wait for UI to update.")

        /// when
        sut.loadViewIfNeeded()
        
        DispatchQueue.main.async {
            let label = self.sut.tableView.backgroundView as? ErrorLabel
            XCTAssertEqual(label?.text, "Nepavyko pasiekti naujienų serverio")
            expectation.fulfill()
        }
        
        /// then
        wait(for: [expectation], timeout: 3)
    }
    
    func testTitleViewIsNotLoadingAfterFetching() {
        /// given
        let articleManager = ArticleManagerMock(isFetchSuccessful: true, articleCount: 0)
        sut = MainFeedViewController(style: .plain, articleManager: articleManager)
        let expectation = XCTestExpectation(description: "Wait for UI to update.")
        
        /// when
        sut.loadViewIfNeeded()
        /// force casting, because we confirm that NavigationTitleView exists in other test.
        let titleView = sut.navigationItem.titleView as! NavigationTitleView
        
        DispatchQueue.main.async {
            XCTAssertFalse(titleView.isLoading)
            expectation.fulfill()
        }
        
        /// then
        wait(for: [expectation], timeout: 3)
    }
    
    func testRefreshControlIsSetupAfterFetching() {
        /// given
        let articleManager = ArticleManagerMock(isFetchSuccessful: true, articleCount: 0)
        sut = MainFeedViewController(style: .plain, articleManager: articleManager)
        let expectation = XCTestExpectation(description: "Wait for UI to update.")
        
        /// when
        sut.loadViewIfNeeded()

        DispatchQueue.main.async {
            XCTAssertNotNil(self.sut.refreshControl)
            expectation.fulfill()
        }
        
        /// then
        wait(for: [expectation], timeout: 3)
    }
    
    func testRefreshControlTriggersArticleFetching() {
        let articleManager = ArticleManagerMock(isFetchSuccessful: true, articleCount: 0)
        sut = MainFeedViewController(style: .plain, articleManager: articleManager)
        let expectation = XCTestExpectation(description: "Wait for UI to update.")
        
        /// when
        sut.loadViewIfNeeded()

        DispatchQueue.main.async {
            XCTAssertNotNil(self.sut.refreshControl)
            expectation.fulfill()
        }
        
        /// then
        wait(for: [expectation], timeout: 3)
        
        self.sut.refreshControl?.sendActions(for: .valueChanged)
        XCTAssertNil(self.sut.refreshControl)
    }
    
    // MARK: - Test Helpers
    
    private enum NetworkError: Error {
        case badData
    }

    private class ArticleManagerMock: ArticleManagerProtocol {
        private let isFetchSuccessful: Bool
        
        var articles = [Article]()
        
        init(isFetchSuccessful: Bool, articleCount: Int) {
            self.isFetchSuccessful = isFetchSuccessful
            
            guard articleCount > 0 else { return }
            
            for article in 1...articleCount {
                let newArticle = Article(url: URL(string: "some.url/\(article)")!,
                                      title: "someTitle",
                                      date: Date(),
                                      description: "someDescription",
                                      imageURL: URL(string: "some.url")!,
                                      provider: "someProvider",
                                      category: "someCategory")
                articles.append(newArticle)
            }
        }
        
        func getArticles(with settings: [SettingsItem]) -> [Article] {
            return articles
        }
        
        func fetch(using session: URLSession, completionHandler: @escaping (Result<Void, Error>) -> Void) {
            completionHandler(self.isFetchSuccessful ? .success(()) : .failure(NetworkError.badData))
        }
    }
    
    private struct SettingsMock: SettingsProtocol {
        var plist: URL = URL(string: "some.url")!
        
        var items: [SettingsItem] = [SettingsItem(provider: "someProvider", categories: ["someCategory" : true])]
        
        mutating func load() { }
        
        func save() { }
    }
}



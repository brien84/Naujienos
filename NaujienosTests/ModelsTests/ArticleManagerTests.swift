//
//  ArticleManagerTests.swift
//  NaujienosTests
//
//  Created by Marius on 07/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Naujienos

class ArticleManagerTests: XCTestCase {
    
    func makeMockURLSession(with data: TestData) -> URLSession {
        URLProtocolMock.testData = Data(data.rawValue.utf8)
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        
        return session
    }
    
    var sut: ArticleManager!

    override func setUp() {
        sut = ArticleManager()
    }

    override func tearDown() {
       sut = nil
    }
    
    func testArticleCountOnInitIs0() {
        /// when
        let articleCount = sut.articles.count
        
        /// then
        XCTAssertEqual(articleCount, 0, "articleCount should be 0.")
    }
    
    func testArticleFetchingWithGoodResponseData() {
        /// given
        let expectation = XCTestExpectation(description: "Downloading articles")
        
        let session = makeMockURLSession(with: .goodData)

        /// when
        sut.fetch(using: session) { result in
            XCTAssertGreaterThan(self.sut.articles.count, 0)
            expectation.fulfill()
        }

        /// then
        wait(for: [expectation], timeout: 3)
    }
    
    func testArticleFetchingWithBadResponseData() {
        /// given
        let expectation = XCTestExpectation(description: "Downloading articles")

        let session = makeMockURLSession(with: .badData)

        /// when
        sut.fetch(using: session) { result in
            XCTAssertNil(try? result.get())
            expectation.fulfill()
        }

        /// then
        wait(for: [expectation], timeout: 3)
    }
    
    func testArticleFetchingWithNoNetworkConnection() {
        /// given
        let expectation = XCTestExpectation(description: "Downloading articles")

        let session = makeMockURLSession(with: .noData)

        /// when
        sut.fetch(using: session) { result in
            XCTAssertNil(try? result.get())
            expectation.fulfill()
        }

        /// then
        wait(for: [expectation], timeout: 3)
    }
}

class URLProtocolMock: URLProtocol {
    /// this is the data we're expecting to send back
    static var testData: Data?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    /// as soon as loading starts, send back our test data or an empty Data instance, then end loading
    override func startLoading() {
        self.client?.urlProtocol(self, didLoad: URLProtocolMock.testData ?? Data())
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}

enum TestData: String {
    case goodData = #"[{"imageURL":"https:\/\/s1.15min.lt\/static\/cache\/OTI1eDYxMCwxMTU1eDgyMyw3MjE4ODgsb3JpZ2luYWwsLGlkPTQwNDE0MTImZGF0ZT0yMDE4JTJGMDclMkYxMyw0MTU5MTk2NjUx\/klaipedos-senamiestis-5b48acde33240.jpg","provider":"15min","description":"Specialiųjų tyrimų tarnyba (STT) pradėjo ikiteisminį tyrimą dėl Klaipėdos senamiestyje (Daržų g. 14, Didžioji Vandens g. 26 ir 28) atliktų griovimo darbų pagal Kultūros paveldo departamento (KPD) surinktą medžiagą. Ikiteisminis tyrimas pradėtas dėl didelės mokslinės, istorinės ir kultūrinės vertės turinčių vertybių sunaikinimo.","category":"_main","title":"Dėl Klaipėdos senamiestyje nugriautų pastatų – ikiteisminis tyrimas","url":"https:\/\/www.15min.lt\/naujiena\/aktualu\/klaipedos-zinios\/del-klaipedos-senamiestyje-nugriautu-pastatu-ikiteisminis-tyrimas-839-1227268?utm_source=rssfeed_default&utm_medium=rss&utm_campaign=rssfeed","date":"2019-11-05T12:52:55Z","id":1951},{"imageURL":"https:\/\/s2.15min.lt\/static\/cache\/OTI1eDYxMCwyMDEweDk0Nyw3MjE4ODgsb3JpZ2luYWwsLGlkPTQ5ODk5OTgmZGF0ZT0yMDE5JTJGMDklMkYyOSw0MjIwNTM3NDAw\/lff-taures-nugaletoja-marijampoles-suduva-5d90d641ad01b.jpg","provider":"15min","description":"Dešiniojo krašto gynėjas Andro Švrljuga dar mažiausiai metus vilkės Marijampolės „Sūduvos“ marškinėlius. 34 metų kroatas kroatas pratęsė sutartį su Lietuvos čempionais iki 2020 m. sezono pabaigos.","category":"sport","title":"Andro Švrljuga pratęsė sutartį su „Sūduva“: „Kaip sakoma, meilei reikia dviejų“","url":"https:\/\/www.15min.lt\/sportas\/naujiena\/futbolas\/andro-svrljuga-pratese-sutarti-su-suduva-kaip-sakoma-meilei-reikia-dvieju-24-1227270?utm_source=rssfeed_sportas&utm_medium=rss&utm_campaign=rssfeed","date":"2019-11-05T12:52:33Z","id":1952}]"#
    case badData = #"someGibberish"#
    case noData
}

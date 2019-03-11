//
//  SettingsTests.swift
//  NaujienosTests
//
//  Created by Marius on 11/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Naujienos

class SettingsTests: XCTestCase {

    func testSettingsLoadItems() {
        // given
        let sut = Settings()
        // when
        let numberOfItems = sut.items.count
        // then
        XCTAssertGreaterThan(numberOfItems, 0)
    }
    
}

//
//  SettingsTests.swift
//  NaujienosTests
//
//  Created by Marius on 11/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Naujienos

class SettingsTests: XCTestCase {
    
    var sut: Settings!

    override func setUp() {
        createSettingsFileCopyForTesting()
        sut = Settings(plist: settingsTestFile)
    }

    override func tearDown() {
        deleteSettingsFileCopy()
        sut = nil
    }
    
    func testSettingsLoadsSettingsItemsFromFile() {
        /// then
        XCTAssertGreaterThan(sut.items.count, 0)
    }
    
    func testSettingsSavesSettingsItems() {
        /// given
        let itemCount = sut.items.count
        
        /// when
        sut.items = sut.items.dropLast()
        sut.save()
        sut.load()
        
        /// then
        XCTAssertLessThan(sut.items.count, itemCount)
    }
    
    func testSettingsItemGetEnabledCategories() {
        /// given
        guard let item = sut.items.first else { return XCTFail() }
        let categoryKeys = item.categories.map { $0.key }
        let categoriesCount = categoryKeys.count
        
        /// when
        categoryKeys.forEach {
            item.categories[$0] = true
        }
        
        /// then
        XCTAssertEqual(item.getEnabledCategories().count, categoriesCount)
    }
    
    func testSettingsItemGetEnabledCategoriesReturnEmptyArray() {
        /// given
        guard let item = sut.items.first else { return XCTFail() }
        let categoryKeys = item.categories.map { $0.key }
        
        /// when
        categoryKeys.forEach {
            item.categories[$0] = false
        }
        
        XCTAssertEqual(item.getEnabledCategories().count, 0)
    }
    
    // MARK: - Test Helpers
    
    private let settingsTestFile = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TestSettings.plist"))!
    
    private func createSettingsFileCopyForTesting() {
        guard let defaultsPath = Bundle.main.path(forResource: "DefaultSettings", ofType: "plist")
            else { fatalError("Could not find DefaultSettings.plist in bundle.") }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: defaultsPath))
            FileManager.default.createFile(atPath: settingsTestFile.path, contents: data)
        } catch {
            fatalError("Could not create Settings test file.")
        }
    }
    
    private func deleteSettingsFileCopy() {
        try? FileManager.default.removeItem(at: settingsTestFile)
    }
}

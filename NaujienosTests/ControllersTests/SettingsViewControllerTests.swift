//
//  SettingsViewControllerTests.swift
//  NaujienosTests
//
//  Created by Marius on 11/11/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import XCTest
@testable import Naujienos

class SettingsViewControllerTests: XCTestCase {
    
    var sut: SettingsViewController!

    override func setUp() {
        sut = SettingsViewController(style: .plain, settings: SettingsMock())
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
    
    func testTableViewRegistersSettingsViewCell() {
        /// given
        let reuseIdentifier = "Cell"
        
        /// when
        sut.loadViewIfNeeded()
        guard let registeredNibs = sut.tableView.value(forKey: "_nibMap") as? [String : UINib]
            else { return XCTFail()}
        
        /// then
        XCTAssertTrue(registeredNibs.contains { $0.key == reuseIdentifier })
    }
    
    func testTableViewSetsFooterView() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertNotNil(sut.tableView.tableFooterView)
    }
    
    func testTableViewBackgroundColor() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.tableView.backgroundColor, Constants.Colors.backgroundWhite)
    }
    
    func testTableViewSectionHeaderHeight() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.tableView.sectionHeaderHeight, Constants.TableView.Settings.sectionHeaderHeight)
    }
    
    func testTableViewSectionFooterHeight() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.tableView.sectionFooterHeight, Constants.TableView.Settings.sectionFooterHeight)
    }
    
    func testTableViewRowHeight() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        XCTAssertEqual(sut.tableView.rowHeight, Constants.TableView.Settings.rowHeight)
    }
    
    func testTableViewSectionCountIsNotZero() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        let sectionCount = sut.numberOfSections(in: sut.tableView)
        XCTAssertGreaterThan(sectionCount, 0)
    }
    
    func testTableViewHeaderHasCorrectValuesSet() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        for (index, section) in sut.datasource.enumerated() {
            let header = sut.tableView(sut.tableView, viewForHeaderInSection: index) as! SettingsSectionHeader
            
            XCTAssertEqual(header.title.text, section.item.provider)
            XCTAssertEqual(header.icon.image, UIImage(named: section.item.provider))
            XCTAssertEqual(header.section, index)
            XCTAssertNotNil(header.delegate)
        }
    }
    
    func testTableViewRowCountIsZeroWhenAllSectionsAreCollapsed() {
        /// when
        sut.loadViewIfNeeded()
        sut.datasource.indices.forEach { sut.datasource[$0].isCollapsed = true }
        
        /// then
        sut.datasource.indices.forEach {
            let rowCount = sut.tableView(sut.tableView, numberOfRowsInSection: $0)
            XCTAssertEqual(rowCount, 0)
        }
    }
    
    func testTableViewRowCountIsGreaterThanZeroWhenSectionsAreExpanded() {
        /// when
        sut.loadViewIfNeeded()
        sut.datasource.indices.forEach { sut.datasource[$0].isCollapsed = false }
        
        /// then
        sut.datasource.indices.forEach {
            let rowCount = sut.tableView(sut.tableView, numberOfRowsInSection: $0)
            XCTAssertGreaterThan(rowCount, 0)
        }
    }
    
    func testTableViewCellsHaveCorrectTextSet() {
        /// when
        sut.loadViewIfNeeded()
        
        /// then
        for (sectionIndex, section) in sut.datasource.enumerated() {
            let categories = section.item.categories
            categories.keys.sorted().enumerated().forEach { index, key in
                let indexPath = IndexPath(item: index, section: sectionIndex)
                let cell = sut.tableView(sut.tableView, cellForRowAt: indexPath) as! SettingsViewCell
                
                XCTAssertEqual(cell.title.text, key.translateToLT)
            }
        }
    }
    
    func testTableViewCellsAccessoryTypeIsNoneForDeselectedCategories() {
        /// when
        sut.loadViewIfNeeded()
        /// sets all categories to false
        sut.datasource.indices.forEach { sectionIndex in
            sut.datasource[sectionIndex].item.categories.keys.forEach { key in
                sut.datasource[sectionIndex].item.categories[key] = false
            }
        }
        
        /// then
        for (sectionIndex, section) in sut.datasource.enumerated() {
            let categories = section.item.categories
            categories.keys.sorted().enumerated().forEach { index, key in
                let indexPath = IndexPath(item: index, section: sectionIndex)
                let cell = sut.tableView(sut.tableView, cellForRowAt: indexPath) as! SettingsViewCell
                
                XCTAssertEqual(cell.accessoryType, .none)
            }
        }
    }
    
    func testTableViewCellsAccessoryTypeIsCheckmarkForSelectedCategories() {
        /// when
        sut.loadViewIfNeeded()
        /// sets all categories to true
        sut.datasource.indices.forEach { sectionIndex in
            sut.datasource[sectionIndex].item.categories.keys.forEach { key in
                sut.datasource[sectionIndex].item.categories[key] = true
            }
        }
        
        /// then
        for (sectionIndex, section) in sut.datasource.enumerated() {
            let categories = section.item.categories
            categories.keys.sorted().enumerated().forEach { index, key in
                let indexPath = IndexPath(item: index, section: sectionIndex)
                let cell = sut.tableView(sut.tableView, cellForRowAt: indexPath) as! SettingsViewCell
                
                XCTAssertEqual(cell.accessoryType, .checkmark)
            }
        }
    }
    
    func testSelectingRowTogglesIsCategorySelected() {
        /// given
        let testIndexPath = IndexPath(row: 0, section: 0)

        /// when
        sut.loadViewIfNeeded()
        /// expand sections, so rows could be visible
        sut.datasource.indices.forEach { sut.datasource[$0].isCollapsed = false }
        sut.tableView.reloadData()
        
        let item = sut.datasource[testIndexPath.section].item
        let key = item.categories.keys.sorted()[testIndexPath.row]
        let isSelected = item.categories[key]
        
        /// then
        sut.tableView(sut.tableView, didSelectRowAt: testIndexPath)
        XCTAssertNotEqual(item.categories[key], isSelected)
    }
    
    func testSelectingRowSendsNotification() {
        /// given
        let notificationExpectation = expectation(forNotification: .settingsDidUpdate, object: nil, handler: nil)

        /// when
        sut.loadViewIfNeeded()
        sut.datasource.indices.forEach { sut.datasource[$0].isCollapsed = false }
        sut.tableView.reloadData()
        self.sut.tableView(self.sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        /// then
        wait(for: [notificationExpectation], timeout: 3)
    }
    
    func testSettingsSectionHeaderDelegateTogglesCollapse() {
        /// given
        let section = 0
        
        /// then
        sut.loadViewIfNeeded()
        sut.tableView.reloadData()
        
        let header = sut.tableView(sut.tableView, viewForHeaderInSection: section) as! SettingsSectionHeader
        let isCurrentlyCollapsed = sut.datasource[section].isCollapsed
        
        /// then
        sut.toggleCollapse(for: header, at: section)
        XCTAssertNotEqual(sut.datasource[section].isCollapsed, isCurrentlyCollapsed)
    }

    // MARK: - Test Helpers
    
    private struct SettingsMock: SettingsProtocol {
        var plist = URL(string: "some.url")!
        var items = [SettingsItem]()
        
        init() {
            self.items = createSettingsItems()
        }
        
        mutating func load() { }
        
        func save() { }
        
        private func createSettingsItems() -> [SettingsItem] {
            let settingsItem0 = SettingsItem(provider: "15min",
                                             categories: ["_main" : true, "sport" : true, "business" : true])
            let settingsItem1 = SettingsItem(provider: "delfi",
                                             categories: ["science" : true, "lifestyle" : true, "crime" : true])
            
            return [settingsItem0, settingsItem1]
        }
    }
}

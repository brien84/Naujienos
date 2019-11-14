//
//  SettingsViewController.swift
//  Naujienos
//
//  Created by Marius on 12/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

/// Stores reference to SettingsItem and keeps track of it's view state.
struct Section {
    let item: SettingsItem
    var isCollapsed: Bool
}

/// Loads Settings instance, maps SettingsItems to datasource array of Section,
/// then displays datasource in TableView.
/// Selecting rows switches SettingsItem categories bool property's value.
/// If changes were made, saves Settings model on exit and calls settingsUpdated() delegate method.
///
/// - Note: Since Section's item property contains reference to SettingsItem (class) objects,
/// we can safely work with datasource array in TableView
/// and only use Settings instance for loading and saving SettingsItems.
class SettingsViewController: UITableViewController {
    
    var datasource = [Section]()
    private var settings: SettingsProtocol!
    
    init(style: UITableView.Style = .plain, settings: SettingsProtocol = Settings()) {
        super.init(style: .plain)
        self.settings = settings
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = Constants.NavigationControllerTitles.settings
        
        setupTableView()
        
        /// Adds SettingsItem to datasource array. By default all items are collapsed.
        datasource = settings.items.map { Section(item: $0, isCollapsed: true) }
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "SettingsSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
        tableView.register(UINib(nibName: "SettingsViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Constants.Colors.backgroundWhite
        tableView.sectionHeaderHeight = Constants.TableView.Settings.sectionHeaderHeight
        tableView.sectionFooterHeight = Constants.TableView.Settings.sectionFooterHeight
        tableView.rowHeight = Constants.TableView.Settings.rowHeight
    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! SettingsSectionHeader
        
        header.title.text = datasource[section].item.provider
        header.icon.image = UIImage(named: datasource[section].item.provider)
        header.setCollapsionIndicator(to: datasource[section].isCollapsed)
        header.section = section
        header.delegate = self
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].isCollapsed ? 0 : datasource[section].item.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingsViewCell
        
        let item = datasource[indexPath.section].item
        let categoryKeys = item.categories.keys.sorted()
        let categoryName = categoryKeys[indexPath.row]
        
        cell.title.text = categoryName.translateToLT
        
        if let isCategorySelected = item.categories[categoryName] {
            cell.accessoryType = isCategorySelected ? .checkmark : .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = datasource[indexPath.section].item
        let categoryKeys = item.categories.keys.sorted()
        let categoryName = categoryKeys[indexPath.row]
        
        if let isCategorySelected = item.categories[categoryName] {
            item.categories[categoryName] = !isCategorySelected
            settings.save()
            sendUpdateNotification()
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func sendUpdateNotification() {
        NotificationCenter.default.post(name: .settingsDidUpdate, object: nil)
    }
}

extension Notification.Name {
    static let settingsDidUpdate = Notification.Name("settingsDidUpdate")
}

extension SettingsViewController: SettingsSectionHeaderDelegate {
    func toggleCollapse(for header: SettingsSectionHeader, at section: Int) {

        let isCollapsed = !datasource[section].isCollapsed
        datasource[section].isCollapsed = isCollapsed
        header.setCollapsionIndicator(to: isCollapsed)

        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}

extension String {
    var translateToLT: String {
        switch self {
        case "_main":
            return "Pagrindinės"
        case "sport":
            return "Sportas"
        case "business":
            return "Verslas"
        case "science":
            return "Mokslas"
        case "auto":
            return "Automobiliai"
        case "lifestyle":
            return "Gyvenimo būdas"
        case "crime":
            return "Nusikaltimai"
        case "health":
            return "Sveikata"
        default:
            return self
        }
    }
}

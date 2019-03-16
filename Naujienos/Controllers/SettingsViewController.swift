//
//  SettingsViewController.swift
//  Naujienos
//
//  Created by Marius on 12/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

protocol SettingsDelegate: AnyObject {
    func settingsUpdated()
}

struct Section {
    let item: SettingsItem
    var isCollapsed: Bool
}

/// Displays Settings model in TableView.
/// Selecting rows switches categories bool property's value.
/// If changes were made, saves Settings model on exit and calls settingsUpdated() delegate method.
class SettingsViewController: UITableViewController {
    
    weak var delegate: SettingsDelegate?
    
    private let settings = Settings()
    private var datasource = [Section]()
    
    private var changesMade = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Adds SettingsItem to datasource array. By default all items are collapsed.
        settings.items.forEach { datasource.append(Section(item: $0, isCollapsed: true)) }
        
        /// Setup NavigationController
        navigationItem.title = "Nustatymai"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:Constants.Colors.red,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 20)!
        ]
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = Constants.Colors.red
        
        /// Setup TableView
        tableView.register(UINib(nibName: "SettingsSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
        tableView.register(UINib(nibName: "SettingsViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .white
        
        tableView.sectionHeaderHeight = Constants.TableView.Settings.sectionHeaderHeight
        tableView.sectionFooterHeight = Constants.TableView.Settings.sectionFooterHeight
        
        /// Add TableViewHeader
        if let tableHeaderView = Bundle.main.loadNibNamed("SettingsTableHeaderView", owner: nil, options: nil)?.first as? UIView {
            tableHeaderView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: tableView.sectionHeaderHeight / 3)
            self.tableView.tableHeaderView = tableHeaderView
        }
    }
    
    /// If changes were made, saves Settings and calls delegate method.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if changesMade {
            settings.save()
            delegate?.settingsUpdated()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! SettingsSectionHeader
        header.title.text = datasource[section].item.provider
        header.icon.image = UIImage(named: datasource[section].item.provider)
        header.setCollapsed(to: datasource[section].isCollapsed)
        header.section = section
        header.delegate = self
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].isCollapsed ? 0 : datasource[section].item.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingsViewCell
        
        ///
        let categories = datasource[indexPath.section].item.categories
        let categoryKeys = categories.keys.sorted()
        let categoryName = categoryKeys[indexPath.row]
        
        cell.title.text = categoryName
        
        ///
        if let categoryBool = categories[categoryName] {
            cell.accessoryType = categoryBool ? .checkmark : .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changesMade = true
        
        ///
        let item = datasource[indexPath.section].item
        let categoryKeys = item.categories.keys.sorted()
        let categoryName = categoryKeys[indexPath.row]
        
        if let categoryBool = item.categories[categoryName] {
            item.categories[categoryName] = !categoryBool
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

}

extension SettingsViewController: SettingsSectionHeaderDelegate {
    func toggleCollapse(for header: SettingsSectionHeader, at section: Int) {

        let isCollapsed = !datasource[section].isCollapsed

        datasource[section].isCollapsed = isCollapsed
        header.setCollapsed(to: isCollapsed)

        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}

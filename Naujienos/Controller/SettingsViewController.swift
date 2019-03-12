//
//  SettingsViewController.swift
//  Naujienos
//
//  Created by Marius on 12/03/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

protocol SettingsProtocol: AnyObject {
    func settingsUpdated()
}
/// Displays Settings model in TableView.
/// Selecting rows switches categories bool property's value.
/// If changes were made, saves Settings model on exit and calls settingsUpdated() delegate method.
class SettingsViewController: UITableViewController {
    
    weak var delegate: SettingsProtocol?
    
    private let settings = Settings()
    private var changesMade = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if changesMade {
            settings.save()
            delegate?.settingsUpdated()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settings.items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: 45))
        let label = UILabel(frame: view.bounds)
        label.text = settings.items[section].provider
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.items[section].categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        ///
        let categories = settings.items[indexPath.section].categories
        let categoryKeys = categories.keys.sorted()
        let categoryName = categoryKeys[indexPath.row]
        
        cell.textLabel?.text = categoryName
        
        ///
        if let categoryBool = categories[categoryName] {
            cell.accessoryType = categoryBool ? .checkmark : .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changesMade = true
        
        ///
        let item = settings.items[indexPath.section]
        let categoryKeys = item.categories.keys.sorted()
        let categoryName = categoryKeys[indexPath.row]
        
        if let categoryBool = item.categories[categoryName] {
            item.categories[categoryName] = !categoryBool
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

}

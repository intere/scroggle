//
//  MenuTableViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/8/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    struct CellIdentifiers {
        static let headerCell = "HeaderCell"
        static let buttonCell = "ButtonCell"
    }

    var menu: MenuInfo? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let menu = menu else {
            return 0
        }

        return menu.buttons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.buttonCell, for: indexPath)
        guard let buttonCell = cell as? ButtonTableViewCell else {
            return cell
        }

        buttonCell.cellInfo = menu?.buttons[indexPath.row]

        return buttonCell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.headerCell) as? MenuHeaderTableViewCell else {
            return nil
        }

        cell.title = menu?.title

        return cell
    }

}

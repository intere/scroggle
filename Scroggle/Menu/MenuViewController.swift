//
//  MenuViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/8/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    /// A reference to the embedded MenuTableViewController
    var menuTableVC: MenuTableViewController? {
        didSet {
//            menu = buildMenu()
        }
    }

    /// Sets the menuInfo
    var menu: MenuInfo? {
        get {
            return menuTableVC?.menu
        }
        set {
            menuTableVC?.menu = newValue
            menuTableVC?.tableView.reloadData()
        }
    }

    func reloadMenu() {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}


// MARK: - Implementation

private extension MenuViewController {

    struct Constants {
        static let embedSgueId = "EmbedMenuSegue"
    }

}

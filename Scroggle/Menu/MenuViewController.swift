//
//  MenuViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/8/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

/// This View Controller serves as a Container to embed the `MenuTableViewController`
/// and proxy the `menu` property through to the MenuTableVC.
class MenuViewController: UIViewController {

    /// A reference to the embedded MenuTableViewController
    var menuTableVC: MenuTableViewController?

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

}


// MARK: - Implementation

private extension MenuViewController {

    struct Constants {
        /// The ID of the Container View embed segue
        static let embedSegueId = "EmbedMenuSegue"
    }

}

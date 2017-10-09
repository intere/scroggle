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
            menu = buildMenu()
        }
    }

    /// Sets the menuInfo
    var menu: MenuInfo? {
        get {
            return menuTableVC?.menu
        }
        set {
            menuTableVC?.menu = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// Subclasses implement this function to build the menu model
    ///
    /// - Returns: A MenuInfo object that contains the menu structure for this table
    open func buildMenu() -> MenuInfo? {
        fatalError("You must implement this in a subclass")
    }

    open class func loadFromStoryboard() -> MenuViewController {
        fatalError("You must implement this in a subclass")
    }

}

// MARK: - Navigation

extension MenuViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let menuTableVC = segue.destination as? MenuTableViewController {
            self.menuTableVC = menuTableVC
        }
    }

}

// MARK: - Implementation

private extension MenuViewController {

    struct Constants {
        static let embedSgueId = "EmbedMenuSegue"
    }

}

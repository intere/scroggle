//
//  MenuContainerViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 4/7/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import UIKit

/// The main purpose of this controller is to present a menu.
/// The `menuBuilder` property (a `MenuBuilding` object) is the model that
/// tells us how to build the menu.
/// The `menuTableVC` is the actual menu view controller (it's the worker here),
/// and uses the `menuBuilder` to build out the menu for us.
class MenuContainerViewController: UIViewController {

    @IBOutlet weak var proportionalWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var proportionalHeightConstraint: NSLayoutConstraint!

    /// The model that tells us how to build out the menus.  Setting this
    /// instance will propagate the changes out to the MenuTableViewController.
    weak var menuBuilder: MenuBuilding? {
        didSet {
            reloadMenu()
        }
    }

    /// A reference to the embedded MenuTableViewController
    weak var menuTableVC: MenuTableViewController? {
        didSet {
            reloadMenu()
        }
    }

    /// The `MenuInfo` model (see `reloadMenu()` for more details).  Setting this
    /// model will set the reference on the `menuTableVC` and prompt the table to reload.
    /// This function should *only* be call on the Main Thread!
    var menu: MenuInfo? {
        get {
            return menuTableVC?.menu
        }
        set {
            menuTableVC?.menu = newValue
            menuTableVC?.tableView.reloadData()
        }
    }

    /// Sets the menu (which propagates this property to the `MenuTableViewController`)
    /// and then builds out the menu.
    func reloadMenu() {
        menu = menuBuilder?.buildMenu()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    class func loadFromStoryboard() -> MenuContainerViewController {
        return UIStoryboard(name: "Menu", bundle: nil)
            .instantiateViewController(withIdentifier: "MenuContainerViewController") as! MenuContainerViewController
        // swiftlint:disable:previous force_cast
    }

}

// MARK: - Navigation

extension MenuContainerViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let menuTableVC = segue.destination as? MenuTableViewController {
            self.menuTableVC = menuTableVC
        }
    }

}

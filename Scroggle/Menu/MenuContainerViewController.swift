//
//  MenuContainerViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 4/7/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import UIKit

class MenuContainerViewController: UIViewController {

    @IBOutlet weak var proportionalWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var proportionalHeightConstraint: NSLayoutConstraint!

    var menuBuilder: MenuBuilding? {
        didSet {
            reloadMenu()
        }
    }

    /// A reference to the embedded MenuTableViewController
    var menuTableVC: MenuTableViewController? {
        didSet {
            reloadMenu()
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
        menu = menuBuilder?.buildMenu()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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

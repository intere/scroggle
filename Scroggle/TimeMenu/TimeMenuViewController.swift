//
//  TimeMenuViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/9/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

class TimeMenuViewController: UIViewController {

    var menuContainerVC: MenuContainerViewController? {
        didSet {
            menuContainerVC?.menuBuilder = self
        }
    }

    class func loadFromStoryboard() -> TimeMenuViewController {
        return UIStoryboard(name: "Time", bundle: nil).instantiateViewController(withIdentifier: "TimeMenuViewController") as! TimeMenuViewController
    }

}

// MARK: - MenuBuilding

extension TimeMenuViewController: MenuBuilding {

    func buildMenu() -> MenuInfo? {
        return MenuInfo(title: "Game Duration", buttons: [
            ButtonCellInfo(title: "45 seconds") {
                // TODO
            },
            ButtonCellInfo(title: "90 seconds") {
                // TODO
            },
            ButtonCellInfo(title: "3 minutes") {
                // TODO
            },
            ButtonCellInfo(title: "5 minutes") {
                // TODO
            },
            ButtonCellInfo(title: "10 minutes") {
                // TODO
            }
        ])
    }
}



// MARK: - Navigation

extension TimeMenuViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let menuContainerVC = segue.destination as? MenuContainerViewController {
            self.menuContainerVC = menuContainerVC
        }
    }

}

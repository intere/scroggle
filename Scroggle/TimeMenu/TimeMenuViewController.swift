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
            ButtonCellInfo(title: "45 seconds") { [weak self] in
                self?.select(timeType: .veryShort)
            },
            ButtonCellInfo(title: "90 seconds") { [weak self] in
                self?.select(timeType: .short)
            },
            ButtonCellInfo(title: "3 minutes") { [weak self] in
                self?.select(timeType: .default)
            },
            ButtonCellInfo(title: "5 minutes") { [weak self] in
                self?.select(timeType: .medium)
            },
            ButtonCellInfo(title: "10 minutes") { [weak self] in
                self?.select(timeType: .long)
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

// MARK: - Implementation

extension TimeMenuViewController {

    func select(timeType: GameTimeType) {
        MenuSelectionService.shared.timer = timeType
        navigationController?.pushViewController(GamePlayViewController.loadFromStoryboard(), animated: true)
    }
}

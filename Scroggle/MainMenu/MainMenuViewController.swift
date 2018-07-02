//
//  MainMenuViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/8/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    var menuContainerVC: MenuContainerViewController? {
        didSet {
            menuContainerVC?.menuBuilder = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        GameContextProvider.Configuration.demoMode = false
    }

    class func loadFromStoryboard() -> MainMenuViewController {
        return UIStoryboard(name: "MainMenu", bundle: nil).instantiateViewController(withIdentifier: "MainMenuViewController") as! MainMenuViewController
    }

}

// MARK: - MenuBuilding

extension MainMenuViewController: MenuBuilding {

    func buildMenu() -> MenuInfo? {
        return MenuInfo(title: "Scroggle", buttons: [
            ButtonCellInfo(title: "New Game", action: {
                DLog("Clicked New Game")
                self.navigationController?.pushViewController(TimeMenuViewController.loadFromStoryboard(), animated: true)
            }),
            ButtonCellInfo(title: "Login: GameCenter", action: {
                DLog("Clicked Login")
            })
        ])
    }

}


// MARK: - Navigation

extension MainMenuViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let menuContainerVC = segue.destination as? MenuContainerViewController {
            self.menuContainerVC = menuContainerVC
        }
    }

}

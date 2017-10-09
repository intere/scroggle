//
//  MainMenuViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/8/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

class MainMenuViewController: MenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func buildMenu() -> MenuInfo? {
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

    override class func loadFromStoryboard() -> MenuViewController {
        return UIStoryboard(name: "MainMenu", bundle: nil).instantiateViewController(withIdentifier: "MainMenuViewController") as! MainMenuViewController
    }

}

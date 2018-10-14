//
//  MainMenuViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/8/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Cartography
import UIKit

/// The Controller for the Main Menu.
class MainMenuViewController: ChalkboardViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GameContextProvider.Configuration.demoMode = false
        let menuVC = MenuContainerViewController.loadFromStoryboard()
        menuVC.menuBuilder = self
        addContent(viewController: menuVC)
    }

    /// Creates you a new instance of this VC from the storyboard.
    ///
    /// - Returns: A new instance of the `MainMenuViewController`.
    class func loadFromStoryboard() -> MainMenuViewController {
        return UIStoryboard(name: "MainMenu", bundle: nil)
            .instantiateViewController(withIdentifier: "MainMenuViewController")
            as! MainMenuViewController
        //swiftlint:disable:previous force_cast
    }

}

// MARK: - MenuBuilding

extension MainMenuViewController: MenuBuilding {

    /// Builds you a new MenuInfo object for the Main Menu
    ///
    /// - Returns: A MenuInfo object for the Main Menu.
    func buildMenu() -> MenuInfo? {
        return MenuInfo(title: "Scroggle", showCloseButton: false, buttons: [
            ButtonCellInfo(title: "New Game", action: {
                SoundProvider.instance.playMenuSelectionSound()
                DLog("Clicked New Game")
                self.navigationController?.pushViewController(TimeMenuViewController.loadFromStoryboard(),
                                                              animated: true)
            }),
            // TODO: Toggle between "Login: GameCenter" and "View High Scores"
            ButtonCellInfo(title: "Login: GameCenter", action: {
                SoundProvider.instance.playMenuSelectionSound()
                DLog("Clicked Login")
            })
        ])
    }

}

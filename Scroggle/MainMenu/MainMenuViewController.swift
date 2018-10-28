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

        Notification.Scroggle.MenuAction.authorizationChanged
            .addObserver(self, selector: #selector(gameCenterAuthorizationChanged(_:)))
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

// MARK: - Notifications

extension MainMenuViewController {

    @IBAction
    func gameCenterAuthorizationChanged(_ notification: NSNotification) {
        menuVC?.reloadMenu()
    }

}

// MARK: - MenuBuilding

extension MainMenuViewController: MenuBuilding {

    /// Builds you a new MenuInfo object for the Main Menu
    ///
    /// - Returns: A MenuInfo object for the Main Menu.
    func buildMenu() -> MenuInfo? {

        let gcTitle = GameCenterProvider.instance.loggedIn ? "Leaderboards" : "GameCenter"

        return MenuInfo(title: "Scroggle", showCloseButton: false, buttons: [
            ButtonCellInfo(title: "New Game", action: {
                SoundProvider.instance.playMenuSelectionSound()
                DLog("Clicked New Game")
                self.navigationController?.pushViewController(TimeMenuViewController.loadFromStoryboard(),
                                                              animated: true)
            }),

            ButtonCellInfo(title: gcTitle, action: { [weak self] in
                SoundProvider.instance.playMenuSelectionSound()
                DLog("Clicked GameCenter")
                guard let self = self else {
                    return
                }
                if GameCenterProvider.instance.loggedIn {
                    GameCenterProvider.instance.showLeaderboard(from: self)
                } else {
                    GameCenterProvider.instance.loginToGameCenter(with: self)
                }
            }),

            ButtonCellInfo(title: "Help", action: { [weak self] in
                self?.navigationController?.pushViewController(HelpMenuViewController.loadFromStoryboard(),
                                                               animated: true)
            })
        ])
    }

}

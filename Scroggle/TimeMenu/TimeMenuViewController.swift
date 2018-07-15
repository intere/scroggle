//
//  TimeMenuViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/9/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

/// The Controller for the TimeMenu, it's responsible for starting games
class TimeMenuViewController: UIViewController {

    /// A reference to the `MenuContainerViewController` so that we can
    /// wire ourself as the `menuBuilder`
    weak var menuContainerVC: MenuContainerViewController? {
        didSet {
            menuContainerVC?.menuBuilder = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Notification.Scroggle.TimeMenuAction.playSameTime.addObserver(self, selector: #selector(replayCurrentGameTime))
        Notification.Scroggle.TimeMenuAction.replayCurrentBoard.addObserver(self, selector: #selector(replayCurrentBoard))
    }

    /// Gives you an instance of this class that's instantiated via the
    // Storyboard.
    ///
    /// - Returns: A new instance of the `TimeMenuViewController`
    class func loadFromStoryboard() -> TimeMenuViewController {
        return UIStoryboard(name: "Time", bundle: nil).instantiateViewController(withIdentifier: "TimeMenuViewController") as! TimeMenuViewController
    }

}

// MARK: - MenuBuilding

extension TimeMenuViewController: MenuBuilding {

    /// Builds you a new MenuInfo object for this ViewController.
    ///
    /// - Returns: A MenuInfo object for the time menu
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

    @objc
    /// Handles the event that we should replay the current game
    func replayCurrentBoard() {
        GameContextProvider.instance.replayCurrentGame()
        goToGameVC()
    }

    @objc
    /// Handles the event for replaying the current game time
    func replayCurrentGameTime() {
        guard let timeType = GameContextProvider.instance.currentGame?.game.timeType else {
            return DLog("ERROR: No current game to get time type from")
        }
        select(timeType: timeType)
    }

    /// Selects a game with the provided time type.
    ///
    /// - Parameter timeType: The time length for the game.
    func select(timeType: GameTimeType) {
        SoundProvider.instance.playMenuSelectionSound()
        GameContextProvider.instance.createSinglePlayerGame(timeType)
        goToGameVC()
    }

    /// Loads a new instance of a `GameContainerViewController` from the
    /// Storyboard and then pushes it onto the `navigationController`.
    private func goToGameVC() {
        navigationController?.pushViewController(GameContainerViewController.loadFromStoryboard(), animated: true)
    }
}

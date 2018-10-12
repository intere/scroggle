//
//  GameContainerViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/3/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import Cartography
import SceneKit
import SpriteKit
import UIKit

class GameContainerViewController: ChalkboardViewController {
    var gameArea: SKView!
    var gameController: GameSceneController!
    var hudController: HUDViewController!

    var scoreArea: UIView {
        return hudController.view
    }

    override func viewDidLoad() {
        addHudVC()

        gameArea = SKView()
        #if DEBUG
        gameArea.showsFPS = true
        gameArea.showsPhysics = true
        gameArea.showsDrawCount = true
        gameArea.showsNodeCount = true
        gameArea.showsQuadCount = true
        #endif

        DispatchQueue.main.async {
            self.gameController = GameSceneController(withView: self.gameArea)
        }

        Notification.Scroggle.GameOverAction.mainMenu.addObserver(self, selector: #selector(mainMenu))
        Notification.Scroggle.GameOverAction.playAgain.addObserver(self, selector: #selector(playAgain))
        Notification.Scroggle.GameOverAction.replay.addObserver(self, selector: #selector(replay))

        super.viewDidLoad()
    }

    public static func loadFromStoryboard() -> GameContainerViewController {
        return UIStoryboard(name: "GameContainer", bundle: nil)
            .instantiateInitialViewController() as! GameContainerViewController
        // swiftlint:disable:previous force_cast
    }

    /// Builds the UI for Portrait Layout
    override func buildPortrait() {
        super.buildPortrait()
        contentView.subviews.forEach { $0.removeFromSuperview() }
        [scoreArea, gameArea].forEach { contentView.addSubview($0) }

        constrain(contentView, scoreArea, gameArea) { view, scoreArea, gameArea in
            scoreArea.top == view.top
            scoreArea.left == view.left
            scoreArea.right == view.right
            if self.isPad {
                scoreArea.bottom == view.centerY * 0.5
            } else {
                scoreArea.bottom == view.centerY
            }

            gameArea.top == scoreArea.bottom
            gameArea.left == view.left
            gameArea.right == view.right
            gameArea.bottom == view.bottom
        }
    }

    /// Builds the screen for Landscape layout
    override func buildLandscape() {
        super.buildLandscape()
        contentView.subviews.forEach { $0.removeFromSuperview() }
        [scoreArea, gameArea].forEach { contentView.addSubview($0) }

        constrain(contentView, scoreArea, gameArea) { view, scoreArea, gameArea in
            scoreArea.top == view.top
            scoreArea.left == view.left
            if self.isPad {
                scoreArea.right == view.centerX * 0.5
            } else {
                scoreArea.right == view.centerX
            }
            scoreArea.bottom == view.bottom

            gameArea.top == view.top
            gameArea.left == scoreArea.right
            gameArea.right == view.right
            gameArea.bottom == view.bottom
        }
    }

}

// MARK: - ObjC functions

extension GameContainerViewController {

    @objc
    func mainMenu() {
        SoundProvider.instance.playMenuSelectionSound()
        guard let mainMenuVC = navigationController?.viewControllers.first(where: { $0 is MainMenuViewController }) else {
            return assertionFailure("No MainMenuVC")
        }
        navigationController?.popToViewController(mainMenuVC, animated: true)
    }

    @objc
    func playAgain() {
        SoundProvider.instance.playMenuSelectionSound()
        GameContextProvider.instance.replayGameWithSameTime()
        pushAnotherGameToNavVC()
    }

    @objc
    func replay() {
        SoundProvider.instance.playMenuSelectionSound()
        GameContextProvider.instance.replayCurrentGame()
        pushAnotherGameToNavVC()
    }

}

// MARK: - Implementation

extension GameContainerViewController {

    private func pushAnotherGameToNavVC() {
        guard var vcList = navigationController?.viewControllers else {
            return DLog("ERROR: No current game to get time type from")
        }
        vcList.removeLast()
        vcList.append(GameContainerViewController.loadFromStoryboard())

        navigationController?.setViewControllers(vcList, animated: true)
    }

    private func addHudVC() {
        hudController = HUDViewController()
        addChild(hudController)
        hudController.didMove(toParent: self)
    }

}

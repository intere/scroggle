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

        super.viewDidLoad()

        debugSetup()
        DispatchQueue.main.async {
            self.gameController = GameSceneController(withView: self.gameArea)
        }
        
        Notification.Scroggle.GameOverAction.mainMenu.addObserver(self, selector: #selector(mainMenu))
        Notification.Scroggle.GameOverAction.playAgain.addObserver(self, selector: #selector(playAgain))
        Notification.Scroggle.GameOverAction.replay.addObserver(self, selector: #selector(replay))
    }

    func debugSetup() {
        GameContextProvider.instance.createSinglePlayerGame(.default)
        assert(GameContextProvider.instance.currentGame != nil, "No game going yet")
    }

    public static func loadFromStoryboard() -> GameContainerViewController {
        // swiftlint:disable:next force_cast
        return UIStoryboard(name: "GameContainer", bundle: nil).instantiateInitialViewController() as! GameContainerViewController
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

// MARK: - Implementation

extension GameContainerViewController {

    @objc
    func mainMenu() {
        DLog("Main Menu")
        guard let mainMenuVC = navigationController?.viewControllers.first(where: { $0 is MainMenuViewController }) else {
            return assertionFailure("No MainMenuVC")
        }
        navigationController?.popToViewController(mainMenuVC, animated: true)
    }

    @objc
    func playAgain() {
        DLog("Play Again")

    }

    @objc
    func replay() {
        DLog("Replay")
    }

    private func addHudVC() {
        hudController = HUDViewController()
        addChild(hudController)
        hudController.didMove(toParent: self)
    }

}

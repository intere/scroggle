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
    var isGameOver = false

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

        Notification.Scroggle.GameEvent.gameEnded.addObserver(self, selector: #selector(gameEnded))
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

        if isGameOver {
            buildGameOverView()
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

        if isGameOver {
            buildGameOverView()
        }
    }

}

// MARK: - ObjC functions

extension GameContainerViewController {

    @objc
    func gameEnded() {
        isGameOver = true
        buildGameOverView()
    }

    @objc
    func mainMenu() {
        GameCenterProvider.instance.saveLeaderboardForGame(context: context)
        Notification.Scroggle.GameEvent.gameEnded.notify()
        SoundProvider.instance.playMenuSelectionSound()
        guard let mainMenuVC = navigationController?.viewControllers
            .first(where: { $0 is MainMenuViewController }) else {
            return assertionFailure("No MainMenuVC")
        }
        navigationController?.popToViewController(mainMenuVC, animated: true)
    }

    @objc
    func playAgain() {
        GameCenterProvider.instance.saveLeaderboardForGame(context: context)
        SoundProvider.instance.playMenuSelectionSound()
        GameContextProvider.instance.replayGameWithSameTime()
        pushAnotherGameToNavVC()
    }

    @objc
    func replay() {
        GameCenterProvider.instance.saveLeaderboardForGame(context: context)
        SoundProvider.instance.playMenuSelectionSound()
        GameContextProvider.instance.replayCurrentGame()
        pushAnotherGameToNavVC()
    }

}

// MARK: - Implementation

extension GameContainerViewController {

    private var context: GameContext {
        return gameController.gameContext
    }

    /// Gets you the high score
    private var highScore: Int? {
        guard let highScore = GameCenterProvider.instance.getHighScoreForType(context.game.timeType) else {
            return nil
        }
        return Int(highScore)
    }

    /// Computes an optimal font size for the current screen orientation and size
    private var gameOverFontSize: CGFloat {
        var fontSize: CGFloat = 20
        if isLandscape {
            if isPad {
                fontSize = UIScreen.main.bounds.width / 15
            } else {
                // we're using a bit less than half the screen width on phones
                fontSize = UIScreen.main.bounds.width / 20
            }
        } else {
            // we're using just less than the screen width
            fontSize = UIScreen.main.bounds.width / 10
        }
        DLog("Game Over font size: \(fontSize)")
        return fontSize
    }

    /// Adds the "Game Over" tile over the game play area
    private func buildGameOverView() {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        let label = UILabel()
        label.text = "Game Over"
        label.font = UIFont(name: "Chalkduster", size: gameOverFontSize)
        label.textColor = .orange
        view.addSubview(label)
        contentView.addSubview(view)

        constrain(gameArea, view) { (view, gameOverView) in
            gameOverView.left == view.left
            gameOverView.top == view.top
            gameOverView.right == view.right
            gameOverView.bottom == view.bottom
        }

        if let highScore = highScore, context.game.score > highScore {
            let highScoreLabel = UILabel()
            highScoreLabel.text = "You beat the high score!"
            highScoreLabel.numberOfLines = 3
            highScoreLabel.font = UIFont(name: "Chalkduster", size: gameOverFontSize - 5)
            highScoreLabel.textColor = UIColor.green
            highScoreLabel.textAlignment = .center
            view.addSubview(highScoreLabel)

            constrain(view, label, highScoreLabel) { (gameOverView, label, highScoreLabel) in
                label.centerX == gameOverView.centerX
                label.bottom == gameOverView.centerY - 10
                highScoreLabel.centerX == gameOverView.centerX
                highScoreLabel.top == gameOverView.centerY + 10
                highScoreLabel.left == gameOverView.leftMargin
                highScoreLabel.right == gameOverView.rightMargin
            }
        } else {
            constrain(view, label) { (gameOverView, label) in
                label.centerX == gameOverView.centerX
                label.centerY == gameOverView.centerY
            }
        }
    }

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

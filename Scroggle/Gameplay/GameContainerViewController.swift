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

/// This is the "Game Play" view controller.  It has a
/// Game area and a Heads Up Display (HUD) area.
/// ### Organization
/// In terms of ViewController hierarchy, this VC has one child VC:
/// - `HUDViewController`
///
/// It is also worth mentioning that there is a "Controller" (not a VC, though)
/// that manages the interactions with the Game Scene:
/// - `GameSceneController`
///
class GameContainerViewController: ChalkboardViewController {

    /// The VC for the HUD
    var hudController: HUDViewController!

    /// The controller for the GameScene
    var gameController: GameSceneController!

    /// The View that manages the game area
    var gameArea: SKView!

    var isGameOver = false

    /// The view from the HUD
    var hudView: UIView {
        return hudController.view
    }

    override func viewDidLoad() {
        addHudVC()

        gameArea = SKView()
        #if DEBUG
        gameArea.showsFPS = true
        if SettingsService.showTiles {
            gameArea.showsPhysics = true
        }
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
        [hudView, gameArea].forEach { contentView.addSubview($0) }

        constrain(contentView, hudView, gameArea) { view, scoreArea, gameArea in
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
        Notification.GameScreen.sizeChanged.notify(withObject: gameArea)
    }

    /// Builds the screen for Landscape layout
    override func buildLandscape() {
        super.buildLandscape()
        contentView.subviews.forEach { $0.removeFromSuperview() }
        [hudView, gameArea].forEach { contentView.addSubview($0) }

        constrain(contentView, hudView, gameArea) { view, scoreArea, gameArea in
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

        Notification.GameScreen.sizeChanged.notify(withObject: gameArea)
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
        // No need to do this here, it's handled in the HUD VC
        // Notification.Scroggle.GameEvent.gameEnded.notify(withObject: context)
        SoundProvider.instance.playMenuSelectionSound()
        guard let mainMenuVC = navigationController?.viewControllers
            .first(where: { $0 is MainMenuViewController }) else {
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

// MARK: - GameScreen Notification

extension Notification {

    enum GameScreen: String, Notifiable, CustomStringConvertible {
        case sizeChanged = "screen.size.changed"

        static var notificationBase: String {
            return "com.icolasoft.scroggle"
        }

        var description: String {
            return rawValue
        }
    }
}

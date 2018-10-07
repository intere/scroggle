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
    var scoreArea: UIView!
    var gameArea: SKView!
    var gameController: GameSceneController!

    override func viewDidLoad() {
        scoreArea = UIView()
        scoreArea.backgroundColor = UIColor.red.withAlphaComponent(0.4)

        gameArea = SKView()
        #if DEBUG
        gameArea.backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        gameArea.layer.borderColor = UIColor.blue.withAlphaComponent(0.4).cgColor
        gameArea.layer.borderWidth = 2
        gameArea.showsFPS = true
        gameArea.showsPhysics = true
        gameArea.showsDrawCount = true
        gameArea.showsNodeCount = true
        gameArea.showsQuadCount = true
        #endif

        super.viewDidLoad()

        debugSetup()
        gameController = GameSceneController(withView: gameArea)
    }

    func debugSetup() {
        GameContextProvider.instance.createSinglePlayerGame(.default)
        assert(GameContextProvider.instance.currentGame != nil, "No game going yet")
    }

    public static func loadFromStoryboard() -> GameContainerViewController {
        // swiftlint:disable:next force_cast
        return UIStoryboard(name: "GameContainer", bundle: nil).instantiateInitialViewController() as! GameContainerViewController
    }

    override func buildPortrait() {
        super.buildPortrait()
        contentView.subviews.forEach { $0.removeFromSuperview() }
        [scoreArea, gameArea].forEach { contentView.addSubview($0) }

        constrain(contentView, scoreArea, gameArea) { view, scoreArea, gameArea in
            scoreArea.top == view.top
            scoreArea.left == view.left
            scoreArea.right == view.right
            scoreArea.bottom == view.centerY
            gameArea.top == view.centerY
            gameArea.left == view.left
            gameArea.right == view.right
            gameArea.bottom == view.bottom
        }
    }

    override func buildLandscape() {
        super.buildLandscape()
        contentView.subviews.forEach { $0.removeFromSuperview() }
        [scoreArea, gameArea].forEach { contentView.addSubview($0) }

        constrain(contentView, scoreArea, gameArea) { view, scoreArea, gameArea in
            scoreArea.top == view.top
            scoreArea.left == view.left
            scoreArea.right == view.centerX
            scoreArea.bottom == view.bottom

            gameArea.top == view.top
            gameArea.left == view.centerX
            gameArea.right == view.right
            gameArea.bottom == view.bottom
        }
    }

}

// MARK: - Implementation

extension GameContainerViewController {



}

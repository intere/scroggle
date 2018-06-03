//
//  GamePlayViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/3/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit
import UIKit

class GamePlayViewController: UIViewController {
    @IBOutlet weak var proportionalWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var proportionalHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var containerView: UIView!

    var skView: SKView?

    public static func loadFromStoryboard() -> GamePlayViewController {
        let storybaord = UIStoryboard(name: "GamePlay", bundle: nil)
        return storybaord.instantiateInitialViewController() as! GamePlayViewController
        // swiftlint:disable:previous force_cast
    }
}

// MARK: - Implementation

extension GamePlayViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "embedGameView" else {
            return
        }

        skView = segue.destination.view.subviews[0] as? SKView
        loadGameScene()
    }

    func loadGameScene() {
        guard let skView = skView else {
            return DLog("ERROR: Couldn't get a reference to the SKView")
        }

        let sceneNode = SK3DNode(viewportSize: skView.frame.size)
        guard let trayScene = SCNScene(named: "art.scnassets/DiceTray.scn") else {
            return assertionFailure("Failed to create the dice tray scene")
        }
        sceneNode.scnScene = trayScene
        sceneNode.position = CGPoint(x: skView.frame.midX, y: skView.frame.midY)

        // Debugging
        skView.showsPhysics = true
        sceneNode.physicsBody = SKPhysicsBody(rectangleOf: sceneNode.frame.size)
        sceneNode.physicsBody?.affectedByGravity = false

        let diceTray = SKScene(size: skView.frame.size)
        skView.presentScene(diceTray)
        diceTray.addChild(sceneNode)
        
    }

}

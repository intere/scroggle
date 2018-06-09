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
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!

    @IBOutlet weak var containerView: UIView!

    var skView: SKView?
    var gameScene: SCNGameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.isiPhoneX {
            proportionalWidthConstraint.constant = -80
            proportionalHeightConstraint.constant = -20
            centerYConstraint.constant = -10
        }
    }

    /// Factory instantiation function for this VC, comes from a storyboard.
    ///
    /// - Returns: An instance of the GamePlayViewController
    static func loadFromStoryboard() -> GamePlayViewController {
        let storybaord = UIStoryboard(name: "GamePlay", bundle: nil)
        return storybaord.instantiateInitialViewController() as! GamePlayViewController
        // swiftlint:disable:previous force_cast
    }

    @IBAction
    func buttonTODOdeleteMe(_ sender: Any) {
        gameScene?.rollDice()
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

        // Bootstrap the GameScene:
        gameScene = SCNGameScene(withView: skView)
    }

}

//
//  GameContainerViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/3/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit
import UIKit

class GameContainerViewController: UIViewController {
    @IBOutlet weak var proportionalWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var proportionalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backButton: UIButton!

    override var prefersStatusBarHidden: Bool { return true }

    /// The SpriteKit view that the GameScene is to be rendered in
    var skView: SKView?

    /// The SceneKit Game scene
    var gameScene: SCNGameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserInterface()
    }

    /// Factory instantiation function for this VC, comes from a storyboard.
    ///
    /// - Returns: An instance of the GamePlayViewController
    static func loadFromStoryboard() -> GameContainerViewController {
        let storybaord = UIStoryboard(name: "GameContainer", bundle: nil)
        return storybaord.instantiateInitialViewController() as! GameContainerViewController
        // swiftlint:disable:previous force_cast
    }

    @IBAction
    func buttonTODOdeleteMe(_ sender: Any) {
        gameScene?.rollDice()
    }
}

// MARK: - Implementation

extension GameContainerViewController {

    /// For getting a reference to the embedded view controller.
    ///
    /// - Parameters:
    ///   - segue: The segue to get the VC reference from.
    ///   - sender: The source of the event.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "embedGameView" else {
            return
        }

        skView = segue.destination.view.subviews[0] as? SKView
        loadGameScene()
    }

    /// Updates the UI to render things correctly
    func updateUserInterface() {
        if UIDevice.current.isiPhoneX {
            proportionalWidthConstraint.constant = -80
            proportionalHeightConstraint.constant = -20
            centerYConstraint.constant = -10
            gameScene?.camera?.orthographicScale = 5.0
        } else if UIDevice.current.isiPhone6Plus || UIDevice.current.isiPhone6 || UIDevice.current.isiPhone5 {
            gameScene?.camera?.orthographicScale = 5.6
        }

        if UIDevice.current.isiPad {
            gameScene?.camera?.orthographicScale = 5
        } else {
            backButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        }
    }

    /// Updates the game scene after the view loads
    func loadGameScene() {
        guard let skView = skView else {
            return assertionFailure("ERROR: Couldn't get a reference to the SKView")
        }

        // Bootstrap the GameScene:
        gameScene = SCNGameScene(withView: skView)
    }

}

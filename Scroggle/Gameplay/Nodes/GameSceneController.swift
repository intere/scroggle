//
//  GameSceneController.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/3/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import SpriteKit
import SceneKit
import UIKit

/// A class that will render a Scroggle Game Board in the provided SKView.
/// 1. A new SKScene is created (consuming the entire SKView screen)
/// 2. The DiceTray.scn file is loaded into an SCNScne
/// 3. A new SCN3DNode is created and added to the Scene from step 1
/// 4. The SCNScene (from step 2) is set as the scene in the SCN3DNode
class GameSceneController {

    /// The SKView that the Game Scene is being rendered within.
    let skView: SKView

    /// The current rotation amount
    var rotation = 0 {
        didSet {
            DLog("Set rotation: \(rotation)")
        }
    }

    var isRotating = false

    /// The SCNScene (DiceTray.scn)
    weak var gameScene: SCNScene?

    /// The 3D Scene node
    var sceneNode: SK3DNode!

    /// The Camera
    var camera: SCNCamera?

    /// The SCNNodes for the dice (there should be 16 of them in a 4x4 board)
    var dice: [SCNNode] = []

    /// The positions for each die
    var dicePositions = [SCNVector3]()

    /// The Clickable Tiles (laid over the dice)
    var tiles: [SKShapeNode] = []

    /// The container that holds the tiles
    var tileContainer = SKShapeNode()

    /// An array of the current selection
    var selection: [Int] = []

    /// The visualization for a selection
    var selectionPath: [SKShapeNode] = []

    /// Handles the rotation gesture for the game scene
    var rotateGesture: UIRotationGestureRecognizer!

    /// The current game's context
    var gameContext: GameContext

    /// Initializes the SCNGameScene with
    ///
    /// - Parameter view: The view that we're initializing the Game Scene with.
    init?(withView view: SKView) {
        skView = view
        skView.backgroundColor = .clear
        guard let gameContext = GameContextProvider.instance.currentGame else {
            fatalError("No Game Context could be found")
            return nil
        }
        self.gameContext = gameContext
        bootstrapScene()
        Notification.GameScreen.sizeChanged.addObserver(self, selector: #selector(viewSizeChanged(_:)))
        Notification.HUDEvent.playTimeSound.addObserver(self, selector: #selector(playTimeSound(_:)))
    }

}

// MARK: - Implementation

extension GameSceneController {

    /// Bootstraps the scene and delegates off to other helper functions.
    func bootstrapScene() {
        sceneNode = SK3DNode(viewportSize: skView.frame.size)

        guard let trayScene = SCNScene(named: "art.scnassets/DiceTray.scn") else {
            return assertionFailure("Failed to create the dice tray scene")
        }

        sceneNode.scnScene = trayScene
        sceneNode.position = CGPoint(x: skView.bounds.midX, y: skView.bounds.midY)

        let gameplayScene = GameScene(size: skView.frame.size)
        gameplayScene.controller = self
        skView.presentScene(gameplayScene)
        gameplayScene.addChild(sceneNode)

        // Debugging
        sceneNode.physicsBody = SKPhysicsBody(rectangleOf: skView.frame.size)
        sceneNode.physicsBody?.affectedByGravity = false
        // End Debugging

        gameScene = trayScene
        readDiceReferences()
        readCameraReference()
        setDiceMaterial()
        addClickableTiles()
        setupRotationGesture()

        guard !Platform.isSimulator else {
            // If we're running in the simulator, just set the intended Euler Angles,
            // skip the intro (roll dice) animation and start the game
            setEulerAnglesForDice()
            Notification.Scroggle.GameEvent.beginTimer.notify()
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else {
                return
            }
            if let rootNode = self.gameScene?.rootNode {
                SoundProvider.instance.playDiceRollSound(node: rootNode)
            }
            self.rollDice {
                Notification.Scroggle.GameEvent.beginTimer.notify()
            }
        }
    }

    /// Reads the dice nodes from the scene and stores them in the `dice` array.
    func readDiceReferences() {
        dice.removeAll()
        dicePositions.removeAll()

        for index in 0..<16 {
            guard let die = getDie(at: index) else {
                continue
            }
            dice.append(die)
            dicePositions.append(die.position)
        }
        assert(dice.count == 16)
    }

    /// Reads the camera reference
    func readCameraReference() {
        guard let camera = gameScene?.rootNode.childNodes.filter({$0.name == "camera"}).first else {
            return assertionFailure("Couldn't find the camera node")
        }
        self.camera = camera.camera
    }

    /// Sets the "letters" for each side of the dice.
    /// This is accomplished by generating images for the letters
    /// and setting the materials for each size.
    func setDiceMaterial() {
        assert(dice.count == DiceProvider.instance.fourByFour.count)
        assert(GameContextProvider.instance.currentGame != nil)
        guard let diceArray = GameContextProvider.instance.currentGame?.game.board.board else {
            return assertionFailure("Failed to get the dice")
        }
        for index in 0..<dice.count {
            guard let box = dice[index].geometry as? SCNBox else {
                continue
            }
            box.materials = diceArray[index].sides.map({self.createMaterialForText(text: $0)})
        }
    }

}

// MARK: - Rotate Gesture

extension GameSceneController {

    @objc
    /// Handles the user gesture events
    ///
    /// - Parameter rotateGesture: The rotation gesture.
    func didRotate(_ rotateGesture: UIRotationGestureRecognizer) {
        switch rotateGesture.state {
        case .cancelled, .ended, .failed:
            isRotating = false
        default:
            isRotating = true
        }

        guard rotateGesture.state == .ended else {
            return
        }
        let degrees = (Float(100) * rotateGesture.rotation.degrees) / 100

        if degrees > 30 {
            DLog("Rotated clockwise")
            rotateBoard(clockwise: true)
        } else if degrees < -30 {
            DLog("Rotated counter clockwise")
            rotateBoard(clockwise: false)
        }
    }

}

// MARK: - Notification

extension GameSceneController {

    @objc
    func viewSizeChanged(_ notification: NSNotification) {
        guard let view = notification.object as? SKView, view == skView else {
            return DLog("Wrong object")
        }
        DispatchQueue.main.async {
            view.scene?.size = view.frame.size
        }
    }

    @objc
    func playTimeSound(_ notification: NSNotification) {
        guard let rootNode = gameScene?.rootNode else {
            return
        }
        SoundProvider.instance.playTimeSound(node: rootNode)
    }
}

// MARK: - Dice rotation

extension GameSceneController {

    /// Handles rotating the board for us.
    ///
    /// - Parameter clockwise: The direction of the rotation, clockwise or otherwise.
    func rotateBoard(clockwise: Bool) {
        guard let cameraNode = gameScene?.rootNode.childNodes.filter({ $0.camera != nil }).first else {
            return assertionFailure("No cameraNode")
        }
        clearSelection()

        let rotateDegrees = clockwise ? 90 : -90
        rotation += rotateDegrees

        if rotation < 0 {
            rotation += 360
        } else if rotation >= 360 {
            rotation = rotation % 360
        }

        tileContainer.run(SKAction.rotate(byAngle: CGFloat((0 - rotateDegrees).radians), duration: 0.3))
        cameraNode.runAction(SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(rotateDegrees.radians), duration: 0.3))

        for die in dice {
            die.runAction(SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(rotateDegrees.radians), duration: 0.3))
        }

        AnalyticsProvider.instance.rotatedBoard(clockwise: clockwise)
    }

    /// Creates / adds the rotation gesture to the SKView.
    func setupRotationGesture() {
        rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        skView.addGestureRecognizer(rotateGesture)
    }

    /// Gets you an Euler Angle for the provided side
    ///
    /// - Parameter side: The side of the die (array index) that you want the Euler angle for.
    /// - Returns: The Euler angle that correlates to the side you want
    func eulerAngle(for side: Int) -> SCNVector3 {
        let euler: SCNVector3

        switch side {
        case 1:
            euler = SCNVector3Make(0, 270.radians, 0)

        case 2:
            euler = SCNVector3Make(180.radians, 0, 180.radians)

        case 3:
            euler = SCNVector3Make(0, 90.radians, 0)

        case 4:
            euler = SCNVector3Make(90.radians, 0, 0)

        case 5:
            euler = SCNVector3Make(270.radians, 0, 0)

        default:
            euler = SCNVector3Make(0, 0, 0)
        }

        return euler
    }
}

// MARK: - Dice material generation

extension GameSceneController {

    /// Given the provided string, this function will create you a material for the
    /// given text you provide.
    ///
    /// - Parameter text: The text you want rendered into a material
    /// - Returns: A material with an image that has the provided text rendered in it.
    func createMaterialForText(text: String) -> SCNMaterial {
        let label = createLabelViewForText(text: text)
        let image = imageWithView(view: label)
        let material = SCNMaterial()
        material.diffuse.contents = image
        return material
    }

    /// Creates a Label View for the provided text.
    ///
    /// - Parameter text: The text to be rendered into a label
    /// - Returns: A label that's got some large text to render the text in
    func createLabelViewForText(text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        label.text = text
        label.font = UIFont(name: "Chalkduster", size: 80)
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }

    /// Given the provided View, this method will create an image for that view.
    ///
    /// - Parameter view: The view to extract an image from
    /// - Returns: An image that contains a "picture" of the contents of the view
    func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 1.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }

}

// MARK: - Debugging

extension GameSceneController {

    /// Some debugging helpers:
    /// 1. disable demo mode
    /// 2. load a single player game (shortest game length)
    /// 3. print the board
    static func debugSetup() {
        GameContextProvider.Configuration.demoMode = false
        assert(!GameContextProvider.Configuration.demoMode)
        GameContextProvider.instance.createSinglePlayerGame(.veryShort)
        printBoard()
    }

    /// Prints out the board configuration
    static func printBoard() {
        guard let board = GameContextProvider.instance.currentGame?.game.board.board else {
            return DLog("Failed to get the game board")
        }
        DLog("Game Board:\n\(board.debugDescription)")
    }
}

//
//  GameScene.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation
import SceneKit

class IntroductionScene: SCNScene {

    var gameContext: GameContext!

    // Scene related properties

    var demoCamera: SCNNode?
    var gameCamera: SCNNode?
    var selectionPath = [SCNNode]()
    var dice = [Die3D]()
    var selection: [Die3D] = []
    var timerNode: SCNText!
    var scoreNode: SCNText!
    var selectedWord: SCNNode!
    var diceBoard: SCNNode!

    var board: GameBoard? {
        set {
            if let board = newValue {
                gameContext.game.board = board
            }
        }
        get {
            return gameContext.game.board
        }
    }

    var selectionLocked = false
}

// MARK: - API

extension IntroductionScene {

    /// Factory creation method.  If you want a scene that is for demos, pass true for the useDemoCamera property.
    ///
    /// - Parameter useDemoCamera: Whether or not to use the Demo Camera.
    /// - Returns: A GameScene object if it could be created.
    static func loadGameScene(useDemoCamera: Bool = false) -> IntroductionScene? {
        guard let originalScene = SCNScene(named: "art.scnassets/GameView.scn") else {
            DLog("Failed to load GameView.scn")
            return nil
        }

        let gameScene = IntroductionScene()
        for node in originalScene.rootNode.childNodes {
            node.removeAllActions()
            gameScene.rootNode.addChildNode(node)
        }

        gameScene.findAndRemoveCameras()
        gameScene.configure()

        if useDemoCamera {
            gameScene.setCamera(cameraNode: gameScene.demoCamera)
        } else {
            gameScene.setCamera(cameraNode: gameScene.gameCamera)
            gameScene.updateGameCamera()
        }

        return gameScene
    }

    /// Sets the camera in the scene.
    ///
    /// - Parameter cameraNode: An SCNNode with a camera object.
    func setCamera(cameraNode: SCNNode?) {
        guard let cameraNode = cameraNode, cameraNode.camera != nil else {
            assert(false, "There is no camera in the provided node")
            return
        }
        rootNode.addChildNode(cameraNode)
    }

    /// Loads the board (assumes the board exists).
    func loadBoard() {
        guard let board = board else {
            assert(false, "There is no board")
            return
        }

        for index in 0...board.board.count-1 {
            createDie(index)
        }
    }

    /// What is the current word that's selected on the board?.
    ///
    /// - Returns: The current word selection made by the user.
    func getCurrentWord() -> String {
        var result = ""
        for die in selection {
            guard let roll = die.die?.roll else {
                continue
            }
            result += roll
        }
        return result
    }

}

// MARK: - Introduction APIs

extension IntroductionScene {

    /// Performs the intro animation indefinitely.
    func introAnimation() {
        for die in dice {
            die.introAnimateDice()
        }
    }

}

// MARK: - GamePlay APIs

extension IntroductionScene {

    /// Rotates the board (true = clockwise, false = counterclockwise)
    func rotateBoard(_ clockwise: Bool) {
        let boardAngle = CGFloat((clockwise ? -90 : 90).radians)
        let diceAngle = CGFloat((clockwise ? 90 : -90).radians)

        let animateBoard = SCNAction.rotateBy(x: 0, y: boardAngle, z: 0, duration: 0.3)
        let animateDie = SCNAction.rotateBy(x: 0, y: diceAngle, z: 0, duration: 0.3)

        diceBoard.runAction(animateBoard)
        for die in dice {
            die.runAction(animateDie)
        }
        clearSelection()
    }

    /// Updates the score text in the scene from the current game
    func updateScore() {
        scoreNode.string = formatScore(gameContext.game.score)
    }

    /// Tells you if everything is ready to go in the game
    ///
    /// - returns: True if everything that's needed is available, False otherwise
    func readyToStart() -> Bool {
        guard gameContext != nil else {
            let message = "We're checking to see if we're ready to start, but there is no game context"
            recordSystemError(ApplicationError.sceneError(message: message))
            assert(false, "No Game Context")
            return false
        }
        guard gameContext.game.board != nil else {
            let message = "We're checking to see if we're ready to start, but there is no game board"
            recordSystemError(ApplicationError.sceneError(message: message))
            assert(false, "No Game Board")
            return false
        }

        return true
    }

    /// This method will show the currently selected word and then animate the text flying off the screen.
    func showGuessedWord() {
        guard let word = selectedWord.geometry as? SCNText else {
            return
        }
        word.string = getCurrentWord()
        word.materials[0].diffuse.contents = UIColor.green
        selectedWord.position = SCNVector3Make(3, 5, -1.7)
        selectedWord.scale = SCNVector3Make(1, 1, 1)
        selectedWord.opacity = 1

        rootNode.runAction(SCNAction.wait(duration: 0.1)) {
            let fadeAwayAction = SCNAction.fadeOut(duration: 1)
            let moveAwayAction = SCNAction.move(to: SCNVector3Make(-40, 25, -20), duration: 1)
            let growAction = SCNAction.scale(to: 3, duration: 1)

            for action in [fadeAwayAction, moveAwayAction, growAction] {
                self.selectedWord.runAction(action)
            }
        }
    }

    func showDuplicateSelection() {
        for selection in selectionPath {
            guard let material = selection.geometry?.materials.first else {
                continue
            }
            material.diffuse.contents = UIColor.yellow.withAlphaComponent(0.6)
        }
    }

    func showInvalidSelection() {
        for selection in selectionPath {
            guard let material = selection.geometry?.materials.first else {
                continue
            }

            material.diffuse.contents = UIColor.red.withAlphaComponent(0.6)
        }
    }

    /// Clears out the current selection.
    func clearSelection() {
        cleanOldShapes()
        selection.removeAll()
    }

}

// MARK: - Helpers

extension IntroductionScene {

    func updateGameCamera() {
        guard let gameCamera = gameCamera else {
            assert(false, "No Game Camera")
            return
        }
        if UIDevice.current.isiPad {
            gameCamera.camera?.orthographicScale = 15
        }
    }

    /// Adds a selection between the provided dice.  This function will create a
    /// new SCNNode which is the cylinder object that represents the selection.
    ///
    /// - Parameters:
    ///   - fromDie: The First die that the selection starts from.
    ///   - toDie: The next die that the selection goes to.
    func createSelection(_ fromDie: Die3D, toDie: Die3D) {
        guard !selectionLocked else {
            return
        }

        // calculate sizes for the cylinder
        let cylinderLength = fromDie.point2D.distanceTo(another: toDie.point2D)

        // Build the Cylinder Geometry
        let line = SCNCylinder(radius: 0.5, height: cylinderLength)
        let node = SCNNode(geometry: line)
        node.position = SCNVector3Make(fromDie.position.x, fromDie.position.y + 3, fromDie.position.z)

        // Figure out / perform the rotation angle for the cylinder
        let angle = Double(mapMovesToAngle(fromDie.arrayIndex!, point2: toDie.arrayIndex!))
        node.pivot = SCNMatrix4MakeTranslation(0, Float(cylinderLength/2), 0)
        node.eulerAngles = SCNVector3Make(-90.radians, angle.radians, 0)

        // Configure the Material for the cylinder
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green.withAlphaComponent(0.6)
        line.materials = [material]

        // Now add it to the scene and the selection array
        diceBoard.addChildNode(node)
        selectionPath.append(node)
    }

    /// Removes the selection.  It will do it instantly (no animation) if you set animated to false.
    ///
    /// - Parameter animated: Whether or not you want a nice fade out animation to accompany the removal of the shapes.
    func cleanOldShapes(_ animated: Bool = true) {
        guard animated else {
            for path in selectionPath {
                path.runAction(SCNAction.removeFromParentNode())
            }
            selectionPath.removeAll()
            return
        }

        let myShapes = selectionPath
        selectionPath.removeAll()

        selectionLocked = true
        for path in myShapes {
            path.runAction(SCNAction.fadeOut(duration: 0.3)) {
                path.removeFromParentNode()
            }
        }
        diceBoard.runAction(SCNAction.wait(duration: 0.3)) {
            self.selectionLocked = false
        }
    }

    /// This method figures out what dice to render the individual selection segments
    /// from/to and then delegates this off to the 3D Scene.
    func renderSelection() {
        guard selection.count > 1 else {
            return
        }
        for index in 1...selection.count-1 {
            let fromDie = selection[index-1]
            let toDie = selection[index]
            createSelection(fromDie, toDie: toDie)
        }
    }

    /// Given the dice positions you've provided, this will give you the angle to rotate the cylinder.
    /// Note that the points are array index points, not the exact points of the dice themselves.
    /// (e.g. 0,0; 3,3; 2,1; ...)
    ///
    /// - Parameters:
    ///   - point1: The starting point for the cylinder.
    ///   - point2: The (approximate) ending point for the cylinder.
    /// - Returns: The Angle to rotate the cylinder based on the starting and ending points.
    func mapMovesToAngle(_ point1: CGPoint, point2: CGPoint) -> Float {
        let deltaX = Int(point1.x - point2.x)
        let deltaY = Int(point1.y - point2.y)
        var angle: Float = 0

        // Not very clever, is it?
        if deltaX == 0 {
            if deltaY == 1 {
                angle = 270
            } else if deltaY == -1 {
                angle = 90
            }
        } else if deltaX == 1 {
            if deltaY == 0 {
                angle = 180
            } else if deltaY == 1 {
                angle = 225
            } else if deltaY == -1 {
                angle = 135
            }
        } else if deltaX == -1 {
            if deltaY == 0 {
                angle = 360
            } else if deltaY == 1 {
                angle = 315
            } else if deltaY == -1 {
                angle = 45
            }
        }

        return angle
    }

    func configure() {
        guard let chalkboard = rootNode.childNode(withName: "Chalkboard", recursively: false) else {
            let message = "Couldn't get the Chalkboard node, the scene cannot be created"
            recordSystemError(ApplicationError.sceneError(message: message))
            return
        }
        let material = SCNMaterial()
        material.diffuse.contents = #imageLiteral(resourceName: "HomeScreen2-16x9")
        chalkboard.geometry?.materials = [material]

        guard let scoreTextNode = rootNode.childNode(withName: "score", recursively: false)?.geometry as? SCNText else {
            let message = "Couldn't get the Score node, the scene cannot be created"
            recordSystemError(ApplicationError.sceneError(message: message))
            return
        }
        guard let timerTextNode = rootNode.childNode(withName: "timer", recursively: false)?.geometry as? SCNText else {
            let message = "Couldn't get the Timer node, the scene cannot be created"
            recordSystemError(ApplicationError.sceneError(message: message))
            return
        }
        guard let selectedWordNode = rootNode.childNode(withName: "selectedWord", recursively: false) else {
            let message = "Couldn't get the SelectedWord Node, the scene cannot be created"
            recordSystemError(ApplicationError.sceneError(message: message))
            return
        }
        guard let diceBoardNode = rootNode.childNode(withName: "DiceBoard", recursively: false) else {
            let message = "Couldn't get the DiceBoard Node, the scene cannot be created"
            recordSystemError(ApplicationError.sceneError(message: message))
            return
        }
        scoreNode = scoreTextNode
        timerNode = timerTextNode
        selectedWord = selectedWordNode
        diceBoard = diceBoardNode
    }

    /// Renders the Dice (in the appropriate position, based on their index)..
    ///
    /// - Parameter index: The Index of the die you want to create.
    func createDie(_ index: Int) {
        guard let board = board else {
            assert(false, "There is no board")
            return
        }
        let diceSize: CGFloat = 4
        let dieModel = board.board[index]
        let factor: Float = 4.5

        // x: -3, y: 3, z: -9
        // Add x + space factor for each ->
        // Add z + space factor for each \/

        let row = Float(index / 4)
        let column = Float(index % 4)

        //swiftlint:disable identifier_name
        let x: Float = -6.75 + column * factor
        let y: Float = 3
        let z: Float = -6.75 + row * factor
        //swiftlint:enable identifier_name

        let die = Die3D(size: diceSize, die: dieModel)
        die.eulerAngles = SCNVector3Make(Float(Double.pi * -90.0), 0, 0)

        die.position = SCNVector3Make(x, y, z)
        die.arrayIndex = CGPoint(x: floor(CGFloat(index / 4)), y: CGFloat(index%4))
        die.index = index
        dice.append(die)
        diceBoard.addChildNode(die)
    }

    func findAndRemoveCameras() {
        demoCamera = rootNode.childNode(withName: "DemoCamera", recursively: false)
        gameCamera = rootNode.childNode(withName: "GameCamera", recursively: false)
        demoCamera?.removeFromParentNode()
        gameCamera?.removeFromParentNode()
    }

    func formatScore(_ score: Int) -> String {
        var result = ""

        if score < 100 {
            result += "0"
        }
        if score < 10 {
            result += "0"
        }
        result += String(score)

        return result
    }
}

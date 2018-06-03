//
//  SCNGameScene.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/3/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import SpriteKit
import SceneKit

/// A class that will render a Scroggle Game Board in the provided SKView.
/// 1. A new SKScene is created (consuming the entire SKView screen)
/// 2. The DiceTray.scn file is loaded into an SCNScne
/// 3. A new SCN3DNode is created and added to the Scene from step 1
/// 4. The SCNScene (from step 2) is set as the scene in the SCN3DNode
class SCNGameScene {

    let skView: SKView
    var gameScene: SCNScene?
    var dice: [SCNNode] = []

    init(withView view: SKView) {
        skView = view
        self.bootstrapScene()
    }

}

// MARK: - Implementation

extension SCNGameScene {

    /// Bootstraps the scene and delegates off to other helper functions.
    func bootstrapScene() {
        let sceneNode = SK3DNode(viewportSize: skView.frame.size)
        guard let trayScene = SCNScene(named: "art.scnassets/DiceTray.scn") else {
            return assertionFailure("Failed to create the dice tray scene")
        }
        sceneNode.scnScene = trayScene
        sceneNode.position = CGPoint(x: skView.bounds.midX, y: skView.bounds.midY)

        let diceTray = SKScene(size: skView.frame.size)
        skView.presentScene(diceTray)
        diceTray.addChild(sceneNode)

        // Debugging
        skView.showsPhysics = true
        sceneNode.physicsBody = SKPhysicsBody(rectangleOf: skView.frame.size)
        sceneNode.physicsBody?.affectedByGravity = false
        // End Debugging

        gameScene = trayScene
        readDiceReferences()
        setDiceMaterial()
    }

    /// Reads the dice nodes from the scene and stores them in the `dice` array.
    func readDiceReferences() {
        dice.removeAll()
        for i in 0..<16 {
            guard let die = gameScene?.rootNode.childNodes.filter({$0.name == "d\(i)"}).first else {
                continue
            }
            dice.append(die)
        }
        assert(dice.count == 16)
    }

    /// Sets the "letters" for each side of the dice.
    /// This is accomplished by generating images for the letters
    /// and setting the materials for each size.
    func setDiceMaterial() {
        assert(dice.count == DiceProvider.instance.fourByFour.count)
        for i in 0..<dice.count {
            guard let box = dice[i].geometry as? SCNBox else {
                continue
            }
            box.materials = DiceProvider.instance.fourByFour[i].map({self.createMaterialForText(text: $0)})
        }
    }

}

// MARK: - Dice rotation

extension SCNGameScene {

    /// Rotates the provided die to the appropriate side.
    ///
    /// - Parameters:
    ///   - die: The die to be rotated
    ///   - index: The array index (from the dice string array) to be rotated to.
    func rotate(die: SCNNode, to index: Int) {
        let duration: TimeInterval = 1
        let rotation: SCNAction
        switch index {
        case 1:
            rotation = SCNAction.rotateTo(x: 0, y: CGFloat(270.radians), z: 0, duration: duration)
        case 2:
            rotation = SCNAction.rotateTo(x: CGFloat(180.radians), y: 0, z: CGFloat(180.radians), duration: duration)
        case 3:
            rotation = SCNAction.rotateTo(x: 0, y: CGFloat(90.radians), z: 0, duration: duration)
        case 4:
            rotation = SCNAction.rotateTo(x: CGFloat(90.radians), y: 0, z: 0, duration: duration)
        case 5:
            rotation = SCNAction.rotateTo(x: CGFloat(270.radians), y: 0, z: 0, duration: duration)
        default:
            rotation = SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: duration)
        }

        die.runAction(rotation)
    }
}

// MARK: - Dice material generation

extension SCNGameScene {

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

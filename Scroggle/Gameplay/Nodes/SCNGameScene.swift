//
//  SCNGameScene.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/3/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import SpriteKit
import SceneKit

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

    func bootstrapScene() {
        let sceneNode = SK3DNode(viewportSize: skView.frame.size)
        guard let trayScene = SCNScene(named: "art.scnassets/DiceTray.scn") else {
            return assertionFailure("Failed to create the dice tray scene")
        }
        sceneNode.scnScene = trayScene
        sceneNode.position = CGPoint(x: skView.frame.midX, y: skView.frame.midY)

        let diceTray = SKScene(size: skView.frame.size)
        skView.presentScene(diceTray)
        diceTray.addChild(sceneNode)

        gameScene = trayScene
        readDiceReferences()
        setDiceMaterial()
    }

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

    func setDiceMaterial() {
        guard let die = dice.first, let box = die.geometry as? SCNBox else {
            return assertionFailure("Failed to get the first die")
        }
        box.materials = DiceProvider.instance.fourByFour[0].map({self.createMaterialForText(text: $0)})
    }


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

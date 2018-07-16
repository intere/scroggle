//
//  Die3D.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import SceneKit

/// A 3d representation of a Die.
class Die3D: SCNNode {

    struct Configuration {
        static var dicePopValue: Float = 0.7
    }

    let k2DText: CGFloat = 0.0
    var size: CGFloat = 10.0
    var die: Die?
    var arrayIndex: CGPoint?
    var index: Int = 0

    var roll: String? {
        return die?.roll
    }

    public init(size: CGFloat, die: Die) {
        super.init()
        self.die = die
        self.size = size
        createDie()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

// MARK: - Public API

extension Die3D {

    var point2D: CGPoint {
        return CGPoint(x: CGFloat(position.x), y: CGFloat(position.z))
    }

    func getSelectedSide() -> Int {
        return die!.getSelectedSide()
    }

    func animateSelection() {
        guard let geometry = geometry else {
            return
        }

        let material = geometry.materials[getSelectedSide()]

        let action1 = SCNAction.run { _ in
            material.emission.contents = UIColor.blue
        }
        let action2 = SCNAction.run { _ in
            material.emission.contents = UIColor.black
        }

        runAction(SCNAction.sequence([action1, SCNAction.wait(duration: 0.5)])) { [weak self] in
            self?.runAction(action2)
        }
    }

    func addPhysicsBody() {
        guard nil == physicsBody else {
            return
        }

        // Physics Body makes this plummet to the ground.
        let shape = SCNPhysicsShape(geometry: geometry!, options: [:])
        let dieBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        physicsBody = dieBody

    }

    func animateToSelectedSide(_ duration: CFTimeInterval, repeats: Float = 1) {
        guard let die = die else {
            return
        }

        for index in 0...die.sides.count-1 {
            guard die.roll == die.sides[index] else {
                continue
            }

            animateRandomlyThenToIndex(duration, index: index)
            return
        }
    }

    /// This function handles the initial animation for a game.
    ///
    /// - Parameters:
    ///   - duration: How long to perform the animation for.
    ///   - index: The side to show.
    func animateRandomlyThenToIndex(_ duration: CFTimeInterval, index: Int) {
        if duration <= 1 {
            animateToIndex(duration, index: index)
        } else {
            randomRotateRandomHeight(x: position.x, z: position.z, duration: 0.2) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.randomRotateOriginalHeight(x: strongSelf.position.x,
                                                      z: strongSelf.position.z, duration: 0.2) {
                    DispatchQueue.main.async { [weak self] in
                        self?.animateRandomlyThenToIndex(duration - 0.4, index: index)
                    }
                }
            }
        }
    }

    func introAnimateDice(duration: TimeInterval = 0.2) {
        randomRotateRandomHeight(x: position.x, z: position.z, duration: duration) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.randomRotateOriginalHeight(x: strongSelf.position.x,
                                                  z: strongSelf.position.z, duration: duration) {
                DispatchQueue.main.async { [weak self] in
                    self?.introAnimateDice(duration: duration)
                }
            }
        }
    }

    func randomRotateOriginalHeight(x: Float, z: Float, duration: TimeInterval, completionHandler block: (() -> Void)? = nil) {
        //swiftlint:disable:previous identifier_name line_length
        let rotation = SCNAction.rotateTo(x: randomRadians(), y: randomRadians(),
                                          z: randomRadians(), duration: duration)
        let move = SCNAction.move(to: SCNVector3Make(x, 3, z), duration: duration)
        move.timingMode = .easeIn

        runAction(rotation)
        runAction(move) {
            block?()
        }
    }

    func randomRotateRandomHeight(x: Float, z: Float, duration: TimeInterval, completionHandler block: (() -> Void)? = nil) {
        //swiftlint:disable:previous identifier_name line_length
        let rotate1 = SCNAction.rotateTo(x: randomRadians(), y: randomRadians(), z: randomRadians(), duration: duration)
        let move1 = SCNAction.move(to: SCNVector3Make(x, randomYPosition(), z), duration: duration)
        move1.timingMode = .easeOut

        runAction(rotate1)
        runAction(move1) {
            block?()
        }
    }

    /// Animates the die to the specified index of the die (this essentially maps the
    /// index of the character to a position on the die).
    ///
    /// - Parameters:
    ///   - duration: How long to take to perform the rotation.
    ///   - index: The index (side) of the die to rotate to.
    func animateToIndex(_ duration: CFTimeInterval, index: Int) {

        var eulerVector: SCNVector3? = nil

        switch index {
        case 0:
            eulerVector = SCNVector3Make(270.radians, 0, 0)

        case 1:
            eulerVector = SCNVector3Make(270.radians, 0, 90.radians)

        case 2:
            eulerVector = SCNVector3Make(90.radians, 180.radians, 0)

        case 3:
            eulerVector = SCNVector3Make(270.radians, 0, 270.radians)

        case 4:
            eulerVector = SCNVector3Make(0, 0, 0)

        case 5:
            eulerVector = SCNVector3Make(180.radians, 0, 0)

        default:
            break
        }

        guard let action = eulerVector?.rotateTo(duration) else {
            return
        }

        runAction(action)
    }

}

// MARK: - Helpers

extension Die3D {

    func randomRadians() -> CGFloat {
        return CGFloat(GLKMathDegreesToRadians(Float(arc4random() % 360)))
    }

    func randomYPosition() -> Float {
        return Float((arc4random() % 100)) * Configuration.dicePopValue + 4
    }

    func createDie() {
        var materials: [SCNMaterial] = []
        for index in 0...die!.sides.count-1 {
            materials.append(createMaterialForText(die!.sides[index]))
        }

        let box = SCNBox(width: size, height: size, length: size, chamferRadius: size / 8)
        box.materials = materials
        geometry = box
        opacity = 1
        castsShadow = true
    }

    /** Given the provided string, this function will create you a material for the given text you provide. */
    func createMaterialForText(_ text: String) -> SCNMaterial {
        let label = createLabelViewForText(text)
        let image = imageWithView(label)
        let material = SCNMaterial()
        material.diffuse.contents = image
        return material
    }

    /** Creates a Label View for the provided text.  */
    func createLabelViewForText(_ text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        label.text = text
        label.font = UIFont.Scroggle.defaultFont(ofSize: 80)
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }

    /** Given the provided View, this method will create an image for that view. */
    func imageWithView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 1.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }

}

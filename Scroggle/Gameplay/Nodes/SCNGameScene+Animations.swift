//
//  SCNGameScene+Animations.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/3/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import SceneKit

extension SCNGameScene {

    /// Rolls the dice in the scene for you
    func rollDice() {
        helpRollDice()
    }

    /// Rolls all of the dice to random positions
    func helpRollDice(completion: GenericBlock? = nil) {
        dice.forEach { [weak self] die in
            let originalPosition = die.position
            let randomEuler = eulerAngle(for: 5.random)
            self?.rollRandom(die: die) {
                self?.reset(die: die, position: originalPosition, angle: randomEuler)
            }
        }
    }

    func reset(die: SCNNode, position: SCNVector3, angle: SCNVector3, completion: GenericBlock? = nil) {
        let moveAction = SCNAction.move(to: position, duration: AnimationConstants.duration)
        let rotateAction = SCNAction.rotateTo(x: CGFloat(angle.x), y: CGFloat(angle.y), z: CGFloat(angle.z), duration: AnimationConstants.duration)
        die.runAction(SCNAction.group([moveAction, rotateAction]))
    }

    /// Rolls the die at the provided index.
    ///
    /// - Parameter index: The index of the die you want to roll
    func rollRandom(at index: Int, completion: GenericBlock? = nil) {
        guard index < dice.count else {
            return
        }
        rollRandom(die: dice[index])
    }

    /// Rolls the die to a random position
    ///
    /// - Parameter die: The die to be rolled to a random position.
    func rollRandom(die: SCNNode, completion: GenericBlock? = nil) {
        let randomX = Float(6.random) - 3
        let randomY = Float(6.random) - 3
        let randomZ = Float(25.random) + 5
        DLog("Random Position: \(Int(randomX)), \(Int(randomY)), \(Int(randomZ))")

        let randomAngleX = CGFloat(360.random.radians)
        let randomAngleY = CGFloat(360.random.radians)
        let randomAngleZ = CGFloat(360.random.radians)

        let moveAction = SCNAction.move(to: SCNVector3Make(randomX, randomY, randomZ), duration: AnimationConstants.duration)
        let rotateAction = SCNAction.rotateTo(x: randomAngleX, y: randomAngleY, z: randomAngleZ, duration: AnimationConstants.duration)
        die.runAction(SCNAction.group([moveAction, rotateAction])) {
            completion?()
        }
    }

    struct AnimationConstants {
        static let duration = 0.5
    }
}

//
//  GameSceneController+Animations.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/3/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import SceneKit

extension GameSceneController {

    /// Rolls the dice in the scene for you
    func rollDice() {
        helpRollDice()
    }

    /// Rolls all of the dice to random positions
    func helpRollDice(completion: GenericBlock? = nil) {
        dice.forEach { [weak self] die in
            self?.randomlyMove(die: die)
        }
    }

    /// Moves the provided die to a random position
    ///
    /// - Parameter die: The die to be moved
    func randomlyMove(die: SCNNode) {
        let originalPosition = die.position
        let randomEuler = eulerAngle(for: 5.random)
        rollRandom(die: die) { [weak self] in
            self?.reset(die: die, position: originalPosition, angle: randomEuler)
        }
    }

    /// Resets the provided die back to the provided position and angle.
    ///
    /// - Parameters:
    ///   - die: The die to be reset back.
    ///   - position: The position to move the die back to.
    ///   - angle: The angle to move the die back to.
    ///   - completion: optional block to be executed after the animation is complete.
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

// MARK: - Debugging

extension GameSceneController {

    /// Debugging function that merely animates the position of each die.
    ///
    /// - Parameter index: The index of the die you want to animate.
    func animateDice(_ index: Int = 0) {
        guard index < dice.count else {
            return
        }
        randomlyMove(die: dice[index])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.animateDice(index + 1)
        }
    }

}

//
//  GameSceneController+Animations.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/3/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import SceneKit
import SpriteKit

extension GameSceneController {

    /// Rolls the dice in the scene for you
    func rollDice(completion: GenericBlock? = nil) {
        helpRollDice { [weak self] in
            self?.helpRollDice { [weak self] in
                self?.helpResetDice {
                    completion?()
                }
            }
        }
    }

    /// Resets the dice into their positions
    ///
    /// - Parameter completion:
    func helpResetDice(completion: GenericBlock? = nil) {
        var results = 0
        let count = dice.count

        for index in 0..<count {
            let die = gameContext.game.board.board[index]
            let euler = eulerAngle(for: die.selectedSide)

            rollRandom(at: index) { [weak self] in
                guard let self = self else {
                    return
                }
                self.reset(die: self.dice[index], position: self.dicePositions[index], angle: euler) {
                    results += 1
                    guard results == count else {
                        return
                    }
                    completion?()
                }
            }
        }
    }

    func setEulerAnglesForDice() {
        guard let diceArray = GameContextProvider.instance.currentGame?.game.board.board else {
            return assertionFailure("Failed to get the dice")
        }
        for index in 0..<dice.count {
            dice[index].eulerAngles = eulerAngle(for: diceArray[index].selectedSide)
        }
    }

    /// Rolls all of the dice to random positions
    func helpRollDice(completion: GenericBlock? = nil) {
        var results = 0
        let count = dice.count

        dice.forEach { [weak self] die in
            self?.randomlyMove(die: die) {
                results += 1
                if results == count {
                    completion?()
                }
            }
        }
    }

    /// Rotates the provided die to a random side
    ///
    /// - Parameter die: The die to be moved
    func randomlyMove(die: SCNNode, completion: GenericBlock? = nil) {
        let originalPosition = die.position
        let randomEuler = eulerAngle(for: 5.random)
        rollRandom(die: die) { [weak self] in
            self?.reset(die: die, position: originalPosition, angle: randomEuler) {
                completion?()
            }
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
        let rotateAction = SCNAction.rotateTo(x: CGFloat(angle.x), y: CGFloat(angle.y),
                                              z: CGFloat(angle.z), duration: AnimationConstants.duration)
        die.runAction(SCNAction.group([moveAction, rotateAction])) {
            completion?()
        }
    }

    /// Rolls the die at the provided index.
    ///
    /// - Parameter index: The index of the die you want to roll
    func rollRandom(at index: Int, completion: GenericBlock? = nil) {
        guard index < dice.count else {
            return
        }
        rollRandom(die: dice[index], completion: completion)
    }

    /// Rolls the die to a random position
    ///
    /// - Parameter die: The die to be rolled to a random position.
    func rollRandom(die: SCNNode, completion: GenericBlock? = nil) {
        let randomX = Float(6.random) - 3
        let randomY = Float(6.random) - 3
        let randomZ = Float(25.random) + 5
//        DLog("Random Position: \(Int(randomX)), \(Int(randomY)), \(Int(randomZ))")

        let randomAngleX = CGFloat(360.random.radians)
        let randomAngleY = CGFloat(360.random.radians)
        let randomAngleZ = CGFloat(360.random.radians)

        let moveAction = SCNAction.move(to: SCNVector3Make(randomX, randomY, randomZ),
                                        duration: AnimationConstants.duration)
        let rotateAction = SCNAction.rotateTo(x: randomAngleX, y: randomAngleY, z: randomAngleZ,
                                              duration: AnimationConstants.duration)
        die.runAction(SCNAction.group([moveAction, rotateAction])) {
            completion?()
        }
    }

    /// Gets you the SCNNode for the die at the provided index.
    ///
    /// - Parameter index: The index of the die you'd like.
    /// - Returns: The SCNNode for the die at the provided index (if it could be found).
    func getDie(at index: Int) -> SCNNode? {
        let name = dieName(at: index)
        return gameScene?.rootNode.childNodes.filter({ $0.name == name }).first
    }

    /// Gets you the name of the die at the provided index.
    ///
    /// - Parameter index: the index of the die you want.
    /// - Returns: name of the die at the provided index.
    func dieName(at index: Int) -> String {
        return "d\(index)"
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

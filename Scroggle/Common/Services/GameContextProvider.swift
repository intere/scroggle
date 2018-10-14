//
//  GameContextProvider.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

// TODO: extract a protocol (GameContextService) from GameContextProvider

class GameContextProvider {

    struct Configuration {
        static var demoMode = true
    }

    static var instance = GameContextProvider()

    /// The Current Game Reference
    var currentGame: GameContext? {
        didSet {
            hasGame = nil != currentGame
        }
    }

    /// Is there a current game?
    var hasGame = false

}

// MARK: - Public Interface

extension GameContextProvider {

    @discardableResult
    /// Creates a Game Context, rolls the dice and sets the current game reference
    /// to be the same context we hand you back.
    ///
    /// - Parameter timeType: The Game Time Type (how long the game will run).
    /// - Returns: A new GameContext object that we've set to be the current game.
    func createSinglePlayerGame(_ timeType: GameTimeType) -> GameContext {
        let context = GameContext()

        if Configuration.demoMode {
            if let dice = DiceProvider.instance.loadDemoDice() {
                context.game.board = dice
                context.addAndScoreWord("TOSS")
                context.addAndScoreWord("SOT")
                context.addAndScoreWord("EATS")
                context.addAndScoreWord("EAT")
                context.addAndScoreWord("FARE")
                context.addAndScoreWord("FAR")
                context.addAndScoreWord("FEVER")
                context.addAndScoreWord("EAR")
                context.addAndScoreWord("RIB")
            }
        } else {
            if let dice = DiceProvider.instance.rollDice() {
                context.game.board = dice
            }
        }

        context.game.timeType = timeType
        currentGame = context
        return context
    }

    /// Clones the current game into a new game and sets the currentGame to that new copy.
    func replayCurrentGame() {
        guard let original = currentGame else {
            return assertionFailure("ERROR: Failed to get the current game")
        }

        currentGame = GameContext(from: original)
    }

    /// Creates a new game, but uses the current games time.
    func replayGameWithSameTime() {
        guard let currentTimeType = currentGame?.game.timeType else {
            return assertionFailure("ERROR: Failed to get the current game time")
        }

        createSinglePlayerGame(currentTimeType)
    }
}

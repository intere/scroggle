//
//  GameContext.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

/**
 This class is the Game Context.  It is responsible for tracking the Game Board, the Timer, Stats, etc.
 */
open class GameContext {

    open let game = Game()
    open var gameState: GameState = .kGameStateWaitingForMatch
    open var isReplay = false

}

// MARK: - API

public extension GameContext {

    func reset() {
        game.reset()
        gameState = .kGameStateWaitingForStart
    }

    /// Get the longest word
    var longestWord: Int {
        var longest: Int = 0
        for word in game.words {
            longest = max(longest, word.characters.count)
        }
        return longest
    }

    /**
     Tells you if the user has already guessed the word this game.
     - Parameter word: The word to check.
     - Returns: True if the word is in the list of guessed words, false otherwise.
     */
    func alreadyGuessed(_ word: String) -> Bool {
        return game.hasWord(word)
    }

    /**
     Adds the word to the list of words for the game and adds the points to the game score.
     - Parameter word: The word to be added and scored.
     */
    func addAndScoreWord(_ word: String) {
        let score = ScoreProvider.instance.scoreWord(word)
        game.score += score
        game.words.append(word)
    }

}

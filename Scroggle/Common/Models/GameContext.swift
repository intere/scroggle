//
//  GameContext.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

/// This class is the Game Context.  It is responsible for keeping track of:
/// * The Game Board
/// * The Timer
/// * Game Stats
class GameContext: NSObject {

    /// The game object
    let game = Game()

    /// The state of the game (active, done, etc)
    var gameState: GameState = .waitingForMatch

    /// Is this a replay of another game?
    var isReplay = false

    /// How many times has this game been replayed?
    var replayCount = 0

    /// Default initialization, creates a new game (random board) with default options.
    override init() {
        super.init()
    }

    /// Initializes this context from another context.  Essentially it just copies the game board and timer
    ///
    /// - Parameter context: The context to initialize from.
    init(from context: GameContext) {
        super.init()
        isReplay = true
        game.board = context.game.board
        game.timeType = context.game.timeType
        replayCount = context.replayCount + 1
    }

}

// MARK: - API

extension GameContext {

    /// Get the longest word
    var longestWord: Int {
        var longest: Int = 0
        for word in game.words {
            longest = max(longest, word.count)
        }
        return longest
    }

    /// Tells you if the user has already guessed the word this game.
    ///
    /// - Parameter word: The word to check.
    /// - Returns: True if the word is in the list of guessed words, false otherwise.
    func alreadyGuessed(_ word: String) -> Bool {
        return game.hasWord(word)
    }

    /// Adds the word to the list of words for the game and adds the points to the game score.
    ///
    /// - Parameter word: The word to be added and scored.
    func addAndScoreWord(_ word: String) {
        let score = ScoreProvider.instance.scoreWord(word)
        game.score += score
        game.words.append(word)
        Notification.Scroggle.GameEvent.wordGuessed.notify(withObject: word as NSString)
//        DLog("Score Updated: \(game.score)")
        Notification.Scroggle.GameEvent.scoreUpdated.notify()
    }

}

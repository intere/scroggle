//
//  Game.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

/// A basic model that keeps track of metadata about a game.
/// For example, the score, number of bad guesses, rotations, etc
class Game: NSObject {

    /// The current game's score
    var score = 0
    /// The number of incorrect guesses (strings that were not words)
    var badGuesses = 0
    /// The number of times a user guessed a word they'd already guessed
    var duplicateGuesses = 0
    /// The number of times a user rotated the game board during the game
    var rotations = 0
    /// The list of correct word guesses for this game
    var words = [String]()

    /// The game configuration (the location of the dice and their selected letters)
    var board: GameBoard! {
        didSet {
            hasBoard = true
        }
    }

    /// Does this game yet have a board?
    var hasBoard = false

    /// The length of time that the game is for
    var timeType = GameTimeType.default
}

// MARK: - API

extension Game {

    /// Tells you if the provided word is already in the list of words.
    ///
    /// - Parameter word: The word to check.
    /// - Returns: True if the word exists in the word list already, false otherwise.
    func hasWord(_ word: String) -> Bool {
        for wordCheck in words where wordCheck == word {
            return true
        }

        return false
    }
}

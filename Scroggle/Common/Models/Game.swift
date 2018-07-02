//
//  Game.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

class Game: NSObject {

    var score = 0
    var badGuesses = 0
    var duplicateGuesses = 0
    var rotations = 0
    var words = [String]()

    var board: GameBoard! {
        didSet {
            hasBoard = true
        }
    }

    var hasBoard = false
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

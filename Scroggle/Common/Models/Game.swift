//
//  Game.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

open class Game: NSObject {

    open var score: Int = 0
    open var badGuesses: Int = 0
    open var duplicateGuesses: Int = 0
    open var rotations = 0
    open var words = [String]()
    open var board: GameBoard! {
        didSet {
            hasBoard = true
        }
    }
    open var hasBoard = false
    open var timer: GameTimer! {
        didSet {
            hasTimer = true
        }
    }
    open var hasTimer = false

}

// MARK: - API

public extension Game {

    /// Resets the game
    func reset() {
        words.removeAll()
        if hasTimer {
            timer = DefaultGameTimer(timeType: timer.timeType)
        }
        score = 0
        badGuesses = 0
        duplicateGuesses = 0
        rotations = 0
    }

    /**
     Tells you if the provided word is already in the list of words.
     - Parameter word: The word to check.
     - Returns: True if the word exists in the word list already, false otherwise.
     */
    func hasWord(_ word: String) -> Bool {
        for wordCheck in words {
            if wordCheck == word {
                return true
            }
        }
        return false
    }
}

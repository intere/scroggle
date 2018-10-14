//
//  DiceProvider.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

/// A Provider that will generate you GameBoards.
///
/// **Note:** To generate GameBoards, we depend on the `dice.json` file living in the main bundle
class DiceProvider {
    /// Singleton instance, shared for everyone
    static let instance = DiceProvider()

    /// The 4x4 2-D Array (dice, faces of dice)
    var fourByFour: [[String]] = [[]]

    /// An array of vowels (for validating a board isn't garbage)
    private let vowels = ["A", "E", "I", "O", "U", "Y"]

    /// Default initialization.
    private init() {
        loadDiceFromBundle()
    }

    /// Using the 4x4 board, this function will roll you dice and hand that game board back to you.
    ///
    /// - Returns: A GameBoard that's been shuffled and a side has been randomly selected for each die.
    func rollDice() -> GameBoard? {
        var board: GameBoard? = nil
        let copyFrom = NSMutableArray(array: fourByFour)
        let shuffled = NSMutableArray()

        while copyFrom.count > 0 {
            let index: Int = Int(arc4random_uniform(UInt32(copyFrom.count)))
            shuffled.add(copyFrom.object(at: index))
            copyFrom.removeObject(at: index)
        }

        if let shuffledArray = shuffled as NSArray as? [[String]] {
            board = GameBoard(dice: shuffledArray)
            if let board = board {
                if !hasEnoughVowels(board) {
                    return rollDice()
                }
            }
        }

        return board
    }
}

// MARK: - Helper Methods

extension DiceProvider {

    /// Tells you if the provided board has enough vowels selected in it.
    ///
    /// - Parameter board: The board to check for vowels.
    /// - Returns: True if it has at least 3 vowels
    func hasEnoughVowels(_ board: GameBoard) -> Bool {
        return board.board.map({ vowels.contains($0.roll) }).filter({ $0 }).count > 3
    }

    /// Loads the dice.json file and populates the data structures from it.
    func loadDiceFromBundle() {
        defer {
            assert(fourByFour.count > 0)
        }
        guard let path = Bundle.main.path(forResource: "dice", ofType: "json") else {
            return DLog("Couldn't find dice.json")
        }
        do {
            let json = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
            guard let data = json.data(using: String.Encoding.utf8.rawValue) else {
                return DLog("Failed to convert contents of dice.json to NSData")
            }

            guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                as? [String: [[String]]] else {
                return DLog("The dice.json came back in an unknown structure")
            }

            guard let boardData = dict["4x4"] else {
                return DLog("The dice.json had a 4x4 that came back in an unknown format")
            }

            fourByFour = boardData
        } catch {
            DLog("Exception trying to read dice.json file")
        }
    }

    /// Loads the demo.json file and provides back the GameBoard for that json.
    ///
    /// - Returns: The GameBoard for the demo board.
    func loadDemoDice() -> GameBoard? {
        guard let path = Bundle.main.path(forResource: "demo", ofType: "json") else {
            DLog("Failed to find the demo.json file")
            return nil
        }

        do {
            let json = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
            guard let data = json.data(using: String.Encoding.utf8.rawValue) else {
                DLog("Failed to load the contents of the demo.json file")
                return nil
            }

            return GameBoard.fromData(data)
        } catch {
            DLog("Exception trying to read demo.json")
            recordSystemError(error)
            return nil
        }
    }
}

//
//  DiceProvider.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

// TODO: extract a protocol (DiceService) from DiceProvider

class DiceProvider {
    static let instance = DiceProvider()

    var fourByFour: [[String]] = [[]]   // The 4x4 2-D Array (dice, faces of dice)

    let vowels = ["A", "E", "I", "O", "U", "Y"]

    fileprivate init() {
        loadDiceFromBundle()
    }

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

    func hasEnoughVowels(_ board: GameBoard) -> Bool {
        var count = 0
        for die in board.rawData {
            if vowels.contains(die.roll) {
                count += 1
            }
        }

        return count > 3
    }

    func loadDiceFromBundle() {
        if let path = Bundle.main.path(forResource: "dice", ofType: "json") {
            do {
                if let data = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue).data(using: String.Encoding.utf8.rawValue) {

                    var dict: [String : [[String]]] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : [[String]]]
                    fourByFour = dict["4x4"]!
                } else {
                    DLog("Failed to convert contents of dice.json to NSData")
                }
            } catch {
                DLog("Exception trying to read dice.json file")
            }
        }
        else {
            DLog("Couldn't find dice.json")
        }
    }

    func loadDemoDice() -> GameBoard? {
        if let path = Bundle.main.path(forResource: "demo", ofType: "json") {
            do {
                if let data = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue).data(using: String.Encoding.utf8.rawValue) {
                    return GameBoard.fromData(data)
                }
            } catch {
                DLog("Exception trying to read demo.json")
                recordSystemError(error)
            }
        }

        return nil
    }
}

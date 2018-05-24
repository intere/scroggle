//
//  GameBoard.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

/// Represents the "Game Board" itself (which is more or less just a container for the dice on the baord).
class GameBoard {
    var board: [Die]

    init(dice: [[String]]) {
        board = []
        for sides in dice {
            board.append(Die(sides:sides))
        }
    }

}

// MARK: - Public Interface

extension GameBoard {

    /// Builds you a string that represents the configuration of the board.
    ///
    /// - Returns: The current rolled configuration of the board.
    func getConfiguration() -> String {
        let size = Int(sqrt(Double(board.count)))
        var result = ""

        for i in 0..<board.count {
            if i % size == 0 {
                result += "\n"
            } else {
                result += " "
            }
            result += board[i].roll
        }

        return result
    }

    /// Get the raw board as an array.
    ///
    /// - Returns: The Board as a raw array of die objects.
    func getRawData() -> [Die] {
        return board
    }

    /// Is the board a 4x4?.
    ///
    /// - Returns: True if the board is 4x4, false otherwise.
    func is4x4Board() -> Bool {
        return board.count == 16
    }

    /// Is the board a 5x5?.
    ///
    /// - Returns: True if the board is a 5x5, false otherwise.
    func is5x5Board() -> Bool {
        return board.count == 25
    }

    /// Is the board a 6x6?.
    ///
    /// - Returns: True if the board is a 6x6, false otherwise.
    func is6x6Board() -> Bool {
        return board.count == 36
    }

    /// Gets you the die at the specified spot.
    ///
    /// - Parameters:
    ///   - rowIndex: The row that you want the die for.
    ///   - columnIndex: The column that you want the index for
    /// - Returns: The die at the specified index (or nil if it's not a valid index in the board).
    func getDieAtRow(_ rowIndex: Int, andColumn columnIndex: Int) -> Die? {
        let multiplier: Int = self.getRowMultiplier()
        if validRow(rowIndex, andColumn: columnIndex) {
            if multiplier != 0 {
                return board[rowIndex * multiplier + columnIndex]
            }
        }
        return nil
    }

    /// Get me the row multiplier, based on the current board size.
    ///
    /// - Returns: Gets you the "multiplier" for figuring out array indices based on the size of the board.
    func getRowMultiplier() -> Int {
        switch board.count {
        case 16:
            return 4

        case 25:
            return 5

        case 36:
            return 6

        default:
            return 0
        }
    }

    /// Did you provide me with a valid row?.
    ///
    /// - Parameters:
    ///   - rowIndex: The row that you want to check.
    ///   - columnIndex: The column that you want to check.
    /// - Returns: True if it's a valid index, false otherwise.
    func validRow(_ rowIndex: Int, andColumn columnIndex: Int) -> Bool {
        let multiplier: Int = self.getRowMultiplier()
        return (rowIndex >= 0) && (columnIndex >= 0) && (rowIndex < multiplier) && (columnIndex < multiplier)
    }

}

// MARK: - Serialization

extension GameBoard {

    func toArray() -> [AnyObject] {
        var array = [AnyObject]()

        for die in board {
            array.append(die.toMap() as AnyObject)
        }

        return array
    }

    static func fromArray(_ array: [AnyObject]) -> GameBoard {
        let board = GameBoard(dice: [])
        for dieMap in array {
            if let map = dieMap as? [String:AnyObject], let die = Die.fromMap(map) {
                board.board.append(die)
            }
        }
        return board
    }

    func toJson() -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: toArray(), options: .prettyPrinted)
            var buffer = [UInt8](repeating: 0, count: data.count)
            (data as NSData).getBytes(&buffer, length:data.count)
            return String(bytes: buffer, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            DLog("Error trying to convert GameBoard to JSON: \(error.localizedDescription)")
            recordFatalError(error)
        }
        return nil
    }

    static func fromJson(_ json: String) -> GameBoard? {

        guard let data = json.data(using: String.Encoding.utf8) else {
            return nil
        }
        return fromData(data)

    }

    static func fromData(_ data: Data) -> GameBoard? {
        do {
            if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject] {
                return fromArray(array)
            }
        } catch let error as NSError {
            DLog("Error reading GameBoard from data: \(error.localizedDescription)")
            recordSystemError(error)
        }
        return nil
    }
}

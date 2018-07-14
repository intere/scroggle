//
//  Die.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

/// Represents a single Die.  This includes:
/// * The sides to the die
/// * What side is currently selected (roll).
class Die: CustomDebugStringConvertible {
    struct Keys {
        static let roll = "roll"
        static let sides = "sides"
    }

    /// The array of sides of the die (array of 6)
    var sides: [String]

    /// The selected index of the die
    var selectedSide: Int = 0

    /// The side of the die that was "rolled"
    var roll: String {
        return sides[selectedSide]
    }

    init(sides: [String]) {
        self.sides = sides
        selectedSide = 6.random
    }

    init(sides: [String], roll: String) {
        self.sides = sides
        selectedSide = sides.index(of: roll) ?? 0
    }

    var debugDescription: String {
        return "\(sides) (selected: \(roll))\n"
    }

}

// MARK: - Public Interface

extension Die {

    func getSelectedSide() -> Int {
        for i in 0..<sides.count {
            if sides[i] == roll {
                return i
            }
        }
        return 0
    }

    class func selectRandomDie(_ sides: [String]) -> String {
        let diceRoll = Int(arc4random_uniform(UInt32(sides.count)))
        return sides[diceRoll]
    }

}

// MARK: - Serialization

extension Die {

    /// Converts this die to a map object.
    ///
    /// - Returns: A map that represents this Die.
    func toMap() -> [String: Any] {
        var result = [String: Any]()
        result[Keys.roll] = roll
        result[Keys.sides] = sides

        return result
    }

    /// Deserializes the provided map into a Die (if the data is in the right format).
    ///
    /// - Parameter map: The Map that contains the roll and sides of the die.
    /// - Returns: A Die if it was properly deserialized, nil otherwise.
    static func fromMap(_ map: [String: Any]) -> Die? {
        if let roll = map[Keys.roll] as? String, let sides = map[Keys.sides] as? [String] {
            return Die(sides: sides, roll: roll)
        }

        return nil
    }
}

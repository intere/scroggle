//
//  Die.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

/**
 Represents a single Die.  This includes the sides to the die, and what side is currently selected (roll).
 */
open class Die {
    struct Keys {
        static let roll = "roll"
        static let sides = "sides"
    }

    var sides: [String]
    var roll: String!

    public init(sides: [String]) {
        self.sides = sides
        self.roll = Die.selectRandomDie(sides)
        patchDie()
    }

    public init(sides: [String], roll: String) {
        self.sides = sides
        self.roll = roll
        patchDie()
    }

}

// MARK: - Public Interface

public extension Die {

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

public extension Die {

    /**
     Converts this die to a map object.
     - Returns: A map that represents this Die.
     */
    func toMap() -> [String:Any] {
        var result = [String:Any]()
        result[Keys.roll] = roll
        result[Keys.sides] = sides

        return result
    }

    /**
     Deserializes the provided map into a Die (if the data is in the right format).
     - Parameter map: The Map that contains the roll and sides of the die.
     - Returns: A Die if it was properly deserialized, nil otherwise.
     */
    static func fromMap(_ map: [String: Any]) -> Die? {
        if let roll = map[Keys.roll] as? String, let sides = map[Keys.sides] as? [String] {
            return Die(sides: sides, roll: roll)
        }

        return nil
    }
}

// MARK: - Helpers

extension Die {

    /// To simplify rendering, we'll take whatever the selected side is, and make it the "0" side
    func patchDie() {
        guard roll != sides[0] else {
            return
        }
        let firstSide = sides[0]

        for i in 1..<sides.count {
            if roll == sides[i] {
                sides[i] = firstSide
                sides[0] = roll
                return
            }
        }
    }

}


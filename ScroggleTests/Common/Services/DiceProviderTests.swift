//
//  DiceProviderTests.swift
//  ScroggleTests
//
//  Created by Eric Internicola on 11/16/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

@testable import Scroggle
import XCTest

class DiceProviderTests: XCTestCase {

    func testRollDiceWithSeed() {
        for seed in Constants.referenceSeeds {
            let roll1 = DiceProvider.instance.rollDice(with: seed)
            let roll2 = DiceProvider.instance.rollDice(with: seed)

            XCTAssertEqual(roll1.debugDescription, roll2.debugDescription)
            XCTAssertEqual(roll1.board.debugDescription, roll2.board.debugDescription)
            DLog(roll1.debugDescription)
        }
    }

    struct Constants {
        static let referenceSeeds = [ "b4G1baEDEjBtxlK4xlULmQ==", "DnniMfm5zfAXo4prNxHGmQ==", "wN/X8QCIBNm8vg70z8UuXw==" ]
    }

}

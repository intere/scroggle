//
//  GameTest.swift
//  ScroggleTests
//
//  Created by Eric Internicola on 7/2/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

@testable import Scroggle
import XCTest

class GameTest: XCTestCase {

    func testDefaultInit() {
        let game = Game()
        XCTAssertEqual(0, game.score)
        XCTAssertEqual(0, game.badGuesses)
        XCTAssertEqual(0, game.duplicateGuesses)
        XCTAssertEqual(0, game.rotations)
        XCTAssertEqual(0, game.words.count)
        XCTAssertEqual(GameTimeType.default, game.timeType)
        XCTAssertFalse(game.hasBoard)
    }
}

//
//  GameContextTest.swift
//  ScroggleTests
//
//  Created by Eric Internicola on 7/2/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

@testable import Scroggle
import XCTest

class GameContextTest: XCTestCase {

    func testDefaultInit() {
        let context = GameContext()
        XCTAssertNotNil(context.game)
        XCTAssertFalse(context.isReplay)
        XCTAssertEqual(GameState.waitingForMatch, context.gameState)
    }

    func testCopyInit() {
        // Setup
        let original = GameContext()
        original.game.board = DiceProvider.instance.rollDice()
        original.gameState = .done
        original.game.words.append("hello")
        original.game.words.append("world")
        original.game.badGuesses = 5
        original.game.score = 27
        original.game.duplicateGuesses = 1
        original.game.rotations = 15
        original.game.timeType = .short

        // Test:
        let copy = GameContext(from: original)
        XCTAssertEqual(0, copy.game.score)
        XCTAssertEqual(0, copy.game.badGuesses)
        XCTAssertEqual(0, copy.game.duplicateGuesses)
        XCTAssertEqual(0, copy.game.rotations)
        XCTAssertEqual(0, copy.game.words.count)
        XCTAssertEqual(original.game.timeType, copy.game.timeType)
        XCTAssertTrue(copy.game.hasBoard)
        XCTAssertEqual(original.game.board.toJson, copy.game.board.toJson)
    }

}

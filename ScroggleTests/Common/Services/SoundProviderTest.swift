//
//  SoundProviderTest.swift
//  ScroggleTests
//
//  Created by Eric Internicola on 7/7/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

@testable import Scroggle
import XCTest

class SoundProviderTest: XCTestCase {

    func testDiceRollSoundExists() {
        XCTAssertNotNil(SoundProvider.Constants.diceRollSound)
    }

    func testSelectionSoundExists() {
        XCTAssertNotNil(SoundProvider.Constants.selectionSound)
    }

    func testCorrectGuessSoundExists() {
        XCTAssertNotNil(SoundProvider.Constants.correctGuessSound)
    }

    func testDupeOrIncorrectSoundExists() {
        XCTAssertNotNil(SoundProvider.Constants.dupeOrIncorrectSound)
    }

    func testBlopSoundExists() {
        XCTAssertNotNil(SoundProvider.Constants.blopSound)
    }

    func testHighScoreSoundExists() {
        XCTAssertNotNil(SoundProvider.Constants.highScoreSound)
    }

    func testTimeSoundExists() {
        XCTAssertNotNil(SoundProvider.Constants.timeSound)
    }

    func testGongSoundExists() {
        XCTAssertNotNil(SoundProvider.Constants.gongSound)
    }

}

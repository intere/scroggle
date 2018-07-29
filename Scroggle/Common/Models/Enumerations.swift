//
//  Enumerations.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

/**
 Game Time Types (if you want the length of time per type, see GameTimer.swift).
 */
enum GameTimeType: Int {
    case undefined = 0
    case veryShort
    case short
    case `default`
    case medium
    case long
    case custom
    case infinite

    static var values: [GameTimeType] {
        return [ veryShort, short, `default`, medium, long ]
    }

    static func fromRawValue(_ rawValue: Int) -> GameTimeType {

        for value in values where value.rawValue == rawValue {
            return value
        }

        return .undefined
    }

    /// How many seconds is this game time type?
    var seconds: Int? {

        switch self {
        case .veryShort:
            return 45

        case .short:
            return 90

        case .default:
            return 180

        case .medium:
            return 300

        case .long:
            return 600

        default:
            return nil
        }
    }
}

enum GameTimerError: Error {
    case invalidGameTimerInitialization
}

enum GameDestination: Int {
    case basicGame = 0
}

// MARK: - Leaderboard Type

struct Leaderboard {
    var key: String
    var name: String
    var index: Int

    fileprivate init(index: Int, key: String, name: String) {
        self.index = index
        self.key = key
        self.name = name
    }

    // MARK: Leaderboard Constants (configured in iTunesConnect)

    static var basicGameVeryShort = Leaderboard(index: 0,
                                                key: "Basic.Game.VeryShort",
                                                name: "Basic Game (\(Leaderboard.gameLength(.veryShort)) seconds)")
    static var basicGameShort = Leaderboard(index: 1,
                                            key: "Basic.Game.Short",
                                            name: "Basic Game (\(Leaderboard.gameLength(.short)) seconds)")
    static var basicGameDefault = Leaderboard(index: 2,
                                              key: "Basic.Game.Default",
                                              name: "Basic Game (\(Leaderboard.gameLength(.default)) seconds)")
    static var basicGameMedium = Leaderboard(index: 3,
                                             key: "Basic.Game.Medium",
                                             name: "Basic Game (\(Leaderboard.gameLength(.medium)) seconds)")
    static var basicGameLong = Leaderboard(index: 4,
                                           key: "Basic.Game.Long",
                                           name: "Basic Game (\(Leaderboard.gameLength(.long)) seconds)")

    static var basicGameLongestWord = Leaderboard(index: 5,
                                                  key: "basicModeLongestWords",
                                                  name: "Basic Game (Longest Words)")

    /// The Leaderboard structs for all of the Basic Game Leaderboards
    static var basicGameLeaderboards = [
        basicGameVeryShort,
        basicGameShort,
        basicGameDefault,
        basicGameMedium,
        basicGameLong,
        basicGameLongestWord
    ]

    /// The Leaderboard keys for all of the Basic Game Leaderboards
    static var basicGameLeaderboardKeys = basicGameLeaderboards.map { (leaderboard: Leaderboard) -> String in
        return leaderboard.key
    }

    static func gameLength(_ timeType: GameTimeType) -> Int {
        guard let seconds = timeType.seconds else {
            return 0
        }

        return seconds
    }
}

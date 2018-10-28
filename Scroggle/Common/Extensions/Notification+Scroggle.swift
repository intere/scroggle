//
//  Notification+Scroggle.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/30/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import Foundation

// swiftlint:disable nesting

extension Notification {

    /// Various Scroggle Notification groupings
    struct Scroggle {

        /// Game Event notifications
        ///
        /// - wordGuessed: a word was guessed
        /// - scoreUpdated: the score was updated
        /// - gameEnded: the game has ended
        /// - beginTimer: the intro animation has completed, start the timer!
        enum GameEvent: String, Notifiable, CustomStringConvertible {
            case wordGuessed  = "word.guessed"
            case scoreUpdated = "score.updated"
            case gameEnded = "ended"
            case beginTimer = "begin.timer"

            static var notificationBase: String {
                return "scroggle.game"
            }

            var description: String {
                return self.rawValue
            }
        }

        /// Game Over actions that a user can take
        ///
        /// - mainMenu: Go back to the main menu
        /// - playAgain: Play another game (same settings)
        /// - replay: replay this same board
        enum GameOverAction: String, Notifiable, CustomStringConvertible {
            case mainMenu = "Main Menu"
            case playAgain = "Play Again"
            case replay = "Replay"
            // TODO: Challenge Friends
            //        case challengeFriends = "Challenge Friends"

            /// Gets you all of the Game Over Actions
            static var all: [GameOverAction] {
                return [.mainMenu, .playAgain, .replay]
            }

            static var notificationBase: String {
                return "scroggle.game.over.action"
            }

            var description: String {
                return self.rawValue
            }
        }

        /// Actions that target the Time Menu
        enum TimeMenuAction: String, Notifiable, CustomStringConvertible {
            case replayCurrentBoard = "replay.current.board"
            case playSameTime = "game.of.same.time"

            static var notificationBase: String {
                return "scroggle.time.menu.action"
            }

            var description: String {
                return self.rawValue
            }
        }

        /// General menu actions
        enum MenuAction: String, Notifiable, CustomStringConvertible {
            case tappedBackButton = "tapped.back"
            case authorizationChanged = "gamecenter.authorization.changed"

            static var notificationBase: String {
                return "scroggle.menu.action"
            }
            var description: String {
                return self.rawValue
            }
        }

        /// Game Stat events (for after a game ends)
        enum GameStatEvent: String, Notifiable, CustomStringConvertible {
            case setPersonalHighScore = "set.personal.high.score"
            case setGlobalHighScore = "set.global.high.score"
            case setPersonalLongestWord = "set.personal.longest.word"
            case setGlobalLongestWord = "set.global.longest.word"

            static var notificationBase: String {
                return "scroggle.game.stats"
            }

            var description: String {
                return rawValue
            }
        }

    }

}

// swiftlint:enable nesting

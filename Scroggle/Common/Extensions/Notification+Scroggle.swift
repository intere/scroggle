//
//  Notification+Scroggle.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/30/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import Foundation

extension Notification {

    /// Various Scroggle Notification groupings
    struct Scroggle {

        /// Game Event notifications
        ///
        /// - wordGuessed: a word was guessed
        /// - scoreUpdated: the score was updated
        /// - gameEnded: the game has ended
        enum GameEvent: String, Notifiable, CustomStringConvertible {
            case wordGuessed  = "word.guessed"
            case scoreUpdated = "score.updated"
            case gameEnded = "ended"

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
    }

}

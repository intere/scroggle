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
        enum GameEvent: String {
            case wordGuessed  = "word.guessed"
            case scoreUpdated = "score.updated"
            case gameEnded = "ended"
        }
    }

}

extension Notification.Scroggle.GameEvent: Notifiable {

    static var notificationBase: String {
        return "scroggle.game"
    }

}

extension Notification.Scroggle.GameEvent: CustomStringConvertible {

    var description: String {
        return self.rawValue
    }
    
}

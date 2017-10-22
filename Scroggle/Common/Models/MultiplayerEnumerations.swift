//
//  MultiplayerEnumerations.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

//
// The State of a Multiplayer Game
//
public enum GameState: Int {
    case kGameStateWaitingForMatch = 0           // Waiting for a match to begin
    case kGameStateWaitingForRandomNumber        // Waiting for a random number (for game start)
    case kGameStateWaitingForStart               // Waiting to start the game
    case kGameStateActive                        // Game is in progress
    case kGameStateDone                          // Game Over
    case kGameStatePaused                        // Non-Multiplayer Games can be Paused
    case kGameStateTerminated                    // Game was likely interrupted and terminated

    func allowsUserInteraction() -> Bool {
        switch self {
        case .kGameStateActive:
            return true
        default:
            return false
        }
    }
}

//
// The Type of message (for network games)
//
public enum MessageType: Int {
    case kMessageTypeRandomNumber = 0
    case kMessageTypeGameBegin
    case kMessageTypeScoreUpdate
    case kMessageTypeGameOver
}

//
// The result of a game
//
public enum GameResult: Int {
    case kGameResultYouWon = 0              // You Won
    case kGameResultYouLost                 // You Lost
    case kGameResultYouTied                 // Tied Game
    case kGameResultOpponentDisconnected    // The Opponent Disconnected
    case kGameResultUnknown                 // Some Unknown error occurred that prevented the game from terminating normally
}

struct Message {
    var messageType: MessageType
}

struct MessageRandomNumber {
    var message: Message
    var randomNumber: Int32
}

struct MessageGameBegin {
    var message: Message
    var timeLimit: Int32
    var gameBoard: [Character]
}

struct MessageScoreUpdate {
    var message: Message
    var playerScore: Int32
    var timeLeft: Int32
}

struct MessageGameOver {
    var message: Message
    var score: Int32
}

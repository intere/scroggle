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
enum GameState: Int {
    case waitingForMatch = 0           // Waiting for a match to begin
    case waitingForRandomNumber        // Waiting for a random number (for game start)
    case waitingForStart               // Waiting to start the game
    case active                        // Game is in progress
    case done                          // Game Over
    case paused                        // Non-Multiplayer Games can be Paused
    case terminated                    // Game was likely interrupted and terminated

    func allowsUserInteraction() -> Bool {
        switch self {
        case .active:
            return true
        default:
            return false
        }
    }
}

//
// The Type of message (for network games)
//
enum MessageType: Int {
    case randomNumber = 0
    case gameBegin
    case scoreUpdate
    case gameOver
}

//
// The result of a game
//
enum GameResult: Int {
    case youWon = 0              // You Won
    case youLost                 // You Lost
    case youTied                 // Tied Game
    case opponentDisconnected    // The Opponent Disconnected
    case unknown                 // Some Unknown error occurred that prevented the game from terminating normally
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

//
//  Score.swift
//  Scroggle
//
//  Created by Eric Internicola on 12/28/15.
//  Copyright © 2015 iColasoft. All rights reserved.
//

import Foundation
import GameKit

public class Score: CustomStringConvertible {
    public var score: Int64
    public var playerId: String?
    public var playerName: String?
    public var rank: Int

    convenience init(score: GKScore, rank: Int) {
        self.init(playerId: score.player.playerID, score: score.value, rank: rank)
    }

    init(playerId: String, score: Int64, rank: Int) {
        self.playerId = playerId
        self.score = score
        self.rank = rank
    }

    public var description: String {
        if let playerName = playerName, let playerId = playerId {
            return "Score \(rank) - \(score) - \(playerName) - \(playerId)"
        }

        return "Score \(rank) - \(score)"
    }
}

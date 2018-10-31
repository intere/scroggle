//
//  GameCenterUtils.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/31/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import GameKit

typealias ScoreLoadingBlock = ([String: Int64]?, [Error]?) -> Void

extension GKLocalPlayer {

    /// Calls out to GameCenter to load the leaderboards for the current player.
    /// Please note: it is possible to receive back both scores and errors (though unlikely).
    ///
    /// - Parameter completion: The block that's executed when the scores come back.
    func loadMyLeaderboards(completion: @escaping ScoreLoadingBlock) {
        guard isAuthenticated else {
            // TODO: Call back with an error
            return completion(nil, nil)
        }
        let leaderboardKeys = Leaderboard.basicGameLeaderboardKeys

        var errors = [Error]()
        var results = [String: Int64]()

        for leaderboardId in leaderboardKeys {
            let leaderboard = GKLeaderboard(players: [self])
            leaderboard.identifier = leaderboardId
            leaderboard.timeScope = .allTime
            leaderboard.loadScores { scores, error in
                defer {
                    if errors.count + results.keys.count == leaderboardKeys.count {
                        if errors.count == 0 {
                            completion(results, nil)
                        } else {
                            completion(results, errors)
                        }
                    }
                }
                if let error = error {
                    errors.append(error)
                }
                guard let scores = scores else {
                    results[leaderboardId] = 0
                    return
                }

                for score in scores where score.player == self {
                    results[score.leaderboardIdentifier] = score.value
                }
            }
        }
    }

}

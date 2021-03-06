//
//  GameCenterProvider.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/14/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import GameKit
import Crashlytics

class GameCenterProvider: NSObject {
    /// Singleton Instance
    static let instance = GameCenterProvider()

    /// Am I Logged into GameCenter?
    var loggedIn: Bool {
        return localPlayer.isAuthenticated
    }

    /// The Local (GameCenter) Player
    var localPlayer: GKLocalPlayer {
        return GKLocalPlayer.local
    }

    /// The GameCenter View Controller (for logging in to Game Center)
    var gameCenterVC: UIViewController?

    /// Local cache of the leaderboards
    var leaderboardCache = [String: Int64]() {
        didSet {
            DLog("Leaderboards have arrived: \(leaderboardCache)")
        }
    }

    var globalLeaderboards = [String: [Score]]()

    // MARK: - Initializers

    override init() {
        super.init()

        Notification.Scroggle.GameEvent.gameEnded.addObserver(self, selector: #selector(gameEnded(_:)))
    }

}

// MARK: - API

extension GameCenterProvider {

    /// Checks to see if you're already logged into GameCenter.  If not
    func performLoginCheck() {
        localPlayer.authenticateHandler = { (gameCenterVC, error) in
            if let error = error {
                DLog("Error Checking Authentication user with GameCenter: \(error.localizedDescription)")
                recordSystemError(error)
            } else if let gameCenterVC = gameCenterVC {
                self.gameCenterVC = gameCenterVC
            } else {
                // Now we should be able to tell whether or not we're logged in.
                self.handleAuthenticationChange()
            }
        }
    }

    /// This method will pull up the native GameCenter Login ViewController if you're not
    /// authenticated and prompt you to login.
    ///
    /// - Parameter presenter: The ViewController that will present the GameCenter Login VC
    func loginToGameCenter(with presenter: UIViewController) {
        guard !loggedIn else {
            return
        }
        guard let gameCenterVC = gameCenterVC else {
            return wireAuthHandler(with: presenter)
        }

        presenter.present(gameCenterVC, animated: true, completion: nil)
    }

    /**
     This method loads the GameCenter Leaderboard View.
     */
    func showLeaderboard(from presenter: UIViewController) {
        let gameCenterVC = GKGameCenterViewController()
        gameCenterVC.gameCenterDelegate = self
        presenter.present(gameCenterVC, animated: true, completion: nil)
    }

    /// Gets you the high score from the cache for the provided time type.
    ///
    /// - Parameter timeType: The Game Time Type to get the high score for.
    /// - Returns: The Score (if available) or nil.
    func getHighScoreForType(_ timeType: GameTimeType) -> Int64? {
        if let key = GameCenterProvider.getKeyForTimeType(timeType: timeType),
            let score = globalLeaderboards[key]?[0].score {
            return score
        }
        return nil
    }

}

// MARK: - Notifications

extension GameCenterProvider {

    @objc
    func gameEnded(_ notification: NSNotification) {
        guard let context = notification.object as? GameContext else {
            return assertionFailure("Invalid object with gameEnded notification")
        }

        saveLeaderboardForGame(context: context)
    }

}

// MARK: - GKGameCenterControllerDelegate Methods

extension GameCenterProvider: GKGameCenterControllerDelegate {

    @objc
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true) { () -> Void in
            DLog("Dismissed GameCenterViewController")
        }
    }
}


// MARK: - Implementation

private extension GameCenterProvider {

    /// This method will update the appropriate leaderboard for the provided game.
    ///
    /// - Parameter context: The Game Context to extract the details from.
    func saveLeaderboardForGame(context: GameContext) {
        if let key = GameCenterProvider.getKeyForTimeType(timeType: context.game.timeType) {
            updateLeaderboard(key, score: context.game.score)
        }

        updateLeaderboard(Leaderboard.basicGameLongestWord.key, score: context.longestWord)
    }

    func wireAuthHandler(with presenter: UIViewController) {
        localPlayer.authenticateHandler = { gameCenterVC, error in
            if let error = error {
                DLog("Error with GameCenter Auth: \(error.localizedDescription)")
                return recordSystemError(error)
            }
            guard let gameCenterVC = gameCenterVC else {
                return Notification.Scroggle.MenuAction.authorizationChanged.notify()
            }
            presenter.present(gameCenterVC, animated: true) {
                Notification.Scroggle.MenuAction.authorizationChanged.notify()
            }
        }
    }

    func handleAuthenticationChange() {
        if self.localPlayer.isAuthenticated {
            DLog("No GameCenterController Loaded")
            Notification.Scroggle.MenuAction.authorizationChanged.notify()

            // Kickoff the loading of the leaderboards (in the background)
            loadLeaderboards()

            // Register the user with Analytics / Crash Logs
            registerUser()

        } else {
            Notification.Scroggle.MenuAction.authorizationChanged.notify()
            DLog("Not Authenticated")
        }
    }

    /// Loads the personal and global leaderboards (on a background thread) and stores them in an in memory cache.
    /// The Global score cache is stored in: `globalLeaderboards`
    /// The User score cache is stored in: `leaderboardCache`
    func loadLeaderboards() {
        guard localPlayer.isAuthenticated else {
            return
        }

        DispatchQueue.global(qos: .background).async {
            GameCenterProvider.loadLeaderboardsForUser()
        }
        DispatchQueue.global(qos: .background).async {
            GameCenterProvider.loadGlobalHighScores()
        }
    }

    func registerUser() {
        DispatchQueue.global(qos: .background).async {
            Crashlytics.sharedInstance().setUserIdentifier(self.localPlayer.playerID)
            Crashlytics.sharedInstance().setUserName(self.getPlayerName())
        }
    }

    func getPlayerName() -> String {
        return localPlayer.alias
    }

    /// This method is responsible for calling out to GameCenter, getting the leaderboards,
    /// then storing them in a map and handing that back to you.
    class func loadLeaderboardsForUser() {
        guard instance.localPlayer.isAuthenticated else {
            return
        }

        let leaderboardKeys = Leaderboard.basicGameLeaderboardKeys

        for leaderboardId in leaderboardKeys {
            let leaderboard = GKLeaderboard(players: [instance.localPlayer])
            leaderboard.identifier = leaderboardId
            leaderboard.timeScope = .allTime
            leaderboard.loadScores { scores, error in
                if let error = error {
                    DLog("Error loading scores for identifier \(leaderboardId): \(error)")
                    return recordSystemError(error)
                }
                guard let scores = scores else {
                    return DLog("Error, no scores came back")
                }

                for score in scores where score.player == instance.localPlayer {
                    instance.leaderboardCache[score.leaderboardIdentifier] = score.value
                }
            }
        }
    }

    /// Updates the provided leaderboard with the provided score.
    ///
    /// - Parameters:
    ///   - leaderboard: The Leaderboard to be updated.
    ///   - score: The Score to udpate the leaderboard with
    func updateLeaderboard(_ leaderboard: String, score: Int) {
        checkScores(for: leaderboard, with: score)
        guard localPlayer.isAuthenticated else {
            return DLog("You're not logged in to GameCenter")
        }

        let scoreReporter = GKScore(leaderboardIdentifier: leaderboard)
        scoreReporter.value = Int64(score)

        GKScore.report([scoreReporter]) { error in
            if let error = error {
                DLog("Error reporting score: \(error.localizedDescription)")
                return recordSystemError(error)
            }

            if let highScore = self.leaderboardCache[leaderboard] {
                self.leaderboardCache[leaderboard] = max(highScore, Int64(score))
            } else {
                self.leaderboardCache[leaderboard] = Int64(score)
            }
        }
    }

    /// Checks the leaderboard / score pair to determine if that beats a personal and/or global high score.
    /// If so, the appropriate `Notification.Scroggle.GameStatEvent` notification(s) are sent out.
    ///
    /// - Parameters:
    ///   - leaderboard: The leaderboard category to check.
    ///   - score: The score to check
    func checkScores(for leaderboard: String, with score: Int) {
        DLog("checkScores(for: '\(leaderboard)', with: \(score))")
        if let personalHighScore = leaderboardCache[leaderboard] {
            if score > personalHighScore {
                if leaderboard == Leaderboard.basicGameLongestWord.key {
                    Notification.Scroggle.GameStatEvent.setPersonalLongestWord.notify()
                } else {
                    Notification.Scroggle.GameStatEvent.setPersonalHighScore.notify()
                }
            }
        } else {
            Notification.Scroggle.GameStatEvent.setPersonalHighScore.notify()
        }

        guard let leaderboardScores = globalLeaderboards[leaderboard],
            let globalHighScore = leaderboardScores.sorted(by: { $0.score > $1.score }).first else {
            // The high scores aren't loaded yet or there are none.
            return
        }

        if score > globalHighScore.score {
            if leaderboard == Leaderboard.basicGameLongestWord.key {
                Notification.Scroggle.GameStatEvent.setGlobalLongestWord.notify()
            } else {
                Notification.Scroggle.GameStatEvent.setGlobalHighScore.notify()
            }
        }
    }

    /// Loads the "global" high scores (meaning the ultimate high scores, not your personal high scores).
    ///
    /// TODO: Refactor this to take back a failable callback, or just get rid of the callback all together.
    /// - Parameter callback: The optional callback to let you know when it's done.
    class func loadGlobalHighScores(_ callback: (() -> Void)? = nil) {
        let leaderboardKeys = Leaderboard.basicGameLeaderboardKeys
        instance.globalLeaderboards.removeAll()

        for leaderboardKey in leaderboardKeys {
            let leaderboard = GKLeaderboard()
            leaderboard.identifier = leaderboardKey
            leaderboard.playerScope = .global
            leaderboard.timeScope = .allTime
            leaderboard.range = NSRange(location: 1, length: 10)

            leaderboard.loadScores { scores, error in
                if let error = error {
                    DLog("There was an error trying to load the scores: \(error.localizedDescription)")
                    return recordSystemError(error)
                }
                guard let scores = scores else {
                    return
                }

                var leaderboard = [Score]()
                var playerIds = [String]()
                var scoresByPlayerId = [String: Score]()

                var rank = 1
                DLog("\(leaderboardKey) has \(scores.count) results")
                for score in scores {
                    let scoreRank = Score(score: score, rank: rank)
                    leaderboard.append(scoreRank)
                    let playerId = score.player.playerID
                    playerIds.append(playerId)
                    scoresByPlayerId[playerId] = scoreRank
                    rank += 1
                }

                GKPlayer.loadPlayers(forIdentifiers: playerIds) { (players, error) in
                    if let error = error {
                        DLog("There was an error trying to load the players: \(error.localizedDescription)")
                    } else if let players = players {
                        for player in players {
                            let playerID = player.playerID
                            if let score = scoresByPlayerId[playerID] {
                                score.playerName = player.displayName
                            }
                        }
                    }

                    DLog("Leaderboard \(leaderboardKey):")
                    DLog("\(leaderboard)")
                }

                instance.globalLeaderboards[leaderboardKey] = leaderboard
            }

            if let callback = callback, instance.globalLeaderboards.count == leaderboardKeys.count {
                callback()
            }
        }
    }

    /**
     Gets you the Key for the provided time type.
     - Parameter timeType: The Game Time Type to get the key for.
     - Returns: The key for that game type.
     */
    static func getKeyForTimeType(timeType: GameTimeType) -> String? {
        switch timeType {
        case .veryShort:
            return Leaderboard.basicGameVeryShort.key
        case .short:
            return Leaderboard.basicGameShort.key
        case .default:
            return Leaderboard.basicGameDefault.key
        case .medium:
            return Leaderboard.basicGameMedium.key
        case .long:
            return Leaderboard.basicGameLong.key
        default:
            // nothing to do
            break
        }

        return nil
    }
}

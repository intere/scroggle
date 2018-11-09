//
//  AnalyticsProvider.swift
//  PisteOffSwift
//
//  Created by Eric Internicola on 11/7/15.
//  Copyright © 2015 Brothers Magoo. All rights reserved.
//

import Crashlytics
import UIKit

class AnalyticsProvider {
    static let instance = AnalyticsProvider()

    enum GameScreen: String {
        case leaderboards = "Leaderboards"
        case home = "Home"
        case chooseTime = "ChooseTime"
        case game = "Game"
        case helpMenu = "HelpMenu"
        case help = "Help"
        case rules = "Rules"
        case composeEmail = "Email"
    }

    enum NewGameTimeAttribute: String {
        case veryShort = "VeryShortGameTime"
        case short = "ShortGameTime"
        case `default` = "DefaultGameTime"
        case medium = "MediumGameTime"
        case long = "LongGameTime"
    }

    enum GameEvent: String {
        case exitedGame = "ExitGameClicked"
        case rotatedBoard = "RotatedBoard"
        case swipedWordGuess = "SwipeWordGuess"
        case clickedWordGuess = "ClickWordGuess"
        case homeFromChooseTime = "HomeFromChooseTime"
        case emailCompleted = "EmailCompleted"
        case completedGame = "CompletedGame"
    }


    // MARK: - Events

    func composeEmailCompleted(completionResult: String, emailType: String) {
        tagEvent(eventName: GameEvent.emailCompleted.rawValue,
                 withAttributes: ["EmailType": emailType, "CompletedWith": completionResult])
    }

    /**
     Tracks when the user clicks on the back button from the "Choose Time" scene.
     */
    func wentHomeFromChooseTime() {
        tagEvent(eventName: GameEvent.homeFromChooseTime.rawValue)
    }

    /**
     Tracks when the user exits the game via the "exit" button.
     */
    func exitedGame() {
        tagEvent(eventName: GameEvent.exitedGame.rawValue)
    }

    /**
     Tracks board rotations.
     - Parameter clockwise: Whether the user rotated the board clockwise or counter clockwise.
     */
    func rotatedBoard(clockwise: Bool) {
        tagEvent(eventName: GameEvent.rotatedBoard.rawValue,
                 withAttributes: ["Direction": clockwise ? "Clockwise" : "Counterclockwise"])
    }

    /**
     Tracks that a user has guessed a word by swiping.
     - Parameter word: The word the user guessed.
     - Parameter valid: Is it a valid word?
     */
    func swipedGuess(word: String, valid: Bool) {
        tagEvent(eventName: GameEvent.swipedWordGuess.rawValue, withAttributes: ["Word": word, "Valid": valid])
    }

    /**
     Tracks that a user has guessed a word by clicking.
     - Parameter word: The word the user guessed.
     - Parameter valid: Is it a valid word?
     */
    func clickedWord(word: String, valid: Bool) {
        tagEvent(eventName: GameEvent.clickedWordGuess.rawValue, withAttributes: ["Word": word, "Valid": valid])
    }

    /// Tracks that a game has started with a specific time type.
    ///
    /// - Parameter timeType: The time type of the game that started.
    func startedGameWithTime(timeType: GameTimeType) {
        guard let eventType = timeType.timeAttribute?.rawValue else {
            return
        }

        tagEvent(eventName: eventType)
    }

    /// Tracks that a game has completed.
    ///
    /// - Parameter timeType: The time type for the game.
    func finishedGame(timeType: GameTimeType) {
        guard let timeType = timeType.timeAttribute?.rawValue else {
            return
        }

        tagEvent(eventName: GameEvent.completedGame.rawValue, withAttributes: ["GameType": timeType])
    }

}

// MARK: - GameTimeType extension

extension GameTimeType {

    var timeAttribute: AnalyticsProvider.NewGameTimeAttribute? {
        switch self {
        case .veryShort:
            return .veryShort

        case .short:
            return .short

        case .default:
            return .default

        case .medium:
            return .medium

        case .long:
            return .long

        default:
            return nil
        }
    }

}

// MARK: - Views

extension AnalyticsProvider {

    func loadedGameView() {
        tagScreen(screenName: GameScreen.game.rawValue)
    }

    func loadedChooseTimeView() {
        tagScreen(screenName: GameScreen.chooseTime.rawValue)
    }

    func loadedHomeView() {
        tagScreen(screenName: GameScreen.home.rawValue)
    }

    func loadedLeaderboards() {
        tagScreen(screenName: GameScreen.leaderboards.rawValue)
    }

    func loadedHelpMenu() {
        tagScreen(screenName: GameScreen.helpMenu.rawValue)
    }

    func loadedHelpView() {
        tagScreen(screenName: GameScreen.help.rawValue)
    }

    func loadedRulesView() {
        tagScreen(screenName: GameScreen.rules.rawValue)
    }

    func loadedComposeEmailView(emailType: String) {
        tagScreen(screenName: "\(GameScreen.composeEmail.rawValue)\(emailType)")
    }
}

// MARK: - Helper Methods

extension AnalyticsProvider {

    func tagEvent(eventName: String) {
        Answers.logCustomEvent(withName: eventName, customAttributes: enrich())
    }

    func tagEvent(eventName: String, withAttributes attributes: [String: Any]) {
        Answers.logCustomEvent(withName: eventName, customAttributes: enrich(attributes))
    }

    func tagScreen(screenName: String) {
        // TODO: Anything?
    }

    /// Enriches the attributes with the configuration (debug, simulator, etc)
    ///
    /// - Parameter attributes: The attributes to be enriched
    /// - Returns: the original attributes along with a couple of other standard
    ///            attributes.
    func enrich(_ attributes: [String: Any]? = nil) -> [String: Any] {
        var enriched = attributes ?? [String: Any]()
        #if DEBUG
        enriched["debug"] = true
        #else
        enriched["debug"] = false
        #endif

        enriched["simulator"] = ConfigurationProvider.instance.isSimulator

        return enriched
    }
}

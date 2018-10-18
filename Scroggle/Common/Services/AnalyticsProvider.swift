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
        tagEvent(eventName: GameEvent.rotatedBoard.rawValue, withAttributes: ["Word": word, "Valid": valid])
    }

    /**
     Tracks that a user has guessed a word by clicking.
     - Parameter word: The word the user guessed.
     - Parameter valid: Is it a valid word?
     */
    func clickedWord(word: String, valid: Bool) {
        tagEvent(eventName: GameEvent.clickedWordGuess.rawValue, withAttributes: ["Word": word, "Valid": valid])
    }

    func startedGameWithTime(timeType: GameTimeType) {
        var eventType: String?
        switch timeType {
        case .veryShort:
            eventType = NewGameTimeAttribute.veryShort.rawValue

        case .short:
            eventType = NewGameTimeAttribute.short.rawValue

        case .default:
            eventType = NewGameTimeAttribute.default.rawValue

        case .medium:
            eventType = NewGameTimeAttribute.medium.rawValue

        case .long:
            eventType = NewGameTimeAttribute.long.rawValue


        default:
            //nothing to do
            break
        }

        if let eventType = eventType {
            tagEvent(eventName: eventType)
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
        if !ConfigurationProvider.instance.isSimulator {
            Answers.logCustomEvent(withName: eventName, customAttributes: nil)
        }
    }

    func tagEvent(eventName: String, withAttributes attributes: [String: Any]) {
        if !ConfigurationProvider.instance.isSimulator {
            Answers.logCustomEvent(withName: eventName, customAttributes: toStringAnyDict(attributes: attributes))
        }
    }

    func tagScreen(screenName: String) {
        if !ConfigurationProvider.instance.isSimulator {
//            Localytics.tagScreen(screenName)
            // TODO: Analytics for screen views
        }
    }

    func toStringAnyDict(attributes: [String: Any]) -> [String: Any] {
        return attributes
    }

//    func toStringAnyDict(attributes: [String: Any]) -> [String: Any ] {
//        var stringAttributes = [String: AnyObject]()
//
//        attributes.forEach { key, value in
//            stringAttributes[key] = value
//        }
//
//        return stringAttributes
//    }
}

//
//  SoundProvider.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation
import AVFoundation
import SceneKit

// TODO: Extract a protocol (SoundService) from SoundProvider

/// Provides the ability to play sounds
class SoundProvider {

    /// The singleton instance
    static let instance = SoundProvider()

    /// A collection of constants that the SoundProvider uses to pre-load and play sounds
    struct Constants {
        static let diceRollSound = SCNAudioSource(named: "DiceRoll.caf")
        static let selectionSound = SCNAudioSource(named: "Velcro.caf")
        static let correctGuessSound = SCNAudioSource(named: "PingPongPop.caf")
        static let dupeOrIncorrectSound = SCNAudioSource(named: "Slap.caf")
        static let blopSound = SoundProvider.loadSound(forResource: "Blop", ofType: "caf")
        static let highScoreSound = SoundProvider.loadSound(forResource: "Metal_Gong", ofType: "caf")
        static let timeSound = SoundProvider.loadSound(forResource: "scroggle-time", ofType: "mp4")
        static let gongSound = SoundProvider.loadSound(forResource: "gong", ofType: "caf")
    }
}

// MARK: - Play Sound Methods

extension SoundProvider {

    /// Plays the high score sound
    func playHighScoreSound() {
        play(Constants.highScoreSound)
    }

    /// Plays the dice roll sound using the provided SCNNode.
    ///
    /// - Parameter node: The node to play the sound from
    func playDiceRollSound(node: SCNNode) {
        play(sound: Constants.diceRollSound, forNode: node)
    }

    /// Plays the dice selection sound using the provide SCNNode.
    ///
    /// - Parameter node: The node to play the sound from
    func playDiceSelectionSound(node: SCNNode) {
        play(sound: Constants.selectionSound, forNode: node)
    }

    /// Plays the "guessed correct" sound using the provided SCNNode.
    ///
    /// - Parameter node: The node to play the sound from
    func playCorrectGuessSound(node: SCNNode) {
        play(sound: Constants.correctGuessSound, forNode: node)
    }

    /// Plays the "incorrect" (or "duplicate") guess sound using the provided SCNNode.
    ///
    /// - Parameter node: The node to play the sound from.
    func playDupeOrIncorrectSound(node: SCNNode) {
        play(sound: Constants.dupeOrIncorrectSound, forNode: node)
    }

    /// Plays the menu selection sound.
    func playMenuSelectionSound() {
        play(Constants.blopSound)
    }

    /// Plays the "time is running out" sound.
    func playTimeSound() {
        play(Constants.timeSound)
    }

    /// Plays the "gong" sound (for game over).
    func playGongSound() {
        play(Constants.gongSound)
    }

}

// MARK: - Helper Methods

extension SoundProvider {

    /// Plays the provided sound on the provided node.
    ///
    /// - Parameters:
    ///   - sound: The sound to play
    ///   - node: The node to play the sound from
    func play(sound: SCNAudioSource?, forNode node: SCNNode) {
        guard let sound = sound else {
            return
        }
        node.runAction(SCNAction.playAudio(sound, waitForCompletion: false))
    }

    /// Plays the provided sound
    ///
    /// - Parameter soundAction: The sound to be played
    func play(_ soundAction: AVAudioPlayer?) {
        guard let soundAction = soundAction else {
            return
        }
        if soundAction.isPlaying {
            soundAction.stop()
        }

        soundAction.play()
    }

    /// Loads the provided sound into an AVAudioPlayer and hands that back to you.
    ///
    /// - Parameters:
    ///   - resource: The resource (filename)
    ///   - type: The extension (file type)
    /// - Returns: An AVAudioPlayer if the sound was found and was able to be opened.
    static func loadSound(forResource resource: String, ofType type: String) -> AVAudioPlayer? {
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else {
            DLog("Failed to find a path for \(resource).\(type)")
            return nil
        }

        let url = URL(fileURLWithPath: path)

        do {
            return try AVAudioPlayer(contentsOf: url)
        } catch {
            DLog("Error trying to load Audio File: \(path)")
            recordSystemError(error)
        }

        return nil
    }

}

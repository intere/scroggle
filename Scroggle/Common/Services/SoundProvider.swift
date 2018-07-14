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

class SoundProvider {
    static let instance = SoundProvider()

    struct Constants {
        static let diceRollSound = SCNAudioSource(named: "DiceRoll.caf")
        static let selectionSound = SCNAudioSource(named: "Velcro.caf")
        static let correctGuessSound = SCNAudioSource(named: "PingPongPop.caf")
        static let dupeOrIncorrectSound = SCNAudioSource(named: "Slap.caf")
        static let blopSound = SoundProvider.loadSound(forResource: "Blop", ofType: "caf")
        static let highScoreSound = SoundProvider.loadSound(forResource: "Metal_Gong", ofType: "caf")
        static let caveInSound = SoundProvider.loadSound(forResource: "Cave_In", ofType: "caf")
        static let timeSound = SoundProvider.loadSound(forResource: "time_sound", ofType: "caf")
        static let gongSound = SoundProvider.loadSound(forResource: "gong", ofType: "caf")
    }
}

// MARK: - Play Sound Methods

extension SoundProvider {

    func playHighScoreSound() {
        play(Constants.highScoreSound)
    }

    func playGameOverSound() {
        play(Constants.caveInSound)
    }

    func playDiceRollSound(node: SCNNode) {
        play(sound: Constants.diceRollSound, forNode: node)
    }
    func playDiceSelectionSound(node: SCNNode) {
        play(sound: Constants.selectionSound, forNode: node)
    }

    func playCorrectGuessSound(node: SCNNode) {
        play(sound: Constants.correctGuessSound, forNode: node)
    }

    func playDupeOrIncorrectSound(node: SCNNode) {
        play(sound: Constants.dupeOrIncorrectSound, forNode: node)
    }

    func playMenuSelectionSound() {
        play(Constants.blopSound)
    }

    func playTimeSound() {
        play(Constants.timeSound)
    }

    func playGongSound() {
        play(Constants.gongSound)
    }

}

// MARK: - Helper Methods

extension SoundProvider {

    func play(sound: SCNAudioSource?, forNode node: SCNNode) {
        guard let sound = sound else {
            return
        }
        node.runAction(SCNAction.playAudio(sound, waitForCompletion: false))
    }

    func play(_ soundAction: AVAudioPlayer?) {
        guard let soundAction = soundAction else {
            return
        }
        if soundAction.isPlaying {
            soundAction.stop()
        }

        soundAction.play()
    }

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


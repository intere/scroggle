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

// TODO: Rename to SoundService

class SoundProvider {
    static let instance = SoundProvider()

    let diceRollSound: SCNAudioSource? = SCNAudioSource(named: "DiceRoll.caf")
    let selectionSound: SCNAudioSource? = SCNAudioSource(named: "Velcro.caf")
    let correctGuessSound: SCNAudioSource? = SCNAudioSource(named: "PingPongPop.caf")
    let dupeOrIncorrectSound: SCNAudioSource? = SCNAudioSource(named: "Slap.caf")
    let blopSound: AVAudioPlayer? = SoundProvider.loadSound(forResource: "Blop", ofType: "caf")
    let highScoreSound: AVAudioPlayer? = SoundProvider.loadSound(forResource: "Metal_Gong", ofType: "caf")
    let caveInSound: AVAudioPlayer? = SoundProvider.loadSound(forResource: "Cave_In", ofType: "caf")
}

// MARK: - Play Sound Methods

extension SoundProvider {

    func playHighScoreSound() {
        play(highScoreSound)
    }

    func playGameOverSound() {
        play(caveInSound)
    }


    func playDiceRollSound(node: SCNNode) {
        play(sound: diceRollSound, forNode: node)
    }
    func playDiceSelectionSound(node: SCNNode) {
        play(sound: selectionSound, forNode: node)
    }

    func playCorrectGuessSound(node: SCNNode) {
        play(sound: correctGuessSound, forNode: node)
    }

    func playDupeOrIncorrectSound(node: SCNNode) {
        play(sound: dupeOrIncorrectSound, forNode: node)
    }

    func playMenuSelectionSound() {
        play(blopSound)
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


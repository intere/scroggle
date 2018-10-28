//
//  GamePlayViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/10/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import SpriteKit
import UIKit

/// The controller for the GamePlayVC (see the storyboard to see how this is
/// all organized together)
class GamePlayViewController: UIViewController {
    /// The label that shows the time left in the game
    @IBOutlet weak var timerLabel: UILabel!

    /// The label that shows the score for the game
    @IBOutlet weak var scoreLabel: UILabel!

    /// Constraint for hiding / showing the game over message.  Note: showing
    /// the game over view will prevent gameplay because it sits on top of the
    /// Game board.
    @IBOutlet weak var gameOverWidthConstraint: NSLayoutConstraint!

    /// The SpriteKit View which is the game play (game board).
    @IBOutlet weak var skView: SKView!

    /// The Game Over View container
    @IBOutlet weak var gameOverView: UIView!

    /// Computed property: The "Game Over" UILabel
    var gameOverLabel: UILabel? {
        return gameOverView.subviews.first?.subviews.filter({ $0 is UILabel }).first as? UILabel
    }

    /// The amount of time left in the game
    var seconds = GameContextProvider.instance.currentGame?.game.timeType.seconds ?? 15
    /// The Timer object that's used to count down the time in the game
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the "Game Over" overlay.
        gameOverWidthConstraint.constant = 0

        seconds = GameContextProvider.instance.currentGame?.game.timeType.seconds ?? 15
        scoreLabel.text = String(0)

        Notification.Scroggle.GameEvent.scoreUpdated.addObserver(self, selector: #selector(scoreUpdated))
        Notification.Scroggle.GameEvent.gameEnded.addObserver(self, selector: #selector(gameOverEvent))
        Notification.Scroggle.GameEvent.beginTimer.addObserver(self, selector: #selector(beginTimer(_:)))
    }
}

// MARK: - Navigation

extension GamePlayViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameOverSegue" {
            // A bit of a hack, but the Game Over Label isn't here yet, so waiting until the next
            // time the UI Thread is freed up seems to work just fine.
            DispatchQueue.main.async { [weak self] in
                self?.gameOverLabel?.font = UIFont.Scroggle.defaultFont(ofSize: 70)
            }
        }
    }

}

// MARK: - Notifications

extension GamePlayViewController {

    @objc
    func beginTimer(_ notification: NSNotification) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,
                                     selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc
    /// Responds to the game ending early (user clicks the exit game button)
    func gameOverEvent() {
        endGame()
    }

    @objc
    /// Responds to the scoreUpdated event (by updating the game score)
    func scoreUpdated() {
        guard let score = GameContextProvider.instance.currentGame?.game.score else {
            return
        }
        scoreLabel.text = String(score)
    }

}


// MARK: - Implementation

private extension GamePlayViewController {


    @objc
    /// Responds to the time updated event
    func updateTimer() {
        timerLabel.text = seconds.timeString

        guard seconds > 0 else {
            endGame()
            SoundProvider.instance.playGongSound()
            return Notification.Scroggle.GameEvent.gameEnded.notify()
        }

        if seconds <= 10 {
            flashTimerColor()
            SoundProvider.instance.playTimeSound()
        }
        seconds -= 1
    }

    /// Flashes the timer from red to green to alert the user that time is almost up.
    func flashTimerColor() {
        timerLabel.textColor = .red

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.timerLabel.textColor = .green
        }
    }

    /// Shows the "Game Over" overlay (animates it in).
    func showGameOver() {
        UIView.animate(withDuration: 0.5) {
            self.gameOverWidthConstraint.constant = self.skView.frame.width
        }
    }

    /// Ends the game, and handles (or delgates) all associated logic.
    func endGame() {
        GameContextProvider.instance.currentGame?.gameState = .done
        timerLabel.textColor = .red
        timer?.invalidate()
        showGameOver()
    }
}

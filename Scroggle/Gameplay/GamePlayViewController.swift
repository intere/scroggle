//
//  GamePlayViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/10/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import SpriteKit
import UIKit

class GamePlayViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameOverWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var skView: SKView!

    var seconds = 15
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the "Game Over" overlay.
        gameOverWidthConstraint.constant = 0

        seconds = GameContextProvider.instance.currentGame?.game.timer.timeType.seconds ?? 15
        scoreLabel.text = String(0)

        Notification.Scroggle.GameEvent.scoreUpdated.addObserver(self, selector: #selector(scoreUpdated))
        Notification.Scroggle.GameEvent.gameEnded.addObserver(self, selector: #selector(gameOverEvent))


        // TODO: Delay this after an "introduction animation":
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,
                                     selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
}

// MARK: - Implementation

private extension GamePlayViewController {

    @objc
    func gameOverEvent() {
        endGame()
    }

    @objc
    func scoreUpdated() {
        guard let score = GameContextProvider.instance.currentGame?.game.score else {
            return
        }
        scoreLabel.text = String(score)
    }

    @objc
    func updateTimer() {
        timerLabel.text = seconds.timeString

        guard seconds > 0 else {
            endGame()
            return Notification.Scroggle.GameEvent.gameEnded.notify()
        }

        if seconds <= 10 {
            flashTimerColor()
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

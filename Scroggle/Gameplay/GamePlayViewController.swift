//
//  GamePlayViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/10/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import UIKit

class GamePlayViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    var seconds = 15
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        seconds = GameContextProvider.instance.currentGame?.game.timer.timeType.seconds ?? 15

        timer = Timer.scheduledTimer(timeInterval: 1, target: self,
                                     selector: #selector(updateTimer), userInfo: nil, repeats: true)
        scoreLabel.text = String(0)

        Notification.Scroggle.GameEvent.scoreUpdated.addObserver(self, selector: #selector(scoreUpdated))
    }
}

// MARK: - Implementation

private extension GamePlayViewController {

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
            timerLabel.textColor = .red
            timer?.invalidate()
            Notification.Scroggle.GameEvent.gameEnded.notify()
            return
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
}

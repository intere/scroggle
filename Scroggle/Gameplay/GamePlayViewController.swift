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

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer),
                                     userInfo: nil, repeats: true)
    }
}

// MARK: - Implementation

private extension GamePlayViewController {

    @objc
    func updateTimer() {
        timerLabel.text = seconds.timeString

        guard seconds > 0 else {
            timerLabel.textColor = .red
            timer?.invalidate()
            return
        }

        if seconds <= 10 {
            flashTimerColor()
        }
        seconds -= 1
    }

    /// Flashes the timer from red to green to alert the user that time is almost up.
    func flashTimerColor() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.timerLabel.textColor = .red
        }, completion: { [weak self] _ in
            self?.timerLabel.textColor = .green
        })
    }
}

//
//  HUDViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/9/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import Cartography
import UIKit

class HUDViewController: UIViewController {

    let scoreTitleLabel = UILabel()
    let timeTitleLabel = UILabel()
    let scoreLabel = UILabel()
    let timeLabel = UILabel()
    let exitButton = UIButton(type: .custom)

    var wordListVC: WordListViewController!

    /// The amount of time left in the game
    var seconds = GameContextProvider.instance.currentGame?.game.timeType.seconds ?? 15

    /// The Timer object that's used to count down the time in the game
    var timer: Timer?

    var wordTable: UIView {
        return wordListVC.view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addWordListVC()
        buildVC()

        Notification.Scroggle.GameEvent.scoreUpdated.addObserver(self, selector: #selector(scoreUpdated(_:)))
        Notification.Scroggle.GameEvent.gameEnded.addObserver(self, selector: #selector(gameEnded))
        Notification.Scroggle.GameEvent.beginTimer.addObserver(self, selector: #selector(beginTimer(_:)))

    }

    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:
                self.layoutPortrait()

            default:
                self.layoutLandscape()
            }
        }, completion: { _ in
            DLog("rotation completed")
        })
        super.willTransition(to: newCollection, with: coordinator)
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .portraitUpsideDown:
            layoutPortrait()

        default:
            layoutLandscape()
        }
    }
}

// MARK: - Events

extension HUDViewController {

    @objc
    func beginTimer(_ notification: NSNotification) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,
                                     selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc
    /// Responds to the time updated event
    func updateTimer() {
        updateHud()

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

    @objc
    func scoreUpdated(_ notification: NSNotification) {
        updateHud()
    }

    @objc
    func gameEnded() {
        DLog("Game Ended")
        timer?.invalidate()
    }

}

// MARK: - Implementation

extension HUDViewController {

    /// Computes an optimal font size for the current screen orientation and size
    private var hudTextSize: CGFloat {
        var fontSize: CGFloat = 20
        if isPad {
            if isLandscape {
                // we're using a bit less than half the screen width
                fontSize = UIScreen.main.bounds.width / 30
                DLog("Using font size: \(fontSize)")
            } else {
                // we're using just less than the screen width
                fontSize = UIScreen.main.bounds.width / 25
                DLog("Using font size: \(fontSize)")
            }
        } else if isXdevice {
            if isLandscape {
                fontSize = UIScreen.main.bounds.width / 18
                DLog("Using font size: \(fontSize)")
            } else {
                fontSize = UIScreen.main.bounds.width / 8
                DLog("Using font size: \(fontSize)")
            }
        } else {
            if isLandscape {
                // we're using a bit less than half the screen width
                fontSize = UIScreen.main.bounds.width / 15
                DLog("Using font size: \(fontSize)")
            } else {
                // we're using just less than the screen width
                fontSize = UIScreen.main.bounds.width / 10
                DLog("Using font size: \(fontSize)")
            }
        }
        return fontSize
    }

    /// Flashes the timer from red to green to alert the user that time is almost up.
    func flashTimerColor() {
        timeLabel.textColor = .red

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.timeLabel.textColor = .green
        }
    }

    /// Ends the game, and handles (or delgates) all associated logic.
    func endGame() {
        GameContextProvider.instance.currentGame?.gameState = .done
        timeLabel.textColor = .red
        timer?.invalidate()
    }

    /// Updates the current score / time in the HUD
    func updateHud() {
        let score = GameContextProvider.instance.currentGame?.game.score ?? 0
        scoreLabel.text = "\(score)"
        timeLabel.text = "\(seconds.timeString)"
    }

    /// Creates and adds the child `WordListViewController`
    func addWordListVC() {
        wordListVC = WordListViewController.loadFromStoryboard()
        addChild(wordListVC)
        wordListVC.didMove(toParent: self)
    }

    /// Builds and lays out the VC
    func buildVC() {
        scoreTitleLabel.font = UIFont(name: "Digital-7 Mono", size: hudTextSize)
        scoreTitleLabel.textColor = .orange
        scoreTitleLabel.text = "SCORE:"
        scoreTitleLabel.textAlignment = .right

        timeTitleLabel.font = scoreTitleLabel.font
        timeTitleLabel.textColor = scoreTitleLabel.textColor
        timeTitleLabel.text = "TIME:"
        timeTitleLabel.textAlignment = .right

        scoreLabel.font = scoreTitleLabel.font
        scoreLabel.textColor = .green

        timeLabel.font = scoreTitleLabel.font
        timeLabel.textColor = .yellow

        exitButton.setImage(#imageLiteral(resourceName: "close_normal"), for: .normal)
        exitButton.setImage(#imageLiteral(resourceName: "close_selected"), for: .selected)
        exitButton.addTarget(self, action: #selector(exitAndGoToMainMenu), for: .touchUpInside)


        if isPortrait {
            layoutPortrait()
        } else {
            layoutLandscape()
        }

        updateHud()
    }

    @objc
    func exitAndGoToMainMenu() {
        // TODO: Add Analytics for exited game
        Notification.Scroggle.GameOverAction.mainMenu.notify()
    }

    /// Removes all of the subviews from the current view and re-adds them for us.
    func removeAndReAddViews() {
        view.subviews.forEach { $0.removeFromSuperview() }
        [wordTable, timeTitleLabel, scoreTitleLabel, timeLabel, scoreLabel, exitButton].forEach {
            view.addSubview($0)
        }
    }

    func layoutPortrait() {
        guard isPad else {
            return layoutLandscape()
        }

        removeAndReAddViews()

        constrain(view, timeTitleLabel, scoreTitleLabel, timeLabel, scoreLabel, wordTable, exitButton) {
            (view, timeTitleLabel, scoreTitleLabel, timeLabel, scoreLabel, wordTable, exitButton) in
            // swiftlint:disable:previous closure_parameter_position

            //   ____________________________________________
            //  |  Word | x   timeTitleLabel | timeLabel    |
            //  | Table |    scoreTitleLabel | scoreLabel   |
            //  ---------------------------------------------
            //
            wordTable.top == view.top + 8
            wordTable.left == view.left + 8
            wordTable.bottom == view.bottom - 8
            wordTable.width == view.width * 0.6

            exitButton.top == view.top + 8
            exitButton.left == wordTable.right + 8
            exitButton.width == 40
            exitButton.height == 40

            timeTitleLabel.left == exitButton.right + 8
            timeTitleLabel.top == view.top + 8

            timeLabel.right == view.right - 8
            timeLabel.top == timeTitleLabel.top
            timeLabel.left == timeTitleLabel.right + 8

            scoreTitleLabel.left == timeTitleLabel.left
            scoreTitleLabel.top == timeTitleLabel.bottom + 8
            scoreTitleLabel.right == timeTitleLabel.right

            scoreLabel.right == view.right - 8
            scoreLabel.top == scoreTitleLabel.top
            scoreLabel.left == timeLabel.left
        }
    }

    func layoutLandscape() {
        removeAndReAddViews()

        constrain(view, timeTitleLabel, scoreTitleLabel, timeLabel, scoreLabel, wordTable, exitButton) {
            (view, timeTitleLabel, scoreTitleLabel, timeLabel, scoreLabel, wordTable, exitButton) in
            // swiftlint:disable:previous closure_parameter_position

            //  _____________________________________
            //  | x   timeTitleLabel | timeLabel    |
            //  |    scoreTitleLabel | scoreLabel   |
            //  -------------------------------------
            //  |            Word List              |
            //  ------------------------------------
            exitButton.top == view.top + 8
            exitButton.left == view.left + 8
            exitButton.width == 40
            exitButton.height == 40

            timeTitleLabel.top == exitButton.top
            timeTitleLabel.left == exitButton.right + 8

            timeLabel.top == timeTitleLabel.top
            timeLabel.left == timeTitleLabel.right + 8
            timeLabel.right == view.right - 8

            scoreTitleLabel.top == timeTitleLabel.bottom + 8
            scoreTitleLabel.left == timeTitleLabel.left
            scoreTitleLabel.right == timeTitleLabel.right

            scoreLabel.top == scoreTitleLabel.top
            scoreLabel.left == timeLabel.left
            scoreLabel.right == timeLabel.right

            wordTable.left == timeTitleLabel.left
            wordTable.right == timeLabel.right
            wordTable.top == scoreLabel.bottom + 8
            wordTable.bottom == view.bottom - 8
        }
    }
}

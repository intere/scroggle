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

    var wordListVC: WordListViewController!

    var wordTable: UIView {
        return wordListVC.view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addWordListVC()
        buildVC()
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
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

// MARK: - Implementation

extension HUDViewController {

    /// Creates and adds the child `WordListViewController`
    func addWordListVC() {
        wordListVC = WordListViewController.loadFromStoryboard()
        addChild(wordListVC)
        wordListVC.didMove(toParent: self)
    }

    /// Builds and lays out the VC
    func buildVC() {
        scoreTitleLabel.font = UIFont(name: "Digital-7 Mono", size: 42)
        scoreTitleLabel.textColor = .orange
        scoreTitleLabel.text = "SCORE:"
        scoreTitleLabel.textAlignment = .right

        timeTitleLabel.font = scoreTitleLabel.font
        timeTitleLabel.textColor = scoreTitleLabel.textColor
        timeTitleLabel.text = "TIME:"
        timeTitleLabel.textAlignment = .right

        scoreLabel.font = scoreTitleLabel.font
        scoreLabel.textColor = .green
        scoreLabel.text = "0"

        timeLabel.font = scoreTitleLabel.font
        timeLabel.textColor = .yellow
        if let time = GameContextProvider.instance.currentGame?.game.timeType.seconds {
            timeLabel.text = "\(time.timeString)"
        } else {
            timeLabel.text = "99:99"
        }

        if isPortrait {
            layoutPortrait()
        } else {
            layoutLandscape()
        }
    }

    func removeAndReAddViews() {
        view.subviews.forEach { $0.removeFromSuperview() }
        [wordTable, timeTitleLabel, scoreTitleLabel, timeLabel, scoreLabel].forEach {
            view.addSubview($0)
        }
    }

    func layoutPortrait() {
        guard isPad else {
            return layoutLandscape()
        }

        removeAndReAddViews()

        constrain(view, timeTitleLabel, scoreTitleLabel, timeLabel, scoreLabel, wordTable) {
            view, timeTitleLabel, scoreTitleLabel, timeLabel, scoreLabel, wordTable in

            //   ____________________________________________
            //  |  Word |     timeTitleLabel | timeLabel    |
            //  | Table |    scoreTitleLabel | scoreLabel   |
            //  ---------------------------------------------
            //
            wordTable.top == view.top + 8
            wordTable.left == view.left + 8
            wordTable.bottom == view.bottom - 8
            wordTable.width == view.width * 0.6

            timeTitleLabel.left == wordTable.right + 8
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

        constrain(view, timeTitleLabel, scoreTitleLabel, timeLabel, scoreLabel, wordTable) {
            view, timeTitleLabel, scoreTitleLabel, timeLabel, scoreLabel, wordTable in

            //  _____________________________________
            //  |     timeTitleLabel | timeLabel    |
            //  |    scoreTitleLabel | scoreLabel   |
            //  -------------------------------------
            //  |            Word List              |
            //  ------------------------------------
            timeTitleLabel.top == view.top + 8
            timeTitleLabel.left == view.left + 8

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

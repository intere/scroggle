//
//  WordListViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/10/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import UIKit

/// A controller for the word list (during game play).  When a user guesses a
/// word, it shows up in the TableView that this controls.
class WordListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Notification.Scroggle.GameEvent.scoreUpdated.addObserver(self, selector: #selector(scoreUpdated(_:)))
        Notification.Scroggle.GameEvent.gameEnded.addObserver(tableView, selector: #selector(tableView.reloadData))
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return isGameOver ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return isGameOver ? Notification.Scroggle.GameOverAction.all.count : wordList.count

        default:
            return wordList.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard isGameOver else {
                return dequeWordCell(for: tableView, indexPath: indexPath)
            }
            return dequeueActionCell(for: tableView, indexPath: indexPath)

        default:
            return dequeWordCell(for: tableView, indexPath: indexPath)
        }
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        Notification.Scroggle.GameEvent.scoreUpdated.notify()
    }
}

// MARK: - API

extension WordListViewController {

    class func loadFromStoryboard() -> WordListViewController {
        return UIStoryboard(name: "WordList", bundle: nil)
            .instantiateViewController(withIdentifier: "WordListViewController") as! WordListViewController
        // swiftlint:disable:previous force_cast
    }

}

// MARK: - FontSizeDelegate

extension WordListViewController: FontSizeDelegate {

    var fontSize: CGFloat {
        return tableView.frame.width / 8
    }
    
}

// MARK: - Notification

extension WordListViewController {

    @objc
    func scoreUpdated(_ notification: NSNotification) {
        tableView.reloadData()
        tableView.setNeedsLayout()
        tableView.setNeedsDisplay()
    }

}

// MARK: - Implementation

extension WordListViewController {

    /// Is the game over?
    var isGameOver: Bool {
        guard let gameState = GameContextProvider.instance.currentGame?.gameState else {
            return false
        }
        switch gameState {
        case .done, .terminated:
            return true

        default:
            return false
        }
    }

    /// The list of words (order is most recently guess, first)
    var wordList: [String] {
        return GameContextProvider.instance.currentGame?.game.words.reversed() ?? []
    }

    /// Dequeues an `ActionCell` for the provided tableView and indexPath.
    ///
    /// - Parameters:
    ///   - tableView: The table to dequeue the cell from
    ///   - indexPath: The indexPath to get the row from.
    /// - Returns: The `ActionCell` for the provided TableView and IndexPath
    func dequeueActionCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell", for: indexPath)

        guard let actionCell = cell as? ActionCell else {
            return cell
        }

        actionCell.action = Notification.Scroggle.GameOverAction.all[indexPath.row]

        return actionCell
    }

    /// Dequeues a `WordCell` for you from the provided tableView and indexPath.
    ///
    /// - Parameters:
    ///   - tableView: The table to dequeue the cell from
    ///   - indexPath: The indexPath to get the row from.
    /// - Returns: The `WordCell` for the provided tableView and indexPath.
    func dequeWordCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)

        guard let wordCell = cell as? WordCell, indexPath.row < wordList.count else {
            return cell
        }

        wordCell.fontSizeDelegate = self
        wordCell.word = wordList[indexPath.row]

        return wordCell
    }

}

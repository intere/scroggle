//
//  WordCell.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/30/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import UIKit

/// This is a cell that's used to show a word that was successfully guessed on
/// the scroggle board and the corresponding score for that word
class WordCell: UITableViewCell {

    /// The label that shows the score
    @IBOutlet weak var scoreLabel: UILabel!
    /// The label that shows the word
    @IBOutlet weak var wordLabel: UILabel!

    /// The word that was guessed
    var word: String = "" {
        didSet {
            wordLabel.text = word.uppercased()
            updateScore()
        }
    }

}

// MARK: - Implementation

extension WordCell {

    /// Updates the cell to show the score for the word.
    private func updateScore() {
        let score = ScoreProvider.instance.scoreWord(word)
        if score < 10 {
            scoreLabel.text = "0\(score)"
        } else {
            scoreLabel.text = String(score)
        }
    }
}

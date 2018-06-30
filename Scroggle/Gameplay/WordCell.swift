//
//  WordCell.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/30/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import UIKit

class WordCell: UITableViewCell {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!

    var word: String = "" {
        didSet {
            wordLabel.text = word.uppercased()
            updateScore()
        }
    }

}

// MARK: - Implementation

extension WordCell {

    private func updateScore() {
        let score = ScoreProvider.instance.scoreWord(word)
        if score < 10 {
            scoreLabel.text = "0\(score)"
        } else {
            scoreLabel.text = String(score)
        }
    }
}

//
//  WordCell.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/30/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import UIKit

protocol FontSizeDelegate: class {
    var fontSize: CGFloat { get }
}

/// This is a cell that's used to show a word that was successfully guessed on
/// the scroggle board and the corresponding score for that word
class WordCell: UITableViewCell {

    /// The label that shows the score
    @IBOutlet weak var scoreLabel: UILabel!
    /// The label that shows the word
    @IBOutlet weak var wordLabel: UILabel!

    weak var fontSizeDelegate: FontSizeDelegate?

    /// The word that was guessed
    var word: String = "" {
        didSet {
            wordLabel.text = word.uppercased()
            updateScore()
            updateSize()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        updateSize()
    }

}

// MARK: - Implementation

extension WordCell {

//    private var fontSize: CGFloat {
//        let fontSize = (superview?.frame.width ?? frame.width) / 8
//        DLog("Word Font Size for \(word): \(fontSize), frame size: \(frame.size)")
//        return fontSize
//    }

    func updateSize() {
        guard let fontSize = fontSizeDelegate?.fontSize else {
            return assertionFailure("it's no good")
        }
        scoreLabel.font = UIFont(name: scoreLabel.font.fontName, size: fontSize)
        wordLabel.font = UIFont(name: wordLabel.font.fontName, size: fontSize)
        setNeedsLayout()
        setNeedsDisplay()
    }

    /// Updates the cell to show the score for the word.
    private func updateScore() {
        guard !word.isEmpty else {
            scoreLabel.text = nil
            wordLabel.text = nil
            return
        }
        let score = ScoreProvider.instance.scoreWord(word)
        if score < 10 {
            scoreLabel.text = "0\(score)"
        } else {
            scoreLabel.text = String(score)
        }
    }
}

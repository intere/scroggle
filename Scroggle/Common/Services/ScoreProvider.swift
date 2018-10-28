//
//  ScoreProvider.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

// TODO: extract a protocol (ScoreService) from ScoreProvider

/// This class is responsible for the handling of score calculation data.
class ScoreProvider {
    /// The Instance of this provider
    static let instance = ScoreProvider()

    var letterScores = [String: Int]()
    var lengthFactors = [Int: Int]()

    init() {
        loadScoreData()
    }

}

// MARK: - API

extension ScoreProvider {

    /// Gives you the score for the provided word.
    ///
    /// - Parameter word: The word to be scored.
    /// - Returns: The score for the provided word.
    func scoreWord(_ word: String) -> Int {

        let lcaseWord = word.lowercased()
        let length = lcaseWord.utf8.count

        guard length > 1 else {
            return 0
        }

        var score: Int = 0

        for var index in 0..<length {
            let start = lcaseWord.index(lcaseWord.startIndex, offsetBy: index)
            let end = lcaseWord.index(start, offsetBy: 1)
            let currentChar = String(lcaseWord[start..<end])
            if currentChar == "q" {
                score += getScoreForLetter("qu")
                index += 1
            } else {
                score += getScoreForLetter(currentChar)
            }
        }

        guard let factor = lengthFactors[length] else {
            DLog("ERROR: Couldn't find the factor for length")
            return score * length
        }

        return score * factor
    }

    /// Gets you the score for a specific letter sequence (typically a single character).
    ///
    /// - Parameter letters: The letters to be scored.
    /// - Returns: The Score for that letter.
    func getScoreForLetter(_ letters: String) -> Int {
        guard let score = letterScores[letters] else {
            DLog("Could not score letters: \(letters)")
            return 0
        }

        return score
    }

}

// MARK: - Helper Methods

private extension ScoreProvider {

    /// Loads the Score Data from the scores.json file and populates the letterScores and lengthFactors.
    func loadScoreData() {
        guard let path = Bundle.main.path(forResource: "scores", ofType: "json")  else {
            return DLog("Error: Couldn't find the scores.json file")
        }
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return DLog("Couldn't load the scores.json file data")
        }

        do {
            guard let jsonModel = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                as? [String: Any] else {
                return DLog("The scores.json file was in an unknown format")
            }

            // Populate the Letter Scores
            if let letters = jsonModel["letters"] as? [String: Int] {
                for (letter, score) in letters {
                    letterScores[letter] = score
                }
            } else {
                DLog("Couldn't load the Letter Scores from the scores.json file")
            }

            // Now Populate the Length Score Factors
            guard let lengths = jsonModel["lengths"] as? [String: Int] else {
                return DLog("Couldn't load the Length Factors from the scores.json file")
            }

            for (length, factor) in lengths {
                guard let length = Int(length) else {
                    continue
                }
                lengthFactors[length] = factor
            }
        } catch {
            DLog("There was an error trying do deserialize the scores.json: \(error.localizedDescription)")
            recordSystemError(error)
        }
    }
}

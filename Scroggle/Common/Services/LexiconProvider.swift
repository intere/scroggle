//
//  LexiconProvider.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/24/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import UIKit

/// Provides the ability to check the validity of a word, using a UITextChecker.
class LexiconProvider {

    /// Shared instance of the LexiconProvider
    static let instance = LexiconProvider()

    /// We use a UITextChecker to validate words.
    let checker = UITextChecker()

    /// Is the provided word a valid word?.
    ///
    /// - Parameter word: The word to check against the dictionary.
    /// - Returns: True if the word is in the dictionary, false otherwise.
    func isValidWord(_ word: String) -> Bool {
        let lcaseWord = word.lowercased()
        let range = NSRange(location: 0, length: lcaseWord.utf16.count)

        let misspelledRange = checker.rangeOfMisspelledWord(in: lcaseWord, range: range,
                                                            startingAt: 0, wrap: false, language: "en")

        // If the misspelledRange is "Not Found", then the word is valid (there is no misspelled location in the word)
        return misspelledRange.location == NSNotFound
    }

}

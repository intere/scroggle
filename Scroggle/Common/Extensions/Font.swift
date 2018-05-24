//
//  Font.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

extension UIFont {

    /// Scroggle font structure, used as a namespace
    struct Scroggle {
        private static let defaultFontName = "Chalkduster"

        /// Gives you the default font of the provided size
        ///
        /// - Parameter size: The size of the font you would like
        static func defaultFont(ofSize size: CGFloat) -> UIFont? {
            return UIFont(name: defaultFontName, size: size)
        }
    }

}

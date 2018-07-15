//
//  ButtonHandler.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/8/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

/// This is the metadata behind a menu item
class ButtonCellInfo {

    /// The button title (action)
    let title: String

    /// The callback block that is executed when the user interacts with the button
    let action: () -> Void

    /// Initializes this Menu Item using the provided title and action (callback).
    ///
    /// - Parameters:
    ///   - title: The title of this menu item.
    ///   - action: The callback block to be executed when the user interacts with it.
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
}


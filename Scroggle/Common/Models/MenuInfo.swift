//
//  MenuInfo.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/8/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

/// Metadata about a Menu Item for the main menus
class MenuInfo {
    /// The menu title
    let title: String

    /// An array of menu items (buttons) for the menu.  These are user actions.
    let buttons: [ButtonCellInfo]

    /// Initializes the MenuInfo object using the provided title and buttons.
    ///
    /// - Parameters:
    ///   - title: The menu title
    ///   - buttons: The buttons in the menu (user actions)
    init(title: String, buttons: [ButtonCellInfo]) {
        self.title = title
        self.buttons = buttons
    }
}

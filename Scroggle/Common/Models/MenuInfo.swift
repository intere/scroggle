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
    let buttons: [MenuCellInfo]

    /// Should the "close" button be visible in the menu?
    let showCloseButton: Bool

    /// Initializes the MenuInfo object using the provided title and buttons.
    ///
    /// - Parameters:
    ///   - title: The menu title
    ///   - showCloseButton: Should the close button be visible?
    ///   - buttons: The menu cells in the menu (user actions)
    init(title: String, showCloseButton: Bool = true, buttons: [MenuCellInfo]) {
        self.title = title
        self.showCloseButton = showCloseButton
        self.buttons = buttons
    }
}

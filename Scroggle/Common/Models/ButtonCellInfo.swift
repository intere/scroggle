//
//  ButtonHandler.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/8/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

typealias VoidAction = () -> Void
typealias ToggleAction = (Bool) -> Void

protocol MenuCellInfo {
    var title: String { get }
}

/// This is the metadata behind a "Button" menu item cell.
class ButtonCellInfo: MenuCellInfo {

    /// The button title (action)
    let title: String

    /// The callback block that is executed when the user interacts with the button
    let action: VoidAction

    /// Initializes this Menu Item using the provided title and action (callback).
    ///
    /// - Parameters:
    ///   - title: The title of this menu item.
    ///   - action: The callback block to be executed when the user interacts with it.
    init(title: String, action: @escaping VoidAction) {
        self.title = title
        self.action = action
    }
}

/// This is the metadata behind a "Toggle Button" menu item cell.
class ToggleCellInfo: MenuCellInfo {

    /// The toggle cell title
    let title: String

    /// The callback block that is executed when the user interacts with the toggle
    let action: ToggleAction

    /// Is this toggle selected or not?
    var selected: Bool

    /// Initializes this Menu Item using the provided title and action (callback).
    ///
    /// - Parameters:
    ///   - title: The title of this menu item.
    ///   - selected: Should the toggle button be selected or not?
    ///   - action: The callback block to be executed when the user interacts with it.
    init(title: String, selected: Bool = false, action: @escaping ToggleAction) {
        self.title = title
        self.selected = selected
        self.action = action
    }

}

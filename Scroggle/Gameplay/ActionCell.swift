//
//  ActionCell.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/30/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import UIKit

/// This is a reusable cell that is configured via a `GameOverAction`.
/// The `GameOverAction` is used to configure the title of the button in this
/// cell and to send out a notification when the user interacts with the button.
class ActionCell: UITableViewCell {

    /// The button that the user can click on
    @IBOutlet weak var button: UIButton!

    /// The action that's used to configure this cell
    var action: Notification.Scroggle.GameOverAction = .mainMenu {
        didSet {
            button.setTitle(action.rawValue, for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.borderColor = UIColor.green.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 15
    }

    @IBAction
    /// Handles the user interaction with the button.
    ///
    /// - Parameter sender: The source of the event (probably the `button`).
    func pressedButton(_ sender: Any) {
//        DLog("Clicked: \(action.rawValue)")
        action.notify()
    }
}

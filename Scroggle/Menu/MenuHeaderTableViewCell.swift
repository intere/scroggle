//
//  MenuHeaderTableViewCell.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/9/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

/// A Cell that shows you the title in a menu.  See
/// Menu.storyboard for more details.
class MenuHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var closeButton: UIButton!

    var title: String? {
        get {
            return label?.text
        }
        set {
            label?.text = newValue
        }
    }

    var showCloseButton = true {
        didSet {
            closeButton.isHidden = !showCloseButton
        }
    }

    @IBAction
    func tappedClose(_ source: Any) {
        Notification.Scroggle.MenuAction.tappedBackButton.notify()
    }

}

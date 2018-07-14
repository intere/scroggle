//
//  ActionCell.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/30/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import UIKit


class ActionCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!

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
    func pressedButton(_ sender: Any) {
        DLog("Clicked: \(action.rawValue)")
        action.notify()
    }
}


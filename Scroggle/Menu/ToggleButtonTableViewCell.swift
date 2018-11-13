//
//  ToggleButtonTableViewCell.swift
//  Scroggle
//
//  Created by Eric Internicola on 11/7/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import UIKit

class ToggleButtonTableViewCell: UITableViewCell {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!

    var toggleCellInfo: ToggleCellInfo? {
        didSet {
            toggleSwitch.isOn = toggleCellInfo?.selected ?? false
            titleLabel.text = toggleCellInfo?.title
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        toggleSwitch.isOn = false
    }

    @IBAction
    func toggledSwitch(_ sender: Any) {
        toggleCellInfo?.action(toggleSwitch.isOn)
    }

}

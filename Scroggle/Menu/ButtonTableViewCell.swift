//
//  ButtonTableViewCell.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/8/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

/// This is the code behind the button table cell.  Literally just a cell with a button
class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton?

    /// The model that configures this cell
    var cellInfo: ButtonCellInfo? {
        didSet {
            configureView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction
    func tappedButton(_ sender: Any) {
        cellInfo?.action()
    }

}

// MARK: - Implementation

private extension ButtonTableViewCell {

    func configureView() {
        guard let cellInfo = cellInfo else {
            return
        }

        button?.setTitle(cellInfo.title, for: .normal)
    }
}

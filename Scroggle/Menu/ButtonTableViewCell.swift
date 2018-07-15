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

    /// The UIButton - so we can configure it via the `ButtonCellInfo` object.
    @IBOutlet weak var button: UIButton?

    /// The model that configures this cell
    var cellInfo: ButtonCellInfo? {
        didSet {
            configureView()
        }
    }

    @IBAction
    /// Handles the button tap (when the user taps the button).
    ///
    /// - Parameter sender: The source of the event.
    func tappedButton(_ sender: Any) {
        cellInfo?.action()
    }

}

// MARK: - Implementation

private extension ButtonTableViewCell {

    /// Configures the button using the `cellInfo` object
    func configureView() {
        guard let cellInfo = cellInfo else {
            return
        }

        button?.setTitle(cellInfo.title, for: .normal)
    }
}

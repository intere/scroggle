//
//  MenuHeaderTableViewCell.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/9/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

class MenuHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel?

    var title: String? {
        get {
            return label?.text
        }
        set {
            label?.text = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

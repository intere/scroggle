//
//  MenuInfo.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/8/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

class MenuInfo {
    let title: String
    let buttons: [ButtonCellInfo]

    init(title: String, buttons: [ButtonCellInfo]) {
        self.title = title
        self.buttons = buttons
    }
}

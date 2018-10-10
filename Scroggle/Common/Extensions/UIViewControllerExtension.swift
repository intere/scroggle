//
//  UIViewControllerExtension.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/9/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import UIKit

extension UIViewController {

    /// Are we currently in the portrait layout?
    var isPortrait: Bool {
        return view.bounds.height > view.bounds.width
    }

    /// Are we currently in the landscape layout?
    var isLandscape: Bool {
        return view.bounds.width > view.bounds.height
    }

    /// Is this device an iPad?
    var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

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

    /// Is the current device one of the "X" models?
    /// (FWIW, I hate having to resort to this, it's an anti pattern, but it is necessary)
    var isXdevice: Bool {
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return false
        }
        guard max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width) >= 812 else {
            return false
        }

        // 812.0 on iPhone X, XS.
        // 896.0 on iPhone XS Max, XR.
        return true
    }
}

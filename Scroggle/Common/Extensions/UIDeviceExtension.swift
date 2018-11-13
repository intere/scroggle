//
//  UIDeviceExtension.swift
//  Scroggle
//
//  Created by Eric Internicola on 11/4/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import UIKit

extension UIDevice {

    /// Is this device an iPad
    var isPad: Bool {
        return userInterfaceIdiom == .pad
    }

    /// Is this device an iPhone
    var isPhone: Bool {
        return userInterfaceIdiom == .phone
    }

    /// Is this one of the iPhone X models?
    var isX: Bool {
        guard isPhone else {
            return false
        }

        return UIScreen.main.nativeBounds.size.height >= 2436
    }

    /// Is this device an iPhone XS Max?
    var isXSMax: Bool {
        guard isX else {
            return false
        }
        return UIScreen.main.nativeBounds.size.height == 2688
    }

    /// Are we in portrait?
    var isPortrait: Bool {
        return orientation == .portrait
    }

    /// Are we in landscape?
    var isLandscape: Bool {
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            return true

        default:
            return false
        }
    }

}

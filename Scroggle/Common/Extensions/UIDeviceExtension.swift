//
//  UIDeviceExtension.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

// Provides various Device helper functions

extension UIDevice {

    var isWidescreen: Bool {
        let height = UIScreen.main.bounds.size.height
        return fabs(height - 568) < CGFloat(Double.ulpOfOne)
    }

    /// Is this device an iPad?
    var isiPad: Bool {
        return userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }

    /// Is this device an iPhone?
    var isiPhone: Bool {
        return userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }

    /// Is this a 9.7" iPad Pro?
    var isiPadPro9: Bool {
        return UIScreen.main.bounds.size.width == 1024
    }

    /// is this a 12.7" iPad Pro?
    var isiPadPro12: Bool {
        return UIScreen.main.bounds.size.width == 1366
    }

    /// is this an iPhone 4 sized device?  (deprecated device at this point)
    var isiPhone4: Bool {
        return UIScreen.main.bounds.size.width == 480
    }

    /// Is this an iPhone 5 sized device?
    var isiPhone5: Bool {
        return UIScreen.main.bounds.size.width == 568
    }

    /// is this an iPhone 6 sized device?
    var isiPhone6: Bool {
        return UIScreen.main.bounds.size.width == 667
    }

    /// is this an iPhone 6+ sized device?
    var isiPhone6Plus: Bool {
        return UIScreen.main.bounds.size.width == 736
    }

    /// Is this an iPhone X sized device?
    var isiPhoneX: Bool {
        return UIScreen.main.bounds.size.width == 812
    }

    var getDeviceType: String {
        var result: String = "Unknown Device"
        guard userInterfaceIdiom == UIUserInterfaceIdiom.phone else {
            return result
        }

        var screenHeight: CGFloat = UIScreen.main.bounds.size.height
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width

        if screenHeight < screenWidth {
            screenHeight = screenWidth;
        }

        if screenHeight > 480 && screenHeight < 667  {
            result = "iPhone 5/5s"
        } else if screenHeight > 480 && screenHeight < 736 {
            result = "iPhone 6"
        } else if screenHeight > 480 {
            result = "iPhone 6 Plus"
        } else {
            result = "iPhone 4/4s"
        }

        return result
    }
}

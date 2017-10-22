//
//  UIDeviceExtension.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

extension UIDevice {

    var isWidescreen: Bool {
        let height = UIScreen.main.bounds.size.height
        return fabs(height - 568) < CGFloat(Double.ulpOfOne)
    }

    var isiPadPro9: Bool {
        return UIScreen.main.bounds.size.width == 1024
    }

    var isiPadPro12: Bool {
        return UIScreen.main.bounds.size.width == 1366
    }

    var isiPad: Bool {
        return userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }

    var isiPhone: Bool {
        return userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }

    var isiPhone4: Bool {
        return UIScreen.main.bounds.size.width == 480
    }

    var isiPhone5: Bool {
        return UIScreen.main.bounds.size.width == 568
    }

    var isiPhone6: Bool {
        return UIScreen.main.bounds.size.width == 667
    }

    var isiPhone6Plus: Bool {
        return UIScreen.main.bounds.size.width == 736
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

        if( screenHeight > 480 && screenHeight < 667 ) {
            result = "iPhone 5/5s"
        } else if ( screenHeight > 480 && screenHeight < 736 ){
            result = "iPhone 6"
        } else if ( screenHeight > 480 ){
            result = "iPhone 6 Plus"
        } else {
            result = "iPhone 4/4s"
        }

        return result
    }
}

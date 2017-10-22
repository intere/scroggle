//
//  IntExtension.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation


extension Int {

    /**
     Converts the provided seconds to a time string.
     - Returns: The String representation of the number of seconds you provided.
     */
    var timeString: String {
        let minutes = self / 60
        let seconds = self % 60

        let minuteString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondString = seconds < 10 ? "0\(seconds)" : "\(seconds)"

        return "\(minuteString):\(secondString)"
    }
}

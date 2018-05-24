//
//  Extension+Time.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation


extension TimeInterval {

    /// Converts this TimeInterval to a string for you.
    /// The format will be something like this:
    /// * Minutes: 04:27
    /// * Seconds: 00:14
    var timeString: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60

        let minuteString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondString = seconds < 10 ? "0\(seconds)" : "\(seconds)"

        return "\(minuteString):\(secondString)"
    }

}


extension Int {

    /// Assumes this integer represents seconds and converts it to a time string.
    /// The format will be something like this:
    /// * Minutes: 04:27
    /// * Seconds: 00:14
    var timeString: String {
        return TimeInterval(self).timeString
    }
}

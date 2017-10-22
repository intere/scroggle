//
//  TimeIntervalExtension.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

extension TimeInterval {

    var timeString: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60

        let minuteString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondString = seconds < 10 ? "0\(seconds)" : "\(seconds)"

        return "\(minuteString):\(secondString)"
    }

}

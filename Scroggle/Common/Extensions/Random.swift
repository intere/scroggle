//
//  Random.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/3/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import Foundation
import SceneKit

extension Int {

    /// Produces a random number that's less than or equal to this number
    var random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }

}

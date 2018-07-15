//
//  CGPointExtensions.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/16/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import SpriteKit

extension CGPoint {

    /// Uses the Pythagorean theorem to compute the distance between this point and another.
    ///
    /// - Parameter point: The point you want to know the distance to.
    /// - Returns: The distance between this point and another as a CGFloat
    func distance(to point: CGPoint) -> CGFloat {
        let squareX = pow(x - point.x, 2)
        let squareY = pow(y - point.y, 2)
        let sum = squareX + squareY
        let distance = sqrt(sum)

        return distance
    }

}

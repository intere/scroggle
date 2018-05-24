//
//  SceneKitMathExtensions.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import SceneKit


extension SCNVector3 {

    /// Creates a `rotateTo` SCNAction using this SCNVector3 and the provided time interval.
    ///
    /// - Parameter duration: How long the rotation should take
    /// - Returns: The result of `SCNAction.rotateTo` for this vector and duration.
    func rotateTo(_ duration: TimeInterval) -> SCNAction {
        return SCNAction.rotateTo(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: duration)
    }

}

extension CGPoint {

    /// Tells you the distance between this point and the provided points.  This
    /// implementation uses the distance formulate which is derived from the
    /// Pythagorean Theorem:
    /// * d = (x^2 + y^2)^1/2
    ///
    /// - Parameter point: The point that you want the distance to.
    /// - Returns: The distance from this point to another point.
    func distanceTo(another point: CGPoint) -> CGFloat {
        let squareX = pow(x - point.x, 2)
        let squareY = pow(y - point.y, 2)
        let sum = squareX + squareY
        let distance = sqrt(sum)

        return distance
    }

}

extension Float {

    /// Assumes this float value is in decimal degrees, converts it to radians.
    var radians: Float {
        return GLKMathDegreesToRadians(self)
    }

    /// Assumes this float value is in radians, converts it to decimal degrees
    var degrees: Float {
        return GLKMathRadiansToDegrees(self)
    }

}

extension Int {

    /// Assumes this float value is in decimal degrees, converts it to radians.
    var radians: Float {
        return Float(self).radians
    }

    /// Assumes this float value is in radians, converts it to decimal degrees
    /// This is obviously not very useful, radians shouldn't generally be represented
    /// by an integer, because they are generally decimals.
    var degrees: Float {
        return Float(self).degrees
    }

}

extension Double {

    /// Assumes this float value is in decimal degrees, converts it to radians.
    var radians: Float {
        return Float(self).radians
    }

    /// Assumes this float value is in radians, converts it to decimal degrees
    var degrees: Float {
        return Float(self).degrees
    }
}

extension CGFloat {

    /// Assumes this float value is in decimal degrees, converts it to radians.
    var radians: Float {
        return Float(self).radians
    }

    /// Assumes this float value is in radians, converts it to decimal degrees
    var degrees: Float {
        return Float(self).degrees
    }

}

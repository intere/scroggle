//
//  SceneKitMathExtensions.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import SceneKit


extension SCNVector3 {

    func rotateTo(_ duration: TimeInterval) -> SCNAction {
        return SCNAction.rotateTo(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: duration)
    }

}

extension CGPoint {

    func distanceTo(another point: CGPoint) -> CGFloat {
        let squareX = pow(x - point.x, 2)
        let squareY = pow(y - point.y, 2)
        let sum = squareX + squareY
        let distance = sqrt(sum)

        return distance
    }

}

extension Float {

    var radians: Float {
        return GLKMathDegreesToRadians(self)
    }

    var degrees: Float {
        return GLKMathRadiansToDegrees(self)
    }

}

extension Int {

    var radians: Float {
        return Float(self).radians
    }

    var degrees: Float {
        return Float(self).degrees
    }

}

extension Double {

    var radians: Float {
        return Float(self).radians
    }

    var degrees: Float {
        return Float(self).degrees
    }
}

extension CGFloat {

    var radians: Float {
        return Float(self).radians
    }

    var degrees: Float {
        return Float(self).degrees
    }

}

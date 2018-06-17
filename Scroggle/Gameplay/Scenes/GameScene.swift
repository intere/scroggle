//
//  GameScene.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/16/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var controller: GameSceneController?

    /// Keeps track of where the initial drag point originated
    private var beganPoint: CGPoint?
    private var dragging = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let controller = controller else {
            return assertionFailure("No controller defined")
        }
        guard let point = touches.first?.location(in: self) else {
            return DLog("Failed to get the touch point")
        }
        controller.tapped(point: point)
        beganPoint = point
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let controller = controller else {
            return assertionFailure("No controller defined")
        }
        dragging = true

        for touch in touches {
            let currentPoint = touch.location(in: self)
            if nil != beganPoint && currentPoint != beganPoint! {
                guard let point = controller.handleDrag(point: currentPoint) else {
                    continue
                }
                beganPoint = point
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            dragging = false
        }
        guard let controller = controller else {
            return assertionFailure("No controller defined")
        }
        guard dragging else {
            return
        }
        guard let currentPoint = touches.first?.location(in: self) else {
            return DLog("No current point")
        }

        controller.handleDragEnd(point: currentPoint)
    }
}

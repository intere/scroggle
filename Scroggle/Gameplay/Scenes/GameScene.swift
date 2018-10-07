//
//  GameScene.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/16/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import SpriteKit

/// The Game Scene for the game board.  This class is mainly responsible for
/// receiving and delegating user interaction events off to the
// `GameSceneController`.
class GameScene: SKScene {

    /// The controller (a weak reference) for delegating user events off to
    weak var controller: GameSceneController?

    /// Keeps track of where the initial drag point originated
    private var beganPoint: CGPoint?

    /// Is the user currently dragging?
    private var dragging = false

    /// The last rendered drag point
    private var lastDrag = CGPoint.zero

    /// Did the game end?
    var gameOver = false

    /// This is the appropriate initializer to use for this class.
    ///
    /// - Parameter size: The size of the area that you want it to take up
    override init(size: CGSize) {
        super.init(size: size)
        Notification.Scroggle.GameEvent.gameEnded.addObserver(self, selector: #selector(gameOverEvent))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !gameOver else {
            controller?.clearSelection()
            return
        }
//        guard let controller = controller else {
//            return assertionFailure("No controller defined")
//        }
        guard let point = touches.first?.location(in: self) else {
            return DLog("Failed to get the touch point")
        }
        controller?.tapped(point: point)
        beganPoint = point
        showTouch(at: point)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !gameOver else {
            controller?.clearSelection()
            return
        }
//        guard let controller = controller else {
//            return assertionFailure("No controller defined")
//        }

        for touch in touches {
            let currentPoint = touch.location(in: self)
            if nil != beganPoint && currentPoint != beganPoint! {
                if lastDrag.distance(to: currentPoint) > 25 {
                    showTouch(at: currentPoint)
                    lastDrag = currentPoint
                }
                guard let point = controller?.handleDrag(point: currentPoint) else {
                    continue
                }
                dragging = true
                beganPoint = point
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !gameOver else {
            controller?.clearSelection()
            return
        }
        defer {
            dragging = false
        }
//        guard let controller = controller else {
//            return assertionFailure("No controller defined")
//        }
        guard dragging else {
            return
        }
        guard let currentPoint = touches.first?.location(in: self) else {
            return DLog("No current point")
        }

        controller?.handleDragEnd(point: currentPoint)
    }
}

// MARK: - Implementation

extension GameScene {

    @objc
    /// Handler for the Game Over event (cleans up)
    func gameOverEvent() {
        gameOver = true
        controller?.gameScene = nil
        controller = nil
    }

    /// Renders a small circle at the provided point.
    ///
    /// - Parameter point: The center point of the circle
    func showTouch(at point: CGPoint) {
        let size: CGFloat = 40
        let rect = CGRect(origin: CGPoint(x: point.x - size/2, y: point.y - size/2),
                          size: CGSize(width: size, height: size))
        let circle = SKShapeNode(ellipseIn: rect)
        circle.fillColor = UIColor.blue.withAlphaComponent(0.3)
        circle.strokeColor = circle.fillColor

        addChild(circle)
        circle.run(SKAction.fadeOut(withDuration: 0.3)) {
            circle.removeFromParent()
        }
    }
}

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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let controller = controller else {
            return assertionFailure("No controller defined")
        }
        guard let point = touches.first?.location(in: self) else {
            return DLog("Failed to get the touch point")
        }
        DLog("user began: \(point)")
        controller.tapped(point: point)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO: Implement Me
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO: Implement Me
    }
}

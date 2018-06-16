//
//  SCNGameScene+ClickableTiles.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/15/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import SpriteKit

extension SCNGameScene {

    /// This renders the clickable tiles for the dice
    func addClickableTiles() {
        guard let scene = skView.scene else {
            return assertionFailure("Failed to get the scene")
        }
        tiles.removeAll()

        let squareSize: CGFloat = 45
        let stepSizeX: CGFloat = 75
        let stepSizeY: CGFloat = 87.5

        for row in -1...2 {
            for column in -2...1 {
                let square = SKShapeNode(rectOf: CGSize(width: squareSize, height: squareSize))
                square.fillColor = UIColor.red.withAlphaComponent(0.5)
                let xPosition = scene.frame.midX - 37.5 + CGFloat(row) * stepSizeX
                let yPosition = scene.frame.midY + 42.5 + CGFloat(column) * stepSizeY
                square.position = CGPoint(x: xPosition, y: yPosition)
                square.zPosition = 100
                scene.addChild(square)
                tiles.append(square)
            }
        }
    }

    private struct TileConfiguration {
        let squareSize: CGFloat
        let stepSizeX: CGFloat
        let stepSizeY: CGFloat
        let offsetX: CGFloat
        let offsetY: CGFloat

        init(size: CGFloat, sizeX: CGFloat, sizeY: CGFloat, offsetX: CGFloat, offsetY: CGFloat) {
            squareSize = size
            stepSizeX = sizeX
            stepSizeY = sizeY
            self.offsetX = offsetX
            self.offsetY = offsetY
        }

        static var currentConfiguration: TileConfiguration {
            if UIDevice.current.isiPhoneX {
                return TileConfiguration(size: 45, sizeX: 75, sizeY: 87.5, offsetX: 37.5, offsetY: 42.5)
            }
            
            return TileConfiguration(size: 45, sizeX: 75, sizeY: 87.5, offsetX: 37.5, offsetY: 42.5)
        }
    }
}

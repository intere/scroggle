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

        let config = TileConfiguration.currentConfiguration
        for row in -1...2 {
            for column in -2...1 {
                let square = SKShapeNode(rectOf: CGSize(width: config.squareSize, height: config.squareSize))
                square.fillColor = UIColor.red.withAlphaComponent(0.5)
                let xPosition = scene.frame.midX - config.offsetX + CGFloat(row) * config.stepSizeX
                let yPosition = scene.frame.midY + config.offsetY + CGFloat(column) * config.stepSizeY
                square.position = CGPoint(x: xPosition, y: yPosition)
                square.zPosition = 100
                scene.addChild(square)
                tiles.append(square)
            }
        }
    }

    /// Data structure to give you values to build the overlays
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

        /// Gives you the overlay configuration for the current device
        static var currentConfiguration: TileConfiguration {
            if UIDevice.current.isiPhoneX {
                return TileConfiguration(size: 45, sizeX: 75, sizeY: 87.5, offsetX: 37.5, offsetY: 42.5)
            }
            if UIDevice.current.isiPhone5 {
                return TileConfiguration(size: 45, sizeX: 77.5, sizeY: 77.5, offsetX: 37.5, offsetY: 37.5)
            }
            if UIDevice.current.isiPhone6Plus {
                return TileConfiguration(size: 45, sizeX: 77.5, sizeY: 77.5, offsetX: 37.5, offsetY: 37.5)
            }
            if UIDevice.current.isiPhone6 {
                return TileConfiguration(size: 45, sizeX: 77.5, sizeY: 77.5, offsetX: 37.5, offsetY: 37.5)
            }
            if UIDevice.current.isiPad {
                return TileConfiguration(size: 45, sizeX: 77.5, sizeY: 87.5, offsetX: 37.5, offsetY: 42.5)
            }

            return TileConfiguration(size: 45, sizeX: 77.5, sizeY: 77.5, offsetX: 37.5, offsetY: 37.5)
        }
    }
}

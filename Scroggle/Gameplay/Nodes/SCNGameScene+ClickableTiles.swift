//
//  SCNGameScene+ClickableTiles.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/15/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import SpriteKit

// This file contains functions that specifically help out with
// things related to the "Clickable Tiles".

extension SCNGameScene {

    /// This renders the clickable tiles for the dice and
    /// populates the `tiles` property with the clickable
    /// tiles in the same order as the dice
    func addClickableTiles() {
        guard let scene = skView.scene else {
            return assertionFailure("Failed to get the scene")
        }
        tiles.removeAll()

        let config = TileConfiguration.currentConfiguration
        var rowNodes: [SKShapeNode] = []

        for column in -2...1 {
            for row in -1...2 {
                let square = SKShapeNode(rectOf: CGSize(width: config.squareSize, height: config.squareSize))
                square.fillColor = UIColor.red.withAlphaComponent(0.5)
                let xPosition = scene.frame.midX - config.offsetX + CGFloat(row) * config.stepSizeX
                let yPosition = scene.frame.midY + config.offsetY + CGFloat(column) * config.stepSizeY
                square.position = CGPoint(x: xPosition, y: yPosition)
                square.zPosition = 100
                scene.addChild(square)
                rowNodes.append(square)

                // We have to reverse the order of this row so it's
                // in the same order as the dice
                if row == 2 {
                    rowNodes.reverse()
                    tiles.append(contentsOf: rowNodes)
                    rowNodes.removeAll()
                }
            }
        }
        tiles.reverse()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.animateTiles()
            self?.animateDice()
        }
    }

    /// Data structure to give you values to build the overlays
    private struct TileConfiguration {
        let squareSize: CGFloat
        let stepSizeX: CGFloat
        let stepSizeY: CGFloat
        let offsetX: CGFloat
        let offsetY: CGFloat

        /// Sets all of the required parameters for the `TileConfiguration`.
        ///
        /// - Parameters:
        ///   - size: The size of the tile to be rendered
        ///   - sizeX: The size of the offset in the X-direction.
        ///   - sizeY: The size of the offset in the Y-direction.
        ///   - offsetX: The initial offset in the X-direction.
        ///   - offsetY: The initial offset in the Y-direction
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

// MARK: - Debugging

extension SCNGameScene {

    /// Debugging tool that iterates through all of the tiles and highlights them
    ///
    /// - Parameter index: The index of the tile to highlight
    func animateTiles(_ index: Int = 0) {
        guard index < tiles.count else {
            return
        }

        tiles[index].fillColor = UIColor.green.withAlphaComponent(0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.tiles[index].fillColor = UIColor.red.withAlphaComponent(0.5)
            self?.animateTiles(index+1)
        }
    }

}

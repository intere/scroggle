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

extension GameSceneController {

    /// Gets you the currently selected word
    var currentWord: String {
        return selection.map({ letter(for: $0) ?? "" }).joined()
    }

    /// Handles the action of a user tapping a specific point
    ///
    /// - Parameter point: The point in the scene that was tapped
    func tapped(point: CGPoint) {
        guard let index = tiles.index(where: {$0.contains(point)}) else {
            return DLog("No tile detected")
        }
        if index == selection.last {
            return guessWord()
        }
        guard addSelected(index: index) else {
            return
        }
    }

    /// Handles the dragging action.
    ///
    /// - Parameter point: The point in the scene that was tapped.
    /// - Returns: the point if it was added, nil if not.
    func handleDrag(point: CGPoint) -> CGPoint? {
        guard let index = tiles.index(where: {$0.contains(point)}) else {
            return nil
        }
        guard index != selection.last else {
            // If it's the same tile they were dragging over before, don't add it
            return nil
        }

        guard addSelected(index: index) else {
            // If the selected tile couldn't be added, don't return a point
            return nil
        }

        return point
    }

    /// Handles the end point of a drag.
    ///
    /// - Parameter point: The point at which the dragging has ended.
    func handleDragEnd(point: CGPoint) {
        _ = handleDrag(point: point)
        guessWord()
    }

    /// Guesses a word
    private func guessWord() {
        let currentWord = self.currentWord

        defer {
            selection.removeAll()
            clearSelection()
        }

        if LexiconProvider.instance.isValidWord(currentWord) {
            guard !gameContext.alreadyGuessed(currentWord) else {
                return selectionPath.forEach({$0.fillColor = .yellow ; $0.strokeColor = .yellow })
            }
            gameContext.addAndScoreWord(currentWord)
            showGuess()
        } else {
            selectionPath.forEach({$0.fillColor = .red ; $0.strokeColor = .red })
        }
    }

    @discardableResult
    func addSelected(index: Int) -> Bool {
        guard isValid(move: index) else {
            return false
        }
        selection.append(index)
        renderSelection()
        return true
    }

    /// Is the move to the provided selection a valid move?
    /// A move is valid if:
    /// * This is the first index for the selection - or -
    /// * The index is not already contained in the selection
    /// * The move is adjacent to the last selected index
    ///
    /// - Parameter index: The index that you want to select
    /// - Returns: True if it's valid, false if it's not.
    func isValid(move index: Int) -> Bool {
        guard !selection.contains(index) else {
            return false
        }
        guard let lastMove = selection.last?.to4x4Point else {
            return true
        }
        return lastMove.distance(to: index.to4x4Point) < 2.0
    }

    /// Gets you the letter at the specified index.
    ///
    /// - Parameter index: The index that you want the letter for
    /// - Returns: The letter(s) at the provided index or nil if it's invalid or the board is unavailable.
    func letter(for index: Int) -> String? {
        guard let diceArray = GameContextProvider.instance.currentGame?.game.board.board else {
            assertionFailure("Failed to get dice array")
            return nil
        }
        guard index < diceArray.count else {
            assertionFailure("Index out of bounds")
            return nil
        }
        return diceArray[index].roll
    }

    /// This renders the clickable tiles for the dice and
    /// populates the `tiles` property with the clickable
    /// tiles in the same order as the dice
    func addClickableTiles() {
        guard let scene = skView.scene else {
            return assertionFailure("Failed to get the scene")
        }
        tiles.removeAll()

        let config = TileConfiguration.currentConfiguration(skView)
        var rowNodes: [SKShapeNode] = []

        for column in 0...3 {
            for row in 0...3 {
                let square = SKShapeNode(rectOf: CGSize(width: config.squareSize, height: config.squareSize))
                square.fillColor = .clear
                square.strokeColor = .clear
                let xPosition = scene.frame.midX - config.offsetX + CGFloat(row-1) * config.stepSizeX
                let yPosition = scene.frame.midY + config.offsetY + CGFloat(column-2) * config.stepSizeY
                square.position = CGPoint(x: xPosition, y: yPosition)
                square.zPosition = 100
//                #if DEBUG
//                square.fillColor = UIColor.blue.withAlphaComponent(0.4)
//                #endif
                square.name = "tile_\(column)_\(row)"
                rowNodes.append(square)
                scene.addChild(square)

                // We have to reverse the order of this row so it's
                // in the same order as the dice
                if row == 3 {
                    rowNodes.reverse()
                    tiles.append(contentsOf: rowNodes)
                    rowNodes.removeAll()
                }
            }
        }
        tiles.reverse()

        // Debugging - animates the tiles and dice so you can verify that the order is the same
//        debugAnimateImages()
    }

    /// Data structure to give you values to build the overlays
    private struct TileConfiguration: CustomDebugStringConvertible {
        let squareSize: CGFloat
        let stepSizeX: CGFloat
        let stepSizeY: CGFloat
        let offsetX: CGFloat
        let offsetY: CGFloat

        var debugDescription: String {
            var result = "squareSize: \(squareSize), stepSizeX: \(stepSizeX), stepSizeY: \(stepSizeY)"
            result += ", offsetX: \(offsetX), offsetY: \(offsetY)"
            return result
        }

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
        static func currentConfiguration(_ skView: SKView) -> TileConfiguration {
            let sizeX = skView.frame.size.width / 5.25
            let sizeY = skView.frame.size.height / 5.25
            return TileConfiguration(size: sizeX * 0.6, sizeX: sizeX, sizeY: sizeY, offsetX: sizeX / 2, offsetY: sizeY / 2)
        }
    }
}

// MARK: - Selection Visualization

extension GameSceneController {

    /// Clears out the entire selection
    func clearSelection() {
        selectionPath.forEach { (node) in
            node.run(SKAction.fadeOut(withDuration: 0.2)) {
                node.removeFromParent()
            }
        }
        selectionPath.removeAll()
    }

    /// Renders the most recent move
    func renderSelection() {
        guard selection.count > 1 else {
            return
        }
        DLog("Selections: \(selection)")

        let fromNode = selection[selection.count-1]
        let toNode = selection[selection.count-2]
        let name = "sel_\(selection.count)"

        guard let line = drawLine(from: fromNode, to: toNode, name: name) else {
            return
        }

        selectionPath.append(line)
    }

    /// Shows the word you guessed.
    func showGuess() {
        guard let scene = skView.scene, !currentWord.isEmpty else {
            return
        }

        let label = SKLabelNode(fontNamed: UIFont.Scroggle.defaultFontName)
        label.text = currentWord
        label.fontSize = 24
        label.fontColor = .green  // TODO: Color based on right / wrong / dupe
        label.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        label.zPosition = 200
        scene.addChild(label)

        label.run(SKAction.scale(to: 10, duration: 0.5)) {
            label.removeFromParent()
        }
    }

    /// Draws a line from the provided starting index to the provided ending index.
    ///
    /// - Parameters:
    ///   - from: The index of the shape node to start drawing at
    ///   - to: The index of the shape node to end drawing at
    private func drawLine(from: Int, to index: Int, name: String) -> SKShapeNode? {
        guard let scene = skView.scene else {
            DLog("ERROR: No scene to draw a line on")
            return nil
        }
        let startPoint = CGPoint(x: tiles[from].frame.midX, y: tiles[from].frame.midY)
        let endPoint = CGPoint(x: tiles[index].frame.midX, y: tiles[index].frame.midY)

        // Create line with SKShapeNode
        let line = SKShapeNode()
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        line.path = path.cgPath
        line.strokeColor = UIColor.green.withAlphaComponent(0.7)
        line.lineWidth = 5
        line.zPosition = 150
        line.lineCap = .round

        scene.addChild(line)

        return line
    }
}

// MARK: - Debugging

extension GameSceneController {

    func debugAnimateImages() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.animateTiles()
            self?.animateDice()
        }
    }

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

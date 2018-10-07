//
//  GameContainerViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 6/3/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import Cartography
import SceneKit
import SpriteKit
import UIKit

class GameContainerViewController: UIViewController {
    var scoreArea: UIView!
    var gameArea: UIView!
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Bounds: \(view.bounds)")
        print("Frame: \(view.frame)")

        imageView = UIImageView(image: #imageLiteral(resourceName: "HomeScreen-4"))
        if isPortrait {
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(180.radians))
        }
        imageView.contentMode = .scaleToFill
        view.addSubview(imageView)

        scoreArea = UIView()
        scoreArea.backgroundColor = UIColor.red.withAlphaComponent(0.4)
        view.addSubview(scoreArea)

        gameArea = UIView()
        gameArea.backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        view.addSubview(gameArea)

        constrain(view, imageView) { view, imageView in
            imageView.top == view.top
            imageView.bottom == view.bottom
            imageView.left == view.left
            imageView.right == view.right
        }

        if isPortrait {
            buildPortrait()
        } else {
            buildLandscape()
        }
    }

    public static func loadFromStoryboard() -> GameContainerViewController {
        // swiftlint:disable:next force_cast
        return UIStoryboard(name: "GameContainer", bundle: nil).instantiateInitialViewController() as! GameContainerViewController
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:
                DLog("Animating to Portrait")
                self.buildPortrait()

            default:
                DLog("Animating to Landscape")
                self.buildLandscape()
            }
        }) { context in
            DLog("rotation completed")
        }
        super.willTransition(to: newCollection, with: coordinator)
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .portraitUpsideDown:
            DLog("Animating to Portrait")
            self.buildPortrait()

        default:
            DLog("Animating to Landscape")
            self.buildLandscape()
        }
    }

}

// MARK: - Implementation

extension GameContainerViewController {

    var isPortrait: Bool {
        return view.bounds.height > view.bounds.width
    }

    var isLandscape: Bool {
        return view.bounds.width > view.bounds.height
    }

    var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    func buildPortrait() {
        print("Yep, it's portrait mode")
        scoreArea.removeFromSuperview()
        gameArea.removeFromSuperview()
        view.addSubview(scoreArea)
        view.addSubview(gameArea)
        constrain(view, scoreArea, gameArea) { view, scoreArea, gameArea in
            scoreArea.top == view.layoutMarginsGuide.top
            scoreArea.left == view.layoutMarginsGuide.left
            scoreArea.right == view.layoutMarginsGuide.right
            scoreArea.bottom == view.layoutMarginsGuide.centerY
            gameArea.top == view.layoutMarginsGuide.centerY
            gameArea.left == view.layoutMarginsGuide.left
            gameArea.right == view.layoutMarginsGuide.right
            gameArea.bottom == view.layoutMarginsGuide.bottom
        }
    }

    func buildLandscape() {
        print("Yep, it's landscape mode")
        scoreArea.removeFromSuperview()
        gameArea.removeFromSuperview()
        view.addSubview(scoreArea)
        view.addSubview(gameArea)
        constrain(view, scoreArea, gameArea) { view, scoreArea, gameArea in
            scoreArea.top == view.layoutMarginsGuide.top + 20
            scoreArea.left == view.layoutMarginsGuide.left
            scoreArea.right == view.layoutMarginsGuide.centerX
            scoreArea.bottom == view.layoutMarginsGuide.bottom

            gameArea.top == view.layoutMarginsGuide.top + 20
            gameArea.left == view.layoutMarginsGuide.centerX
            gameArea.right == view.layoutMarginsGuide.right
            gameArea.bottom == view.layoutMarginsGuide.bottom
        }
    }

}

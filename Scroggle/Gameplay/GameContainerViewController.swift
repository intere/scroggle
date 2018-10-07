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
    var contentView: UIView!

    /// This is the "Wood Finish" part of the chalkboard
    var outerImageView: UIImageView!

    /// This is the inner, black chalkboard part of the chalkboard
    var innerImageView: UIImageView!

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Bounds: \(view.bounds)")
        print("Frame: \(view.frame)")

        outerImageView = UIImageView(image: #imageLiteral(resourceName: "wood_border"))
        innerImageView = UIImageView(image: #imageLiteral(resourceName: "chalkboard"))
        if isPortrait {
            outerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(180.radians))
            innerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(180.radians))
        }
        outerImageView.contentMode = .scaleToFill
        innerImageView.contentMode = .scaleToFill

        scoreArea = UIView()
        scoreArea.backgroundColor = UIColor.red.withAlphaComponent(0.4)

        gameArea = UIView()
        gameArea.backgroundColor = UIColor.blue.withAlphaComponent(0.4)


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
        }, completion: { _ in
            DLog("rotation completed")
        })
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
        view.subviews.forEach { $0.removeFromSuperview() }
        view.addSubview(outerImageView)
        view.addSubview(innerImageView)

        constrain(view, outerImageView, innerImageView) { view, outerImageView, innerImageView in
            outerImageView.top == view.top
            outerImageView.bottom == view.bottom
            outerImageView.left == view.left
            outerImageView.right == view.right

            if #available(iOS 11.0, *) {
                let bottomMargin: CGFloat = 20
                innerImageView.top == view.safeAreaLayoutGuide.topMargin
                innerImageView.bottom == view.safeAreaLayoutGuide.bottomMargin - bottomMargin
                innerImageView.left == view.safeAreaLayoutGuide.leftMargin + 20
                innerImageView.right == view.safeAreaLayoutGuide.rightMargin - 20
            } else {
                let topMargin: CGFloat = 20
                let bottomMargin: CGFloat = 20
                innerImageView.top == view.layoutMarginsGuide.topMargin + topMargin
                innerImageView.bottom == view.layoutMarginsGuide.bottomMargin - bottomMargin
                innerImageView.left == view.layoutMarginsGuide.leftMargin
                innerImageView.right == view.layoutMarginsGuide.rightMargin
            }
        }
//        print("Yep, it's portrait mode")
//        scoreArea.removeFromSuperview()
//        gameArea.removeFromSuperview()
//        view.addSubview(scoreArea)
//        view.addSubview(gameArea)
//
//        let topPadding: CGFloat = isPad ? 32 : 0
//        let horizontalPadding: CGFloat = isPad ? 20 : 0
//        let bottomPadding: CGFloat = isPad ? 42 : 0
//
//        constrain(view, scoreArea, gameArea) { view, scoreArea, gameArea in
//            scoreArea.top == view.layoutMarginsGuide.top + topPadding
//            scoreArea.left == view.layoutMarginsGuide.left + horizontalPadding
//            scoreArea.right == view.layoutMarginsGuide.right - horizontalPadding
//            scoreArea.bottom == view.layoutMarginsGuide.centerY
//            gameArea.top == view.layoutMarginsGuide.centerY
//            gameArea.left == view.layoutMarginsGuide.left + horizontalPadding
//            gameArea.right == view.layoutMarginsGuide.right - horizontalPadding
//            gameArea.bottom == view.layoutMarginsGuide.bottom - bottomPadding
//        }
    }

    func buildLandscape() {
        view.subviews.forEach { $0.removeFromSuperview() }
        view.addSubview(outerImageView)
        view.addSubview(innerImageView)

        constrain(view, outerImageView, innerImageView) { view, outerImageView, innerImageView in
            outerImageView.top == view.top
            outerImageView.bottom == view.bottom
            outerImageView.left == view.left
            outerImageView.right == view.right


            let horizontalMargin: CGFloat = 20

            if #available(iOS 11.0, *) {
                let topMargin: CGFloat = isPad ? 0 : 20
                let bottomMargin: CGFloat = isXdevice ? 0 : 20
                innerImageView.top == view.safeAreaLayoutGuide.topMargin + topMargin
                innerImageView.bottom == view.safeAreaLayoutGuide.bottomMargin - bottomMargin
                innerImageView.left == view.safeAreaLayoutGuide.leftMargin + horizontalMargin
                innerImageView.right == view.safeAreaLayoutGuide.rightMargin - horizontalMargin
            } else {
                let topMargin: CGFloat = 20
                let bottomMargin: CGFloat = 20
                innerImageView.top == view.layoutMarginsGuide.topMargin + topMargin
                innerImageView.bottom == view.layoutMarginsGuide.bottomMargin - bottomMargin
                innerImageView.left == view.layoutMarginsGuide.leftMargin
                innerImageView.right == view.layoutMarginsGuide.rightMargin
            }
        }
//        print("Yep, it's landscape mode")
//        scoreArea.removeFromSuperview()
//        gameArea.removeFromSuperview()
//        view.addSubview(scoreArea)
//        view.addSubview(gameArea)
//
//        let topPadding: CGFloat = isPad ? 20 : 0
//        let padding: CGFloat = isPad ? 30 : 0
//
//        constrain(view, scoreArea, gameArea) { view, scoreArea, gameArea in
//            scoreArea.top == view.layoutMarginsGuide.top + topPadding
//            scoreArea.left == view.layoutMarginsGuide.left + padding
//            scoreArea.right == view.layoutMarginsGuide.centerX
//            scoreArea.bottom == view.layoutMarginsGuide.bottom - padding
//
//            gameArea.top == view.layoutMarginsGuide.top + topPadding
//            gameArea.left == view.layoutMarginsGuide.centerX
//            gameArea.right == view.layoutMarginsGuide.right - padding
//            gameArea.bottom == view.layoutMarginsGuide.bottom - padding
//        }
    }

    /// Is the current device one of the "X" models?
    /// (FWIW, I hate having to resort to this, it's an anti pattern, but it is necessary)
    var isXdevice: Bool {
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return false
        }
        guard max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width) >= 812 else {
            return false
        }

        // 812.0 on iPhone X, XS.
        // 896.0 on iPhone XS Max, XR.
        return true
    }

}

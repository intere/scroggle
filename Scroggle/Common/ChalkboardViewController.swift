//
//  ChalkboardViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/7/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import Cartography
import UIKit


open class ChalkboardViewController: UIViewController {

    /// Where you add the content
    public var contentView: UIView!

    /// This is the "Wood Finish" part of the chalkboard
    private var outerImageView: UIImageView!

    /// This is the inner, black chalkboard part of the chalkboard
    private var innerImageView: UIImageView!

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        print("Bounds: \(view.bounds)")
        print("Frame: \(view.frame)")

        outerImageView = UIImageView(image: #imageLiteral(resourceName: "wood_border"))
        innerImageView = UIImageView(image: #imageLiteral(resourceName: "chalkboard"))
        contentView = UIView()
        if isPortrait {
            outerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(180.radians))
            innerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(180.radians))
        }
        outerImageView.contentMode = .scaleToFill
        innerImageView.contentMode = .scaleToFill

        if isPortrait {
            buildPortrait()
        } else {
            buildLandscape()
        }
    }

    open override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:
                //                DLog("Animating to Portrait")
                self.buildPortrait()

            default:
                //                DLog("Animating to Landscape")
                self.buildLandscape()
            }
        }, completion: { _ in
            DLog("rotation completed")
        })
        super.willTransition(to: newCollection, with: coordinator)
    }

    // For older iOS versions that support 
    open override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .portraitUpsideDown:
            DLog("Animating to Portrait")
            self.buildPortrait()

        default:
            DLog("Animating to Landscape")
            self.buildLandscape()
        }
    }

    open func buildPortrait() {
        doBuildPortrait()
    }

    open func buildLandscape() {
        doBuildLandscape()
    }

}

// MARK: - Implementation

extension ChalkboardViewController {

    var isPortrait: Bool {
        return view.bounds.height > view.bounds.width
    }

    var isLandscape: Bool {
        return view.bounds.width > view.bounds.height
    }

    var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    func doBuildPortrait() {
        view.subviews.forEach { $0.removeFromSuperview() }
        [outerImageView, innerImageView, contentView].forEach { view.addSubview($0) }

        constrain(view, outerImageView, innerImageView, contentView) { view, outerImageView, innerImageView, contentView in
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

            contentView.top == innerImageView.top
            contentView.left == innerImageView.left
            contentView.right == innerImageView.right
            contentView.bottom == innerImageView.bottom
        }
    }

    func doBuildLandscape() {
        view.subviews.forEach { $0.removeFromSuperview() }
        [outerImageView, innerImageView, contentView].forEach { view.addSubview($0) }

        constrain(view, outerImageView, innerImageView, contentView) { view, outerImageView, innerImageView, contentView in
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
            contentView.top == innerImageView.top
            contentView.left == innerImageView.left
            contentView.right == innerImageView.right
            contentView.bottom == innerImageView.bottom
        }
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

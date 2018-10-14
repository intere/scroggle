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
        DLog("Bounds: \(view.bounds)")
        DLog("Frame: \(view.frame)")

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

        Notification.Scroggle.MenuAction.tappedBackButton.addObserver(self, selector: #selector(tappedCloseButton(_:)))

        // As a convenience, if the implementer conforms to MenuBuilding, we'll
        // automatically create a MenuContainerVC and wire it up for you.
        if let menuBuilding = self as? MenuBuilding {
            let menuVC = MenuContainerViewController.loadFromStoryboard()
            addContent(viewController: menuVC)
            menuVC.menuBuilder = menuBuilding
        }
    }

    open override func willTransition(to newCollection: UITraitCollection,
                                      with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:
                self.buildPortrait()

            default:
                self.buildLandscape()
            }
        }, completion: { _ in
            DLog("rotation completed")
        })
        super.willTransition(to: newCollection, with: coordinator)
        children.forEach { $0.willTransition(to: newCollection, with: coordinator) }
    }

    open override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .portraitUpsideDown:
            self.buildPortrait()

        default:
            self.buildLandscape()
        }
    }

    open func buildPortrait() {
        doBuildPortrait()
    }

    open func buildLandscape() {
        doBuildLandscape()
    }

    /// Embeds the view from the provided view controller into the contentView and
    /// calls the appropriate view controller functions.
    ///
    /// - Parameter viewController: The child view controller to add.
    public func addContent(viewController: UIViewController) {
        guard let childView = viewController.view else {
            return assertionFailure("nope")
        }
        setContentView(childView)
        addChild(viewController)
        viewController.didMove(toParent: self)
    }

    /// Adds and sets the provided view as the child view.
    /// The view is added to the contentView and then constrained
    /// to that view, exactly.
    ///
    /// - Parameter childView: The child view.
    public func setContentView(_ childView: UIView) {
        contentView.addSubview(childView)
        constrain(contentView, childView) { view, childView in
            childView.top == view.top
            childView.left == view.left
            childView.right == view.right
            childView.bottom == view.bottom
        }
    }

    @IBAction
    open func tappedCloseButton(_ notification: NSNotification) {
        SoundProvider.instance.playMenuSelectionSound()
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - Implementation

extension ChalkboardViewController {

    func doBuildPortrait() {
        view.subviews.forEach { $0.removeFromSuperview() }
        [outerImageView, innerImageView, contentView].forEach { view.addSubview($0) }

        constrain(view, outerImageView, innerImageView, contentView) {
            (view, outerImageView, innerImageView, contentView) in
            // swiftlint:disable:previous closure_parameter_position
            
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

        constrain(view, outerImageView, innerImageView, contentView) {
            (view, outerImageView, innerImageView, contentView) in
            // swiftlint:disable:previous closure_parameter_position
            
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
}

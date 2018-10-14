//
//  IntroductionViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit
import SceneKit

/// The controller for the Introduction Scene 
class IntroductionViewController: UIViewController {

    @IBOutlet var scnView: SCNView!

    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        #if DEBUG
            scnView.showsStatistics = true
        #endif

        loadMainMenu()

        timer = Timer.scheduledTimer(timeInterval: 10, target: self,
                                     selector: #selector(loadMainMenu),
                                     userInfo: nil, repeats: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

}

// MARK: - Actions

extension IntroductionViewController {

    @IBAction
    func tapped(gesture: UIGestureRecognizer) {
        timer?.invalidate()
        SoundProvider.instance.playMenuSelectionSound()
        loadMainMenu()
    }
}

// MARK: - Helpers

extension IntroductionViewController {

    @objc
    func loadMainMenu() {
        guard let navigationController = navigationController else {
            DLog("No NavigationVC for the Intro VC")
            return
        }
        var controllerStack = navigationController.viewControllers
        guard let index = controllerStack.index(of: self) else {
            DLog("Can't find the IntroVC in the Navigation Stack")
            return
        }

        let mainMenuVC = MainMenuViewController.loadFromStoryboard()

        controllerStack[index] = mainMenuVC
        navigationController.setViewControllers(controllerStack, animated: true)
    }

}

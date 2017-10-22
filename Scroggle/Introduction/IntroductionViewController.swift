//
//  IntroductionViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit
import SceneKit

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

        guard let scene = GameScene.loadGameScene(useDemoCamera: true) else {
            assert(false, "Failed to find the GameScene")
            return
        }

        scene.gameContext = GameContextProvider.instance.createSinglePlayerGame(.default)
        GameContextProvider.instance.currentGame = nil
        scene.board = DiceProvider.instance.loadDemoDice()
        scene.loadBoard()

        scnView.scene = scene

        if SettingsService.Configuration.isTesting {
            return loadMainMenu()
        } else {
            scene.introAnimation()
        }

        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(loadMainMenu), userInfo: nil, repeats: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        guard let scene = scnView.scene as? GameScene else {
            return
        }
        scene.delegate = nil
        scene.gameContext.game.timer.delegate = nil
    }

}

// MARK: - Actions

extension IntroductionViewController {

    @IBAction func tapped(gesture: UIGestureRecognizer) {
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
        let storyboard = UIStoryboard(name: "Menu", bundle: Bundle.main)
        guard let menuNavVC = storyboard.instantiateInitialViewController() as? UINavigationController, let menuVC = menuNavVC.viewControllers.first else {
            DLog("Couldn't create a MenuVC")
            return
        }
        controllerStack[index] = menuVC
        navigationController.setViewControllers(controllerStack, animated: true)
    }

}


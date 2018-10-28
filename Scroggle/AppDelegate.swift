//
//  AppDelegate.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/8/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Crashlytics
import Fabric
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        #if !DEBUG
        Fabric.with([Crashlytics.self, Answers.self])
        #else
        GameContextProvider.Configuration.demoMode = false
        GameContextProvider.instance.createSinglePlayerGame(.default)
        #endif

        // Kickoff our initialization with GameCenter
        GameCenterProvider.instance.performLoginCheck()

        return true
    }

}

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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        #if !DEBUG
        Fabric.with([Crashlytics.self])
        #endif

        // TODO: Delete this next debugging line
        #if DEBUG
        GameContextProvider.instance.createSinglePlayerGame(.veryShort)
        #endif

        return true
    }


}


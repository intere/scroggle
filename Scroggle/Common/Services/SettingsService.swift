//
//  SettingsService.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

class SettingsService {

    struct Configuration {
        /// Are we running in the unit test fixture?
        static var isTesting: Bool {
            #if targetEnvironment(simulator)
                return true
            #else
            if NSClassFromString("XCTest") != nil {
                return true
            }
            return false
            #endif
        }
    }

    /// Should the tiles be visible?
    /// debug only option.
    static var showTiles: Bool {
        get {
            #if DEBUG
            return UserDefaults.standard.bool(forKey: "show.tiles")
            #else
            return false
            #endif
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "show.tiles")
        }
    }

}

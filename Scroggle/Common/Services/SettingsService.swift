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
            #endif
            if let _ = NSClassFromString("XCTest") {
                return true
            }
            return false
        }
    }
    
}

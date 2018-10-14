//
//  ConfigurationProvider.swift
//  Scroggle
//
//  Created by Eric Internicola on 11/8/15.
//  Copyright © 2015 iColasoft. All rights reserved.
//

import Foundation



/// This class contains various configuration specific values to read / manage.
class ConfigurationProvider {
    private let introDicePop: Float = 0.7
    private let gameDicePop: Float = 0.07

    static let instance = ConfigurationProvider()

    var demoMode = false
    var dicePopValue: Float = 0.7

    // Are we running in the simulator?
    var isSimulator: Bool {
        return TARGET_IPHONE_SIMULATOR == 1
    }

    var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }

    var appBuildNumber: String {
        if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return buildNumber
        }
        return ""
    }


    func toggleInroDicePopValue() {
        dicePopValue = introDicePop
    }

    func toggleGameDicePopValue() {
        dicePopValue = gameDicePop
    }
}

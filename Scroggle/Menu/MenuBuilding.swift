//
//  MenuBuilding.swift
//  Scroggle
//
//  Created by Eric Internicola on 4/7/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import Foundation
import UIKit

/// A protocol that knows how to build a menu.  As an implementer,
/// you must return an optional `MenuInfo` object when `buildMenu()` is called.
protocol MenuBuilding: class {

    /// Responsible for building out the menu implementation
    ///
    /// - Returns: A MenuInfo object that contains the menu options
    func buildMenu() -> MenuInfo?
    
}

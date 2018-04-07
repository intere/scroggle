//
//  MenuBuilding.swift
//  Scroggle
//
//  Created by Eric Internicola on 4/7/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import Foundation
import UIKit

protocol MenuBuilding: class {

    /// Responsible for building out the menu implementation
    ///
    /// - Returns: A MenuInfo object that contains the menu options
    func buildMenu() -> MenuInfo?
    
}

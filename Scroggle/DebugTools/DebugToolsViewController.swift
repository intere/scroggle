//
//  DebugToolsViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 11/5/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import Cartography
import UIKit

class DebugToolsViewController: ChalkboardViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    class func loadFromStoryboard() -> DebugToolsViewController {
        return UIStoryboard(name: "DebugTools", bundle: nil)
            .instantiateViewController(withIdentifier: "DebugToolsViewController") as! DebugToolsViewController
        // swiftlint:disable:previous force_cast
    }

}

extension DebugToolsViewController: MenuBuilding {

    func buildMenu() -> MenuInfo? {
        var buttons = [MenuCellInfo]()
        buttons.append(
            ToggleCellInfo(title: "Show Game Tiles", selected: SettingsService.showTiles) { (selected) in
                SettingsService.showTiles = selected
            }
        )

        return MenuInfo(title: "Debug", showCloseButton: true, buttons: buttons)
    }


}

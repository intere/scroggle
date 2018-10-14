//
//  HelpMenuViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/14/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import UIKit

class HelpMenuViewController: ChalkboardViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    class func loadFromStoryboard() -> HelpMenuViewController {
        return UIStoryboard(name: "Help", bundle: nil)
            .instantiateViewController(withIdentifier: "HelpMenuViewController") as! HelpMenuViewController
        // swiftlint:disable:previous force_cast
    }

}

// MARK: - MenuBuilding

extension HelpMenuViewController: MenuBuilding {

    func buildMenu() -> MenuInfo? {
        return MenuInfo(title: "Help", buttons: [
            ButtonCellInfo(title: "General Help", action: { [weak self] in
                SoundProvider.instance.playMenuSelectionSound()
                let url = "https://intere.github.io/scroggle-support/#/help"
                self?.navigationController?.pushViewController(WebViewController.loadFromStoryboard(url: url), animated: true)
            }),
            ButtonCellInfo(title: "Goals + Rules", action: { [weak self] in
                SoundProvider.instance.playMenuSelectionSound()
                let url = "https://intere.github.io/scroggle-support/#/rules"
                self?.navigationController?.pushViewController(WebViewController.loadFromStoryboard(url: url), animated: true)
            }),
            ButtonCellInfo(title: "Email support", action: { [weak self] in
                SoundProvider.instance.playMenuSelectionSound()
                // TODO: Implement me
            }),
            ButtonCellInfo(title: "Report a bug", action: { [weak self] in
                SoundProvider.instance.playMenuSelectionSound()
                // TODO: Implement me
            }),
            ButtonCellInfo(title: "About Scroggle", action: { [weak self] in
                SoundProvider.instance.playMenuSelectionSound()
                // TODO: Implement me
            })

        ])
    }

}

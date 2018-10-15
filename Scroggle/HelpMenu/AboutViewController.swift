//
//  AboutViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/14/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import Cartography
import UIKit

class AboutViewController: ChalkboardViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "close_normal"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "close_selected"), for: .selected)
        button.addTarget(self, action: #selector(tappedCloseButton(_:)), for: .touchUpInside)
        let title = UILabel()
        title.font = UIFont(name: "Chalkduster", size: 30)
        title.textColor = .white
        title.text = "About"
        title.textAlignment = .center

        contentView.addSubview(button)
        contentView.addSubview(title)

        constrain(contentView, button, title) { (view, button, title) in
            button.width == 40
            button.height == 40
            button.left == view.left + 8
            button.top == view.top + 8
            title.centerY == button.centerY
            title.left == button.right + 8
            title.right == view.right - 56
        }
    }

    class func loadFromStoryBoard() -> AboutViewController {
        return UIStoryboard(name: "Help", bundle: nil)
            .instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        // swiftlint:disable:previous force_cast
    }

}

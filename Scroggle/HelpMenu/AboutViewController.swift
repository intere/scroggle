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

    let webView = UIWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "close_normal"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "close_selected"), for: .selected)
        button.addTarget(self, action: #selector(tappedCloseButton(_:)), for: .touchUpInside)
        let title = UILabel()
        title.font = UIFont(name: "Chalkduster", size: 35)
        title.textColor = .white
        title.text = "About"
        title.textAlignment = .center

        let appInfo = UILabel()
        appInfo.font = UIFont(name: "Chalkduster", size: 25)
        appInfo.textColor = .white
        appInfo.textAlignment = .center
        appInfo.numberOfLines = 0
        let infoText = "Version: \(ConfigurationProvider.instance.appVersion)\n" +
            "Build: \(ConfigurationProvider.instance.appBuildNumber)"
        appInfo.text = infoText

        [button, title, appInfo, webView].forEach {
            contentView.addSubview($0)
        }

        constrain(contentView, button, title, appInfo, webView) { (view, button, title, appInfo, webView) in
            button.width == 40
            button.height == 40
            button.left == view.left + 8
            button.top == view.top + 8

            title.centerY == button.centerY
            title.left == button.right + 8
            title.right == view.right - 56

            appInfo.top == title.bottom + 8
            appInfo.left == view.leftMargin
            appInfo.right == view.rightMargin

            webView.left == view.left
            webView.right == view.right
            webView.top == appInfo.bottom + 8
            webView.bottom == view.bottom
        }

        webView.loadRequest(URLRequest(url: URL(string: "https://intere.github.io/scroggle-support/#/about")!))
    }

    class func loadFromStoryBoard() -> AboutViewController {
        return UIStoryboard(name: "Help", bundle: nil)
            .instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        // swiftlint:disable:previous force_cast
    }

}

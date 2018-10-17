//
//  WebViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/14/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import Cartography
import UIKit

class WebViewController: ChalkboardViewController {

    private var webView: UIWebView!
    var urlString: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        let content = UIView()
        content.backgroundColor = .clear
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "close_normal"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "close_selected"), for: .selected)
        button.addTarget(self, action: #selector(tappedCloseButton(_:)), for: .touchUpInside)
        webView = UIWebView()

        content.addSubview(webView)
        content.addSubview(button)

        constrain(content, button, webView) { (view, button, webView) in
            button.left == view.left + 8
            button.top == view.top + 8
            webView.top == view.top
            webView.left == view.left
            webView.right == view.right
            webView.bottom == view.bottom
        }

        setContentView(content)

        guard let url = URL(string: urlString) else {
            return
        }
        webView.loadRequest(URLRequest(url: url))
    }

    class func loadFromStoryboard(url: String) -> WebViewController {
        let webVC = UIStoryboard(name: "Help", bundle: nil)
            .instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        // swiftlint:disable:previous force_cast

        webVC.urlString = url

        return webVC
    }


}

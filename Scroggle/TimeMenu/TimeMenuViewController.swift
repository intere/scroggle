//
//  TimeMenuViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/9/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

class TimeMenuViewController: MenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func buildMenu() -> MenuInfo? {
        return nil
    }

    override class func loadFromStoryboard() -> MenuViewController {
        return UIStoryboard(name: "Time", bundle: nil).instantiateViewController(withIdentifier: "TimeMenuViewController") as! TimeMenuViewController
    }

}

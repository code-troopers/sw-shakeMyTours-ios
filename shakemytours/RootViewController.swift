//
//  RootViewController.swift
//  shakemytours
//
//  Created by Cedric Gatay on 04/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        performSegueWithIdentifier("showAppSegue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


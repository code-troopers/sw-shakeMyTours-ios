//
//  DataViewController.swift
//  shakemytours
//
//  Created by Cedric Gatay on 04/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }

    override func motionEnded(motion: UIEventSubtype,
        withEvent event: UIEvent?) {
            
            if motion == .MotionShake{
                let vc = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewControllerWithIdentifier("ShakeViewController")
                    as! ShakeViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            super.motionEnded(motion, withEvent: event)
    }

}


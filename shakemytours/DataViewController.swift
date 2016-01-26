//
//  DataViewController.swift
//  shakemytours
//
//  Created by Cedric Gatay on 04/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {
    var pageIndex : Int!
    var city: JsonCity!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cityLabel.text = city.name()
        self.navigationController?.navigationBar.hidden = true
    }

    override func motionEnded(motion: UIEventSubtype,
        withEvent event: UIEvent?) {
            
            if motion == .MotionShake{
                let vc = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewControllerWithIdentifier("LoadingController")
                    as! LoadingController
                
                self.presentViewController(vc, animated: false, completion: nil)
                
            }
            super.motionEnded(motion, withEvent: event)
    }

}


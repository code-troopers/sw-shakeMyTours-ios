//
//  LoadingController.swift
//  shakemytours
//
//  Created by Cedric Gatay on 05/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import Foundation
import UIKit

class LoadingController : UIViewController{
 
    @IBOutlet weak var phonePicture: UIImageView!
    override func viewDidAppear(animated: Bool) {
        shakeView()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(),{
            self.showResults()
        })
    }
    
    func showResults(){
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewControllerWithIdentifier("MainNavigationController")
            as! UINavigationController

        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func shakeView(){
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 200
        shake.autoreverses = true
        
        let fromPoint:CGPoint = CGPointMake(phonePicture.center.x - 5, phonePicture.center.y)
        let fromValue:NSValue = NSValue(CGPoint: fromPoint)
        
        let toPoint:CGPoint = CGPointMake(phonePicture.center.x + 5, phonePicture.center.y)
        let toValue:NSValue = NSValue(CGPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        phonePicture.layer.addAnimation(shake, forKey: "position")
    }
}
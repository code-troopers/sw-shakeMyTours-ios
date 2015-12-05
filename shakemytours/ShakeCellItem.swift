//
//  ShakeCellItem.swift
//  shakemytours
//
//  Created by Cedric Gatay on 05/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import Foundation
import UIKit

class ShakeCellItem : UITableViewCell{
    let images = ["lake.jpg", "musee.jpg", "noel.jpg", "shop.jpg", "vin.jpg"]
    @IBOutlet weak var shakeItem: ShakeItem!
    var place : Place!
    var parent : KeepStatusListener!
    
    func setPlaceInShake(place : Place){
        self.place = place
        if(place.image == nil){
            let bgImage = UIImage(named: images[Int(arc4random_uniform(UInt32(images.count)))])!
            place.image = bgImage
        }

        shakeItem.keepButton.addTarget(self, action: "keepButtonPressed:", forControlEvents: UIControlEvents.TouchDown)
        shakeItem.infoBtn.addTarget(self, action: "infoButtonPressed:", forControlEvents: UIControlEvents.TouchDown)
        shakeItem.updateView(place)
    }
    
    func keepButtonPressed(sender: UIButton?){
        place.keep = !place.keep
        self.shakeItem.keepButton.setImage((self.place.keep ?
            UIImage(named: "check_full") :
            UIImage(named:"check_empty")
            ),
            forState: UIControlState.Normal)
        parent.keepStatusChanged()
    }
    
    func infoButtonPressed(sender: UIButton?){
        parent.fireSegueWithIdentifier("showDetailsSegue", sender:sender)
    }
    
}


protocol KeepStatusListener{
    func keepStatusChanged()
    func fireSegueWithIdentifier(identifier: String, sender: AnyObject?)
}
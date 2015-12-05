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
        shakeItem.updateView(place)
    }
    
    func keepButtonPressed(sender: UIButton){
        place.keep = !place.keep
        shakeItem.keepButton.layer.cornerRadius = shakeItem.keepButton.frame.height / 2
        shakeItem.keepButton.layer.borderWidth = 0
        self.shakeItem.keepButton.layer.backgroundColor = (self.place.keep ? UIColor(hexString:"#40A43F") : UIColor.clearColor()).CGColor
        parent.keepStatusChanged()
    }
    
}


protocol KeepStatusListener{
    func keepStatusChanged()
}
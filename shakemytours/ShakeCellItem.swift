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
    
    @IBOutlet weak var shakeItem: ShakeItem!
    var place : Place!
    
    func setPlaceInShake(place : Place){
        self.place = place
        shakeItem.updateView(place)
        shakeItem.keepButton.addTarget(self, action: "keepButtonPressed:", forControlEvents: UIControlEvents.TouchDown)
    }
    
    func keepButtonPressed(sender: UIButton){
        place.keep = !place.keep
        shakeItem.keepButton.layer.cornerRadius = shakeItem.keepButton.frame.height / 2
        shakeItem.keepButton.layer.borderWidth = 0
        self.shakeItem.keepButton.layer.backgroundColor = (self.place.keep ? UIColor(hexString:"#40A43F") : UIColor.clearColor()).CGColor
    }
    
}

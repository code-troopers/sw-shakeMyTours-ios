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
    
    func setPlaceInShake(place : Place){
        shakeItem.updateView(place)
    }
}
//
//  LocationCellItem.swift
//  shakemytours
//
//  Created by Cedric Gatay on 05/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import Foundation
import UIKit

class LocationCellItem : UITableViewCell{
    @IBOutlet weak var locationItem: LocationItem!
    
    func setPlaceInfo(place: Place){
        locationItem.updateView(place)
    }
}
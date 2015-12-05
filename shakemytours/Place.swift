//
//  Place.swift
//  shakemytours
//
//  Created by Cedric Gatay on 05/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import Foundation
import UIKit

class Place{
    var distance : NSNumber?
    var name : String?
    var type : String?
    var web: String?
    var phone : String?
    var address : String?
    
    var keep = false
    var image : UIImage?
    
    init(name : String, distance : NSNumber, type: String, web: String, phone: String, address: String){
        self.name = name
        self.type = type
        self.distance = distance
        self.address = address
        self.web = web
        self.phone = phone
    }
    
    static func fromJSON(values : NSDictionary) -> Place?{
        if let distance = values["distance"] as? NSNumber,
            let name = values["name"] as? String,
            let type = values["type"] as? String,
            let address = values["address"] as? String,
            let phone = values["phone"] as? String,
            let web = values["web"] as? String {
            return Place(name : name, distance: distance, type: type, web: web, phone: phone, address: address)
        }
        return nil
    }
}
//
//  Place.swift
//  shakemytours
//
//  Created by Cedric Gatay on 05/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import Foundation

class Place{
    var distance : NSNumber?
    var name : String?
    var type : String?
    var keep = false
    
    init(name : String, distance : NSNumber, type: String){
        self.name = name
        self.type = type
        self.distance = distance
    }
    
    static func fromJSON(values : NSDictionary) -> Place?{
        if let distance = values["distance"] as? NSNumber,
        let name = values["name"] as? String,
            let type = values["type"] as? String{
                return Place(name : name, distance: distance, type: type)
        }
        return nil
    }
}
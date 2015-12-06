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
    var name : String?
    var type : String?
    var web: String?
    var phone : String?
    var address : String?
    var lat: Double?
    var lng: Double?
    var imgName : String?
    
    var keep = false
    var image : UIImage?
    var jsonType : JsonType?
    
    init(name : String, type: String, web: String, phone: String, address: String){
        self.name = name
        self.type = type
        self.address = address
        self.web = web
        self.phone = phone
    }
    
    static func fromJSON(values : NSDictionary, jsonType: JsonType) -> Place?{
        if
            let name = values["name"] as? String,
            let type = values["type"] as? String,
            let address = values["address"] as? String,
            let phone = values["tel"] as? String,
            let web = values["site"] as? String,
            let lat = values["lat"] as? Double,
            let lng = values["lgt"] as? Double,
            let img = values["eventType"] as? String
        {
            let p = Place(name : name, type: type, web: web, phone: phone, address: address)
            p.lat = lat
            p.lng = lng
            p.jsonType = jsonType
            if img != ""{
                p.imgName = img
            }
            return p
        }
        return nil
    }
}
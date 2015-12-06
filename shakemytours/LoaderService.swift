//
//  LoaderService.swift
//  shakemytours
//
//  Created by Cedric Gatay on 05/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import Foundation

class LoaderService{
    
    private func loadFromJson(amountToLoad : Int, type: JsonType) -> [Place]?{
        if let path = NSBundle.mainBundle().pathForResource(JsonType.fileName(type), ofType: "json"){
            do{
                let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                if let jsonValues = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSArray {
                    var out = [Place]()
                    for _ in 1...amountToLoad{
                        let randomIndex = Int(arc4random_uniform(UInt32(jsonValues.count)))
                        if let place = jsonValues[randomIndex] as? NSDictionary {
                            if let p = Place.fromJSON(place, jsonType: type){
                                out.append(p)
                            }
                        }
                    }
                    return out
                }
            }catch{
                
            }
        }
        return nil
    }
 
    func loadLocalData(handler:  PlaceHandler){
        if let activities = loadFromJson(2, type: .ACTIVITY),
            let restaurant = loadFromJson(1, type: .RESTAURANT),
            let pmAct = loadFromJson(1, type: .ACTIVITY),
            let night = loadFromJson(1, type: .NIGHT){
                let val = [activities, restaurant, pmAct, night].reduce([], combine: +)
                handler.handlePlaces(val)
        }
    }
    
    func pickOne(jsonType: JsonType) -> Place?{
        return loadFromJson(1, type: jsonType)?[0]
    }
}

protocol PlaceHandler{
    func handlePlaces(places : [Place])
}

enum JsonType {
    case ACTIVITY
    case NIGHT
    case RESTAURANT
    
    static func fileName(type: JsonType) -> String{
        switch type{
        case .ACTIVITY : return "activity"
        case .RESTAURANT : return "restaurant"
        case .NIGHT : return "night"
        }
    }
}
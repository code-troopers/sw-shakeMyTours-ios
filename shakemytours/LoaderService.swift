//
//  LoaderService.swift
//  shakemytours
//
//  Created by Cedric Gatay on 05/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import Foundation

class LoaderService{
    
    private func loadFromJson(amountToLoad : Int, type: JsonType, city: JsonCity) -> [Place]?{
        if let path = NSBundle.mainBundle().pathForResource(city.prefix()+"_"+JsonType.fileName(type), ofType: "json"){
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
            }catch {
                NSLog("An error occured")
            }
        }
        return nil
    }
 
    func loadLocalData(handler:  PlaceHandler, city: JsonCity){
        
        if
            //let bonus = loadFromJson(1, type: .BONUS),
            let amActivity = loadFromJson(1, type: .ACTIVITY, city: city),
            let restaurant = loadFromJson(1, type: .RESTAURANT, city: city),
            let pmAct = loadFromJson(2, type: .ACTIVITY, city: city),
            let night = loadFromJson(1, type: .NIGHT, city: city){
                let val = [
                    //bonus,
                    amActivity, restaurant, pmAct, night].reduce([], combine: +)
                handler.handlePlaces(val)
        }
    }
    
    func pickOne(jsonType: JsonType, city: JsonCity) -> Place?{
        return loadFromJson(1, type: jsonType, city: city)?[0]
    }
}

protocol PlaceHandler{
    func handlePlaces(places : [Place])
}
enum JsonCity{
    case Tours
    case Orleans
    func prefix() -> String{
        switch self{
        case .Orleans: return "orleans"
        case .Tours: return "tours"
        }
    }
}
enum JsonType {
    case ACTIVITY
    case NIGHT
    case RESTAURANT
//    case BONUS
    
    static func fileName(type: JsonType) -> String{
        switch type{
        case .ACTIVITY : return "activity"
        case .RESTAURANT : return "restaurant"
        case .NIGHT : return "night"
        //case .BONUS : return "bonus"
        }
    }
}
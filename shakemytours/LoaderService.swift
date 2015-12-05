//
//  LoaderService.swift
//  shakemytours
//
//  Created by Cedric Gatay on 05/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import Foundation

class LoaderService{
    
    private func loadFromJson(amountToLoad : Int) -> [Place]?{
        if let path = NSBundle.mainBundle().pathForResource("mockdata", ofType: "json"){
            do{
                let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                if let jsonValues = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSArray {
                    var out = [Place]()
                    for _ in 1...amountToLoad{
                        let randomIndex = Int(arc4random_uniform(UInt32(jsonValues.count)))
                        if let place = jsonValues[randomIndex] as? NSDictionary {
                            if let p = Place.fromJSON(place){
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
 
    func loadLocalData(amountToLoad : Int, handler:  PlaceHandler){
        if let places = loadFromJson(amountToLoad){
            handler.handlePlaces(places)
        }
    }
    
    func pickOne() -> Place?{
        return loadFromJson(1)?[0]
    }
}

protocol PlaceHandler{
    func handlePlaces(places : [Place])
}
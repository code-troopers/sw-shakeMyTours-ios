//
//  ShakeItem.swift
//  shakemytours
//
//  Created by Cedric Gatay on 05/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import Foundation
import UIKit

class LocationItem: UIView{

    @IBOutlet weak var placeName : UILabel!
    @IBOutlet weak var pinLegend: UIView!
    // Our custom view from the XIB file
    var view: UIView!
    
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        pinLegend.layer.cornerRadius = pinLegend.frame.height / 2
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LocationItem", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    func updateView(placeWithColors : PlaceWithColors){
        placeName!.text = placeWithColors.place.name
        pinLegend.layer.backgroundColor = placeWithColors.pinColor.CGColor
    }
}
//
//  DetailViewController.swift
//  shakemytours
//
//  Created by Cedric Gatay on 05/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController : UIViewController{
    var place : Place?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var webLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadValues()
    }
    
    func loadValues(){
        self.title = place?.name
        self.addressLabel.text = place?.address
        self.phoneLabel.text = place?.phone
        self.webLabel.userInteractionEnabled = true
        self.webLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "userClickedWeb:"))
        self.imageView.image = place?.image
    }
    
    func userClickedWeb(sender: AnyObject){
        if let checkURL = NSURL(string: place!.web!) {
          UIApplication.sharedApplication().openURL(checkURL)
        }
    }
    
}
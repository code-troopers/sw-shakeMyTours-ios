//
//  ShakeViewController.swift
//  shakemytours
//
//  Created by Cedric Gatay on 05/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import Foundation
import UIKit

class ShakeViewController : UIViewController{
    @IBOutlet weak var firstItem: ShakeItem!
    @IBOutlet weak var secondItem: ShakeItem!
    @IBOutlet weak var thirdItem: ShakeItem!
    @IBOutlet weak var fourthItem: ShakeItem!
    @IBOutlet weak var fifthItem: ShakeItem!
    override func viewDidLoad() {
        self.navigationController?.navigationBar.hidden = false
        if let loaded = LoaderService().loadLocalData(5){
            self.firstItem.updateView(loaded[0])
            self.secondItem.updateView(loaded[1])
            self.thirdItem.updateView(loaded[2])
            self.fourthItem.updateView(loaded[3])
            self.fifthItem.updateView(loaded[4])
        }
    }
    
    
}
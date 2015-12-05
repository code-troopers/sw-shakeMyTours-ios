//
//  ActivityDetailController.swift
//  shakemytours
//
//  Created by Cedric Gatay on 05/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import Foundation
import UIKit

class ActivityDetailController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    var tableData : [Place]?
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath) as! LocationCellItem
        cell.setPlaceInfo(tableData![indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData?.count ?? 0
    }
}
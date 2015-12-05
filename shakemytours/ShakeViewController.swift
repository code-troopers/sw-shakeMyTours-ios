//
//  ShakeViewController.swift
//  shakemytours
//
//  Created by Cedric Gatay on 05/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import Foundation
import UIKit

class ShakeViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var tableData : [Place]?
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.hidden = false
        LoaderService().loadLocalData(5, handler:self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShakeCell", forIndexPath: indexPath) as! ShakeCellItem
        cell.setPlaceInShake(tableData![indexPath.row])
        return cell
    }
    
}

extension ShakeViewController : PlaceHandler{
    
    func handlePlaces(places: [Place]) {
        tableData = places
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }

}
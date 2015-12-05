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
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    var tableData : [Place]?
    let loaderService = LoaderService()
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.hidden = false
        loadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShakeCell", forIndexPath: indexPath) as! ShakeCellItem
        let place = tableData![indexPath.row]
        cell.parent = self
        cell.setPlaceInShake(place)
        return cell
    }
    
    
    func refreshTableView(){
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func loadData(){
        loaderService.loadLocalData(5, handler:self)
    }
}
/* Data loader */
extension ShakeViewController : PlaceHandler{
    
    func handlePlaces(places: [Place]) {
        if var currentData = tableData{
            for (i,p) in places.enumerate(){
                if !currentData[i].keep{
                    currentData[i] = p
                }
            }
            tableData = currentData
        }else{
            tableData = places
        }

    }

}
/* Shake handler */
extension ShakeViewController{
    override func motionEnded(motion: UIEventSubtype,
        withEvent event: UIEvent?) {
            
            if motion == .MotionShake{
                self.loadData()
                self.refreshTableView()
            }
    }
}

/* Table actions */
extension ShakeViewController{
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { action, index in
            self.tableData![index.row] = self.loaderService.pickOne()!
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.tableView.reloadData()
                if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ShakeCellItem{
                    cell.alpha = 0
                    cell.fadeIn(0.5)
                }
            })
            self.tableView.setEditing(false, animated: true)
            CATransaction.commit()
            tableView.cellForRowAtIndexPath(indexPath)?.fadeOut()
        }
        return [delete]
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
}


extension ShakeViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? ShakeCellItem where segue.identifier == "showDetailsSegue",
           let vc = segue.destinationViewController as? DetailViewController {
            vc.place = cell.place
        }
        if let vc = segue.destinationViewController as? ActivityDetailController where segue.identifier == "showActivitySegue"{
            vc.tableData = self.tableData?.filter({$0.keep})
        }
    }
}

extension ShakeViewController : KeepStatusListener{
    func keepStatusChanged(){
        self.nextBtn.enabled = self.tableData?.filter({$0.keep}).count > 0
    }
}
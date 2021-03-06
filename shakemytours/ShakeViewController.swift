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
    var blockReload = false
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.hidden = false
    }
    override func viewWillAppear(animated: Bool) {
        if !blockReload{
            loadData()
            refreshTableView()
        }
        self.title = "Votre shake à \(AppDelegate.get().city.name())"
    }
    
    @IBAction func onChangeCity(sender: AnyObject) {
        AppDelegate.get().city = AppDelegate.get().city.cycle()
//        self.title = "Votre shake à \(AppDelegate.get().city.name())"
        tableData = nil
        performSegueWithIdentifier("showLoadingModalSegue", sender: self)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 8
        }
        return 12
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShakeCell", forIndexPath: indexPath) as! ShakeCellItem
        let place = tableData![indexPath.section]
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
        loaderService.loadLocalData(self)
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
                performSegueWithIdentifier("showLoadingModalSegue", sender: self)
            }
    }
}

/* Table actions */
extension ShakeViewController{
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { action, index in
            self.tableData![index.section] = self.loaderService.pickOne(self.tableData![index.section].jsonType!)!
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.tableView.reloadRowsAtIndexPaths([index], withRowAnimation: .Automatic)
            })
            self.tableView.setEditing(false, animated: true)
            CATransaction.commit()
         
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ShakeCellItem
        cell.keepButtonPressed(nil)
    }
}


extension ShakeViewController {
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "showDetailsSegue" && sender?.tag != 462{
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if //UGLY HACK :), will break if layout is changed
            let cell = sender?.superview??.superview?.superview?.superview?.superview as? ShakeCellItem
            where segue.identifier == "showDetailsSegue",
           let vc = segue.destinationViewController as? DetailViewController {
            vc.place = cell.place
            blockReload = true
        }
        if let vc = segue.destinationViewController as? ActivityDetailController where segue.identifier == "showActivitySegue"{
            vc.tableData = PlaceWithColors.hydrate(self.tableData?.filter({$0.keep}))
        }
        if let vc = segue.destinationViewController as? LoadingController where segue.identifier == "showLoadingModalSegue" {
            vc.dismiss = true
        }
    }
}

extension ShakeViewController : KeepStatusListener{
    func keepStatusChanged(){
        self.nextBtn.enabled = self.tableData?.filter({$0.keep}).count > 0
    }
    func fireSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        self.performSegueWithIdentifier(identifier, sender: sender)
    }
}
//
//  ActivityDetailController.swift
//  shakemytours
//
//  Created by Cedric Gatay on 05/12/15.
//  Copyright © 2015 ShakeMyTours. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ActivityDetailController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    let fakeCoords = [
        (47.366353, 0.677934),
        (47.412582, 0.68545),
        (47.421142, 0.700384)
        ]
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var tableData : [Place]?
    
    override func viewDidLoad() {
        drawItinerary()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath) as! LocationCellItem
        cell.setPlaceInfo(tableData![indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData?.count ?? 0
    }
    
    @IBAction func shareButtonClick(sender: UIBarButtonItem) {
        let names = tableData!.map({$0.name!}).joinWithSeparator(" → ")
        let textToShare = "This is a great shake (\(names)), SHAKE it out !"
        
        if let myWebsite = NSURL(string: "http://shakemytours.com/"){
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    func drawItinerary(){
        var coords2D = tableData!
            .filter({$0.lat != nil && $0.lng != nil})
            .map({CLLocationCoordinate2D(latitude: $0.lat!, longitude: $0.lng!)})
        coords2D
            .map({
                let annot = MKPointAnnotation()
                annot.coordinate = $0
                return annot
            })
            .forEach({annot -> Void in
            mapView.addAnnotation(annot)
        })
        let lastIndex = coords2D.count - 2
        if lastIndex > 0{
            for i in 0...lastIndex{
                drawRoute(start: coords2D[i], arrival: coords2D[i+1])
            }
        }
        let centerRegion = centerMapOnRegion(&coords2D)
        dispatch_async(dispatch_get_main_queue(), {
            UIView.animateWithDuration(2, animations: {
                () -> Void in
                let rect = MKCoordinateRegionForMapRect(centerRegion)
                self.mapView.setRegion( MKCoordinateRegionMake(rect.center,
                    MKCoordinateSpan(latitudeDelta: rect.span.latitudeDelta + 0.05,
                        longitudeDelta: rect.span.longitudeDelta+0.05)
                    ),
                    animated: true)
            })
        })
    }
    
    func centerMapOnRegion(inout coords : [CLLocationCoordinate2D]) -> MKMapRect{
        let geodesic = MKGeodesicPolyline(coordinates: &coords[0], count: coords.count)
        
        var regionRect = geodesic.boundingMapRect
        let wPadding = regionRect.size.width * 0.25
        let hPadding = regionRect.size.height * 0.25
        
        //Add padding to the region
        regionRect.size.width += wPadding
        regionRect.size.height += hPadding
        
        //Center the region on the line
        regionRect.origin.x -= wPadding / 2
        regionRect.origin.y -= hPadding / 2
        return regionRect
    }
}

extension ActivityDetailController : MKMapViewDelegate{
    
    func drawRoute(start start : CLLocationCoordinate2D, arrival : CLLocationCoordinate2D){
        let dirRequest = MKDirectionsRequest()
        let startPM = MKPlacemark(coordinate: start, addressDictionary: nil)
        let endPM = MKPlacemark(coordinate: arrival, addressDictionary: nil)
        dirRequest.source = MKMapItem(placemark: startPM)
        dirRequest.destination = MKMapItem(placemark: endPM)

        MKDirections.init(request: dirRequest).calculateDirectionsWithCompletionHandler({(response, error) -> Void in
            if let polyline = response?.routes.first?.polyline{
                self.mapView.addOverlay(polyline)
            }
        })
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer{
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if overlay is MKPolyline {
            polylineRenderer.strokeColor = AppDelegate.appColor
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }

}
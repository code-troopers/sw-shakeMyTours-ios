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
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var tableData : [PlaceWithColors]?
    var selectedPlace : Place?
    
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
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let center = tableData![indexPath.row].location{
            mapView.setCenterCoordinate(center, animated: true)
        }
    }

    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        selectedPlace = tableData![indexPath.row].place
        performSegueWithIdentifier("showDetailsSegue", sender: self)
    }
    
    @IBAction func shareButtonClick(sender: UIBarButtonItem) {
        let names = tableData!.map({$0.place.name!}).joinWithSeparator(" → ")
        let textToShare = "This is a great shake (\(names)), SHAKE it out !"
        
        if let myWebsite = NSURL(string: "http://shakemytours.com/"){
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? DetailViewController
            where segue.identifier == "showDetailsSegue"{
                vc.place = selectedPlace
        }
    }
    
    func drawItinerary(){
        tableData!
            .filter({$0.location != nil})
            .map({
                let annot = PlaceAnnotation()
                annot.coordinate = $0.location!
                annot.pinColor = $0.pinColor
                annot.title = $0.place.name
                return annot
            })
            .forEach({annot -> Void in
            mapView.addAnnotation(annot)
        })
        
        var coords2D = tableData!
            .filter({$0.location != nil})
            .map({$0.location!})
        let lastIndex = coords2D.count - 2
        if lastIndex >= 0{
            for i in 0...lastIndex{
                drawRoute(start: coords2D[i], arrival: coords2D[i+1])
            }
        }
        let centerRegion = centerMapOnRegion(&coords2D)
        dispatch_async(dispatch_get_main_queue(), {
            UIView.animateWithDuration(2, animations: {
                () -> Void in
                let rect = MKCoordinateRegionForMapRect(centerRegion)
                let centerCoord = coords2D.count == 1 ? coords2D[0] : rect.center
                self.mapView.setRegion( MKCoordinateRegionMake(centerCoord,
                    MKCoordinateSpan(latitudeDelta: rect.span.latitudeDelta,
                        longitudeDelta: rect.span.longitudeDelta)
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
                dispatch_async(dispatch_get_main_queue(), {
                    self.mapView.addOverlay(polyline)
                })
            }
        })
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? PlaceAnnotation  {
            let identifier = "placePin"
            var view = MKPinAnnotationView()
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as! MKPinAnnotationView!{
                view = dequeuedView
                view.annotation = annotation
            } else  {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.pinTintColor = annotation.pinColor
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer{
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if overlay is MKPolyline {
            polylineRenderer.strokeColor = AppDelegate.appColor
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.delegate = nil
    }

}

class PlaceWithColors {
    var pinColor : UIColor
    var place: Place
    var location : CLLocationCoordinate2D?
    
    init(place: Place, pinColor : UIColor){
        self.place = place
        self.pinColor = pinColor
        if let lat = place.lat,
            let lng = place.lng{
                self.location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        }
    }
    
    static func hydrate(optPlaces: [Place]?) -> [PlaceWithColors]?{
        if let places = optPlaces {
            var colors = [UIColor.greenColor(), UIColor.redColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.purpleColor()]
            var out = [PlaceWithColors]()
            for (i,p) in places.enumerate(){
                out.append(PlaceWithColors(place: p, pinColor: colors[i % colors.count]))
            }
            return out
        }
        return nil
    }
}

class PlaceAnnotation : MKPointAnnotation{
    var pinColor : UIColor!
}
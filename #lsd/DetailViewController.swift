//
//  DetailViewController.swift
//  XDLocationManager
//
//  Created by Morgan Collino on 3/1/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var startStopTracking: UISegmentedControl!
    
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup our Location Manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
//        Setup our Map View
        theMap?.delegate = self
        theMap?.mapType = MKMapType.Hybrid
        theMap?.showsUserLocation = true
        
        startStopTracking.selectedSegmentIndex = -1
    }
        
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch startStopTracking.selectedSegmentIndex
        {
        case 0:
            manager.startUpdatingLocation()
        case 1:
            manager.stopUpdatingLocation()
        default:
            break;
        }

    }
    
    func stopTracking() {
            manager.stopUpdatingLocation()
            myLocations = []
    }
        
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
            //theLabel.text = "\(locations[0])"
        myLocations.append(locations[0] as CLLocation)
        
        let spanX = 0.007
        let spanY = 0.007
        var newRegion = MKCoordinateRegion(center: theMap!.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        theMap!.setRegion(newRegion, animated: true)
        
        if (myLocations.count > 1){
            var sourceIndex = myLocations.count - 1
            var destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            var polyline = MKPolyline(coordinates: &a, count: a.count)
            theMap!.addOverlay(polyline)
        }
    }
        
        
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 6
            return polylineRenderer
        }
        return nil
    }
}
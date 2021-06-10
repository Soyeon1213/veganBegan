//
//  MapViewController.swift
//  veganBegan
//
//  Created by RelMac User Exercise3 on 2021/06/02.
//  Copyright © 2021 Release. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MTMapViewDelegate {
    var mapView: MTMapView?
    var mapPoint: MTMapPoint?
    var poiItem1: MTMapPOIItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        mapView = MTMapView(frame: self.view.bounds)
        
        if let mapView = mapView{
            mapView.delegate = self
            mapView.baseMapType = .standard
            
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:37.573083, longitude: 126.983168)), zoomLevel: 4, animated: true)
           
            mapView.showCurrentLocationMarker = true
            mapView.currentLocationTrackingMode = .onWithoutHeading
            
            self.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude:37.573883, longitude: 126.983168))
            
            poiItem1 = MTMapPOIItem()
            poiItem1?.markerType = MTMapPOIItemMarkerType.redPin
            poiItem1?.mapPoint = mapPoint
            poiItem1?.itemName = "veganBegan!"
           
            mapView.add(poiItem1)
       
            self.view.addSubview(mapView)
            
            // test
            print(DatabaseManager.sortbyDistance(latitude: 37.5738835, longitude: 126.9831643).count)
            //print(DatabaseManager.sortbyFoodCategory(category: "한식").count)
            DatabaseManager.updateRating(id: 0, rating: 2)
            DatabaseManager.updateRating(id: 1, rating: 3)
            DatabaseManager.updateRating(id: 2, rating: 4)
            DatabaseManager.updateRating(id: 3, rating: 5)
            print(DatabaseManager.sortbyRating().count)
            print(DatabaseManager.sortbyRelevance(type: "락토"))
        }
    }
    
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy){
        let currentLocation = location?.mapPointGeo()
        if let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude{ print("MTMapView update Current Location (\(latitude), \(longitude))")}
            
        }
    
    func mapView(_ mapView: MTMapView?, updateDeviceHeading headingAngle: MTMapRotationAngle) {
        print("MTMapView update Device Heading (\(headingAngle)) degrees")
    }
}

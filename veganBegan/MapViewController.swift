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
import CoreLocation


class MapViewController: UIViewController, MTMapViewDelegate {
    var mapView: MTMapView?
    var mapPoint: MTMapPoint?
    var poiItem1: MTMapPOIItem?
    var list = [MTMapPOIItem] ()
    // test
    var DBop: DatabaseManager = DatabaseManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView = MTMapView(frame: self.view.bounds)
        mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude:37.573083, longitude: 126.983168))
        mapView?.setMapCenter(mapPoint, animated: true)
        
        if let mapView = mapView{
            mapView.delegate = self
            mapView.baseMapType = .standard
            
        //    mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:37.573083, longitude: 126.983168)), animated: true)
           
          //  mapView.showCurrentLocationMarker = true
          //  mapView.currentLocationTrackingMode = .onWithoutHeading
            
            //self.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude:37.573083, longitude: 126.983168))
            
            list.append(poiItem(name: "restaurant2", latitude: 37.573772, longitude: 126.983170))
            list.append(poiItem(name: "veganBegan!", latitude: 37.573883, longitude: 126.983169))
            print(list.count)
         /*
            poiItem1 = MTMapPOIItem()
            poiItem1?.markerType = MTMapPOIItemMarkerType.redPin
            poiItem1?.mapPoint = mapPoint
            poiItem1?.itemName = "veganBegan!"
           */
            mapView.addPOIItems(list)
            mapView.fitAreaToShowAllPOIItems()
            
            self.view.insertSubview(mapView, at: 0)
            self.view.sendSubviewToBack(mapView)
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
    
    func poiItem(name: String, latitude: Double, longitude: Double) -> MTMapPOIItem{
        let item = MTMapPOIItem()
        item.itemName = name
        item.markerType = .redPin
        item.markerSelectedType = .redPin
        item.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
       // item.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)
        
        return item
        
    }
 
}


//
//  MapViewController.swift
//  HaTienEmployeeLast
//
//  Created by Apple on 10/5/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

protocol MapViewControllerDelegate: class {
    func didPickLocation(lat: Double, lng: Double)
}

class MapViewController: BaseViewController {
    
    var mapView = GMSMapView()
        
    let marker = GMSMarker()
    
    var isMarkerCreated = false
    
    weak var delegate: MapViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tìm vị trí"
        self.setupDoneButton()
        self.configMapView()
    }
    
    fileprivate func setupDoneButton() {
        let button = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(doneAction(_:)))
        self.navigationItem.rightBarButtonItem = button
    }
    @objc func doneAction(_: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    fileprivate func configMapView() {
        /// Camera
        self.mapView = GMSMapView()
        let camera = GMSCameraPosition.camera(withLatitude: MyLocation.lat, longitude: MyLocation.long, zoom: 15.0)
        let mapViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
        self.mapView = GMSMapView.map(withFrame: mapViewFrame, camera: camera)
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.compassButton = true
        self.mapView.settings.zoomGestures = true
        self.mapView.delegate = self
        self.view.addSubview(self.mapView)
    }
    
    // Mark: Create Marker
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.map = mapView
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(" did tapped Lat: \(coordinate.latitude)")
        print(" did tapped Long: \(coordinate.longitude)")
        
        if !isMarkerCreated {
            self.createMarker(titleMarker: "Vị trí", iconMarker: UIImage(named: "location-pin")!, latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.isMarkerCreated = true
        } else {
            self.marker.position = coordinate
        }
        self.delegate.didPickLocation(lat: coordinate.latitude, lng: coordinate.longitude)
        
    }
}

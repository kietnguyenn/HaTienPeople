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
import Alamofire
import SwiftyJSON

protocol MapViewControllerDelegate: class {
    func didPickLocation(coordinate: CLLocationCoordinate2D)
}

class MapViewController: BaseViewController {
    
    var mapView = GMSMapView()
        
    let marker = GMSMarker()
    
    var isMarkerCreated = false
    
    weak var delegate: MapViewControllerDelegate!
    
    @IBAction func doneButtonTapped(_:UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tìm vị trí"
        self.setupDoneButton()
        self.configMapView()
        self.setupSearchController()
    }
    
    fileprivate func setupDoneButton() {
        let button = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(doneAction(_:)))
        self.navigationItem.leftBarButtonItem = button
    }
    @objc func doneAction(_: UIBarButtonItem) {
        self.delegate.didPickLocation(coordinate: marker.position)
        self.dismiss(animated: true)
    }
    
    fileprivate func configMapView() {
        /// Camera
        self.mapView = GMSMapView()
        let camera = GMSCameraPosition.camera(withLatitude: CurrentLocation.latitude, longitude: CurrentLocation.longitude, zoom: 10.0)
        let mapViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.mapView = GMSMapView.map(withFrame: mapViewFrame, camera: camera)
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.compassButton = true
        self.mapView.settings.zoomGestures = true
        self.mapView.delegate = self
        self.view.addSubview(self.mapView)
    }
    
    // Setup camera view
    fileprivate func setupCamera(lat: Double, lng: Double) {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 15.0)
        self.mapView.camera = camera
    }
    
    // Mark: Create Marker
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.map = mapView
        marker.appearAnimation = .pop
        marker.snippet = ""
    }
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    fileprivate func setupSearchController() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self

        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.searchTextField.backgroundColor = .white
        searchController?.searchBar.searchTextField.tintColor = .black

        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar

        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true

        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    // MARK: Get address of location
    fileprivate func setAddress(of location: CLLocationCoordinate2D) {
        requestNonTokenResponseString(urlString: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(location.latitude),\(location.longitude)&key=\(GMSApiKey.garageKey)",
                                      method: .post,
                                      params: nil,
                                      encoding: URLEncoding.default) { (response) in
            guard let jsonString = response.value,
                  let jsonData = jsonString.data(using: .utf8),
                  let resultCoordinates = try? JSONDecoder().decode(CoordinateResult.self, from: jsonData)
                  else { return }
            let formattedAddress = resultCoordinates.results[0].formattedAddress
            guard let searchTextField = self.searchController?.searchBar.searchTextField else { return }
            searchTextField.text = formattedAddress
        }
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        print(" did tapped Lat: \(coordinate.latitude)")
//        print(" did tapped Long: \(coordinate.longitude)")
        self.placeMarkerOnMap(coordinate: coordinate, title: "")
    }
    
    // Place marker on map
    func placeMarkerOnMap(coordinate: CLLocationCoordinate2D, title: String) {
        self.setupCamera(lat: coordinate.latitude, lng: coordinate.longitude)
        if !isMarkerCreated {
            self.createMarker(titleMarker: title, iconMarker: UIImage(named: "location-pin")!, latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.isMarkerCreated = true
        } else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            self.marker.position = coordinate
            CATransaction.commit()
        }
        self.setAddress(of: marker.position)
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        self.placeMarkerOnMap(coordinate: CurrentLocation, title: "Current location")
        return true
    }
    
}

extension MapViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        
        guard let placeName = place.name,
            let placeFormattedAddress = place.formattedAddress,
              let placeAddressComponents = place.addressComponents
//              let placeAttribution = place.attributions
        else { return }
        print("Place name: \(placeName)")
        print("Place placeAddressComponents: \(placeAddressComponents)")
        print("Place placeFormattedAddress: \(placeFormattedAddress)")
        print("Lat: \(place.coordinate.latitude), lng: \(place.coordinate.longitude)")
        for component in placeAddressComponents {
            print(component)
        }
        self.placeMarkerOnMap(coordinate: place.coordinate, title: placeName)
        
    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
      print("Error: ", error.localizedDescription)
    }
    
    func customFormattedAddressIntoPlusCode(_ formattedAddress: String) -> String {
        let plusCode = formattedAddress.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        print("plusCode: " + plusCode)
        return plusCode
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//      UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//      UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

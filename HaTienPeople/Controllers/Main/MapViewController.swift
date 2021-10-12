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
import SVProgressHUD

protocol MapViewControllerDelegate: class {
    func didPickLocation(coordinate: CLLocationCoordinate2D, address: String)
}

class MapViewController: BaseViewController {
    
    var mapView = GMSMapView()
    
    let marker = GMSMarker()
    
    var isMarkerCreated = false
    
    weak var delegate: MapViewControllerDelegate!
    
    var resultSearchController: UISearchController? = nil
    
    @IBAction func doneButtonTapped(_:UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tìm vị trí"
        self.setupDoneButton()
        self.setupSearchController()
        self.configMapView()
    }
    
    fileprivate func setupSearchController() {
        // .. Search Table
        guard let locationSearchTable = self.storyboard?.instantiateViewController(withIdentifier: "LocationsTableViewController") as? LocationsTableViewController else { return }
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = (locationSearchTable as UISearchResultsUpdating)
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        // .. Search bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.searchController = resultSearchController

        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    fileprivate func setupDoneButton() {
        let button = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(doneAction(_:)))
        self.navigationItem.leftBarButtonItem = button
    }
    @objc func doneAction(_: UIBarButtonItem) {
        guard let address = self.resultSearchController?.searchBar.text else { return }
        self.delegate.didPickLocation(coordinate: marker.position, address: address)
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
        self.placeMarkerOnMap(coordinate: CurrentLocation, title: "Current location")
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
    
//    fileprivate func setupSearchController() {
//        resultsViewController = GMSAutocompleteResultsViewController()
//        resultsViewController?.delegate = self
//
//        searchController = UISearchController(searchResultsController: resultsViewController)
//        searchController?.searchResultsUpdater = resultsViewController
//        if #available(iOS 13.0, *) {
//            searchController?.searchBar.searchTextField.backgroundColor = .white
//            searchController?.searchBar.searchTextField.tintColor = .black
//        } else {
//            // Fallback on earlier versions
//
//        }
//
//        // Put the search bar in the navigation bar.
//        searchController?.searchBar.sizeToFit()
//        navigationItem.titleView = searchController?.searchBar
//
//        // When UISearchController presents the results view, present it in
//        // this view controller, not one further up the chain.
//        definesPresentationContext = true
//
//        // Prevent the navigation bar from being hidden when searching.
//        searchController?.hidesNavigationBarDuringPresentation = false
//    }
    
    // MARK: Get address of location
//    fileprivate func setAddress(of location: CLLocationCoordinate2D) {
//        requestNonTokenResponseString(urlString: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(location.latitude),\(location.longitude)&key=\(GMSApiKey.iosKey)",
//                                      method: .post,
//                                      params: nil,
//                                      encoding: URLEncoding.default) { (response) in
//            guard let jsonString = response.value,
//                  let jsonData = jsonString.data(using: .utf8),
//                  let resultCoordinates = try? JSONDecoder().decode(CoordinateResult.self, from: jsonData)
//            else { return }
//            if resultCoordinates.results.count > 0 {
//                let formattedAddress = resultCoordinates.results[0].formattedAddress
//                if #available(iOS 13.0, *) {
//                    guard let searchTextField = self.resultSearchController?.searchBar.searchTextField else { return }
//                    searchTextField.text = formattedAddress
//                } else {
//                    // Fallback on earlier versions
//                    guard let textField = self.resultSearchController?.searchBar.value(forKey: "searchField") as? UITextField else { return }
//                    textField.text = formattedAddress
//                }
//            }
//            
//        }
//    }
//    
    // New api to get address with location
    // REVERSE GEOCODING (location -> address)
    fileprivate func getAddress(with location: CLLocationCoordinate2D) {
        requestNonTokenResponseString(urlString: "https://rsapi.goong.io/Geocode?latlng=\(location.latitude),%20\(location.longitude)&api_key=\(MapBoxKey.apiKey)",
                                      method: .get,
                                      params: nil,
                                      encoding: URLEncoding.default) { (response) in
            guard let jsonString = response.value,
                  let jsonData = jsonString.data(using: .utf8),
                  let geocodingResult = try? JSONDecoder().decode(GeoCoding.self, from: jsonData),
                  let results = geocodingResult.results
            else { return }
            if results.count > 0 {
                guard let address = results[0].formattedAddress else { return }
                if #available(iOS 13.0, *) {
                    guard let searchTextField = self.resultSearchController?.searchBar.searchTextField else { return }
                    searchTextField.text = address
                } else {
                    // Fallback on earlier versions
                    guard let textField = self.resultSearchController?.searchBar.value(forKey: "searchField") as? UITextField else { return }
                    textField.text = address
                }
            }
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
    func placeMarkerOnMap(coordinate: CLLocationCoordinate2D, title: String, getAddress: Bool = true) {
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
//        self.setAddress(of: marker.position)
        if getAddress {
            self.getAddress(with: marker.position)
        }
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

extension MapViewController : LocationsTableViewControllerDelegate {
    func didSelect(_ prediction: Prediction) {
        guard let placeId = prediction.placeID,
              let mainText = prediction.structuredFormatting?.mainText,
              let secondaryText = prediction.structuredFormatting?.secondaryText
        else  { return }
        self.resultSearchController?.searchBar.text = mainText + " " + secondaryText
        self.getPlaceDetails(by: placeId)
    }
    
    // GET PLACE DETAILS BY ID
    fileprivate func getPlaceDetails(by placeId: String) {
        let param : Parameters = ["place_id": placeId,
                                  "api_key": MapBoxKey.apiKey]
        requestNonTokenResponseString(urlString: "https://rsapi.goong.io/Place/Detail",
                                      method: .get,
                                      params: param,
                                      encoding: URLEncoding.default,
                                      headers: nil) { response in
            guard let jsonString = response.value,
                  let jsonData = jsonString.data(using: .utf8),
                  let placeDetail = try? JSONDecoder().decode(PlaceDetail.self, from: jsonData),
                  let location = placeDetail.result?.geometry?.location,
                  let lat = location.lat,
                  let lng = location.lng,
                  let placeName = placeDetail.result?.name
            else { return }
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            self.placeMarkerOnMap(coordinate: coordinate, title: placeName, getAddress: false)
        }
    }
}

// MARK: - Location search table view controller
class LocationsTableViewController: UITableViewController{
    var matchingItems = [Prediction]()
    var mapView: GMSMapView? = nil
    var handleMapSearchDelegate: LocationsTableViewControllerDelegate? = nil

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row]
        cell.textLabel?.text = selectedItem.predictionDescription
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row]
        self.handleMapSearchDelegate?.didSelect(selectedItem)
        self.dismiss(animated: true, completion: nil)
    }
}

extension LocationsTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchBarText = searchController.searchBar.text else { return }
//        let formatedSearchBarText = searchBarText.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: "https://rsapi.goong.io/Place/AutoComplete")
        else { return }
        let param : Parameters = ["api_key" : MapBoxKey.apiKey,
                                  "input" : searchBarText,
                                  "radius": 2000,
                                  "country": "VN",
                                  "language": "vi"]
        Alamofire.request(url,
                          method: .get,
                          parameters: param,
                          encoding: URLEncoding.default,
                          headers: nil).responseString { response in
            guard let jsonString = response.value,
                  let jsonData = jsonString.data(using: .utf8),
                  let result = try? JSONDecoder().decode(LocationsResult.self, from: jsonData),
                  let predictions = result.predictions
            else { return }
            self.matchingItems = predictions
            self.tableView.reloadData()
        }
    }
}

protocol LocationsTableViewControllerDelegate {
    func didSelect(_ prediction: Prediction)
}

//
//  EventPostingViewController.swift
//  HaTienEmployeeLast
//
//  Created by MacBook on 10/2/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import Alamofire
import SwiftyJSON
import CoreLocation
import Photos
import PhotosUI
import GooglePlaces
import SwiftSignalRClient

class EventPostingViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var eventTypeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var coordinatesLabel: UILabel!
//    @IBOutlet weak var scrollViewBackgroundImageView: UIImageView!
    
    @IBAction func showMap(_: UIButton) {
        let vc = MyStoryboard.main.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.delegate = self
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        //
        //        let vc = PlaceSearchingViewController()
        //        let nav = BaseNavigationController(rootViewController: vc)
        //        nav.modalPresentationStyle = .fullScreen
        //        self.present(nav, animated: true, completion: nil)
        
        //            self.presentAutocompleteController()
    }
    
    @IBAction func post(_: UIButton) {
        self.postEvent()
    }
    
    @IBAction func selectImage(_: UIButton) {
        let vc = MyStoryboard.main.instantiateViewController(withIdentifier: "ImagesSelectingViewController") as! ImagesSelectingViewController
        vc.delegate = self
        vc.imageList = self.selectedImages
        present(vc, animated: true)
    }
    
    @IBAction func showDropdown(_: UIButton) {
        self.dropdown.show()
    }
    
    var selectedImages = [UIImage]() {
        didSet {
            print("Images: \(selectedImages.count)")
            setup(scrollView: self.scrollView)
        }
    }
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var eventTypes = [EventType]() {
        didSet {
            print(eventTypes.count)
            Constant.eventTypes = self.eventTypes
            self.setupDropdown()
        }
    }
    
    var selectedEventType: EventType?
    
    var selectedCoordinates = CLLocationCoordinate2D(latitude: CurrentLocation.latitude, longitude: CurrentLocation.longitude) {
        didSet {
            self.getAddress(of: selectedCoordinates)
            coordinatesLabel.text = "Lat: \(selectedCoordinates.latitude), lng: \(selectedCoordinates.longitude)"
        }
    }
    
    var dropdown = DropDown()
    let scrollviewBackground = UIImage(named: "scroll-view-background")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkCoreLocationPermission()
        self.getEventTypes()
        self.scrollView.delegate = self
        self.title = Constant.title.eventCreating
        self.showBackButton()
        self.navigationController?.navigationBar.isHidden = false
    }

    
    func setup(scrollView: UIScrollView) {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.isPagingEnabled = true
        
        for index in 0..<selectedImages.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imageView = UIImageView(frame: frame)
            imageView.contentMode = .scaleAspectFit
            imageView.image = selectedImages[index]
            self.scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(selectedImages.count), height: scrollView.frame.size.height)
        self.pageControl.numberOfPages = selectedImages.count
    }
    
    
    fileprivate func setupDropdown() {
        self.dropdown.cellHeight = 50.0
        let names = self.eventTypes.map { (eventType) -> String in
            return eventType.name
        }
        self.dropdown.dataSource = names
        self.dropdown.anchorView = self.eventTypeTextField.plainView
        self.dropdown.direction = .bottom
        self.dropdown.dismissMode = .onTap
        self.dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.selectedEventType = self.eventTypes[index]
            self.eventTypeTextField.text = item
        }
    }
    
    fileprivate func postEvent() {
        guard let eventType = self.selectedEventType,
              let content = self.contentTextField.text,
              let address = self.addressTextField.text
        else { return }
        self.postEvent(content: content, eventTypeId: eventType.id, lat: "\(selectedCoordinates.latitude)", lng: "\(selectedCoordinates.longitude)", address: address)
    }
    
    
    func postEvent(content: String, eventTypeId: String, lat: String, lng: String, address: String) {
        let params = [
            "decription": content,
            "latitude": lat,
            "longitude": lng,
            "phoneContact": "",
            "emergency": false,
            "eventTypeId": eventTypeId,
            "postedByUser": Account.current!.id,
            "address": address
        ] as [String : Any]
        
        requestApiResponseString(urlString: Api.event, method: .post, params: params, encoding: JSONEncoding.default) { (responseString) in
            guard let jsonString = responseString.value else { return }
            let jsonData = Data(jsonString.utf8)
            guard let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : Any] else { return }
            guard let eventLogId = dict?["id"] as? String else { return }
            print(eventLogId)
            self.showAlert(title: "Thành công", message: "báo cáo sự kiện thành công", style: .alert, hasTwoButton: false) { (action) in
                self.postImage(eventLogId: eventLogId)
            }
            //            self.resignFirstResponder()
        }
    }
    
    func postImage(eventLogId: String) {
        if self.selectedImages.count > 0 {
            self.uploadImage(images: self.selectedImages, eventLogId: eventLogId)
        } else {
            print("No Image selected!")
            //            self.reloadViewFromNib()
            self.reloadData()
        }
    }
    
    func getEventTypes() {
        _newApiRequestWithErrorHandling(url: Api.eventTypes + "?pageIndex=1&pageSize=10", method: .get) { (responseString, data, status) in
            guard let jsonString = responseString.value else { return }
            guard let data = jsonString.data(using: .utf8) else { return }
            guard let eventTypes = try? JSONDecoder().decode([EventType].self, from: data) else { return }
            self.eventTypes = eventTypes
            
        }
    }
    
    func keyBoardResignFirstResponder(_ textFields : [UITextField]) {
        for textField in textFields {
            textField.resignFirstResponder()
        }
    }
    
    // reload data
    func reloadData() {
        self.reloadViewFromNib()
        self.selectedImages.removeAll()
        self.dropdown.reloadAllComponents()
        self.reloadInputViews()
        // Set delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.tabBarController?.selectedIndex = 1
        })
    }
    
    // MARK: - Upload image
    func uploadImage(images: [UIImage], eventLogId: String) {
        self.showHUD()
        for image in images {
            let urlString = "\(ApiDomain.new)\(eventLogId)/Files"
            guard let token = Account.current?.access_token else { return }
            let headers: HTTPHeaders = ["Content-Type": "application/form-data",
                                        "Authorization" : "Bearer \(token)"]
            Alamofire.upload(multipartFormData: { multipartFormData in
                guard let imgData = image.withRenderingMode(.alwaysTemplate)
                        .jpegData(compressionQuality: 0) else { return }
                multipartFormData.append(imgData, withName: "files",fileName: "\(randomString(length: 5)).jpeg", mimeType: "image/jpeg")
            },
                             to: urlString, method: .put, headers: headers)
            { (result) in
                print("result", result)
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        print(response.response!.statusCode)
                        self.reloadData()
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                    self.showAlert(errorMessage: encodingError.localizedDescription)
                }
            }
        }
        self.hideHUD()
    }
    
    // MARK: Get address of location
    fileprivate func getAddress(of location: CLLocationCoordinate2D) {
        requestNonTokenResponseString(urlString: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(location.latitude),\(location.longitude)&key=\(GMSApiKey.iosKey)",
                                      method: .post,
                                      params: nil,
                                      encoding: URLEncoding.default) { (response) in
            guard let jsonString = response.value,
                  let jsonData = jsonString.data(using: .utf8),
                  let resultCoordinates = try? JSONDecoder().decode(CoordinateResult.self, from: jsonData)
            else { return }
            if resultCoordinates.results.count > 0 {
                let formattedAddress = resultCoordinates.results[0].formattedAddress
                self.addressTextField.text = formattedAddress
            }
        }
    }
}

extension EventPostingViewController  {
    // Present the Autocomplete view controller when the button is pressed.
    func presentAutocompleteController() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue))
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
}

extension EventPostingViewController: MapViewControllerDelegate {
    func didPickLocation(coordinate: CLLocationCoordinate2D) {
        self.selectedCoordinates = coordinate
    }
}

extension EventPostingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage = Int(page)
    }
}

extension EventPostingViewController: ImagesSelectingViewControllerDelegate {
    func didSelect(images: [UIImage]) {
        self.selectedImages = images
        self.setup(scrollView: self.scrollView)
    }
}

extension EventPostingViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name!)")
        print("Place ID: \(place.placeID!)")
        print("Place attributions: \(place.attributions!)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

protocol SocketMessageDelegate: class {
    func didReceiveMessage()
}

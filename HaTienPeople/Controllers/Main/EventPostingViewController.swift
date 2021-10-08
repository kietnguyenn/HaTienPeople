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
import ImageSlideshow


class EventPostingViewController: BaseViewController {
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var eventTypeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBAction func selectImage(_ button: UIButton) {
        self.selectImages()
    }
    
    @IBAction func showMap(_: UIButton) {
        let vc = MyStoryboard.main.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.delegate = self
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func post(_: UIButton) {
        self.postEvent()
    }
    
    @IBAction func showDropdown(_: UIButton) {
        self.dropdown.show()
    }
    
    var selectedImages = [UIImage]() {
        didSet {
            print("Images: \(selectedImages.count)")
            if selectedImages.count > 0 {
                self.slideshow.isHidden = false
            } else {
                self.slideshow.isHidden = true
            }
        }
    }
    
    var eventTypes = [EventType]() {
        didSet {
            print(eventTypes.count)
            Constant.eventTypes = self.eventTypes
            self.setupDropdown()
        }
    }
    
    var selectedEventType: EventType?
    
    var selectedCoordinates = CLLocationCoordinate2D(latitude: CurrentLocation.latitude, longitude: CurrentLocation.longitude)
    
    var dropdown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkCoreLocationPermission()
        self.contentTextView.delegate = self
        self.getEventTypes()
        self.title = Constant.title.eventCreating
        self.showBackButton()
        self.navigationController?.navigationBar.isHidden = false
        self.getAddress(of: CurrentLocation)
        self.setupSlideshow()
    }

    func setupSlideshow() {
        slideshow.slideshowInterval = 3.0
        slideshow.zoomEnabled = true
        slideshow.isHidden = true
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
        pageIndicator.pageIndicatorTintColor = UIColor.black
        if #available(iOS 14.0, *) {
            pageIndicator.backgroundStyle = .prominent
        } else {
            // Fallback on earlier versions
        }
        slideshow.pageIndicator = pageIndicator
//                slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: -20))
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        slideshow.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func didTap() {
//        if selectedImages.count > 0 {
//            slideshow.presentFullScreenController(from: self)
//        }
        self.selectImages()
    }
    
    func setupImageSources(with images: [UIImage]) {
        let inputSources = images.map { (image) -> ImageSource in
            ImageSource(image: image)
        }
        self.slideshow.setImageInputs(inputSources)
    }
    
    func selectImages() {
        let vc = MyStoryboard.main.instantiateViewController(withIdentifier: "ImagesSelectingViewController") as! ImagesSelectingViewController
        vc.delegate = self
        vc.imageList = self.selectedImages
        present(vc, animated: true)
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
              let content = self.contentTextView.text,
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
//                self.addressTextField.text = formattedAddress
//            }
//        }
        requestNonTokenResponseString(urlString: "https://api.mapbox.com/geocoding/v5/mapbox.places/\(location.longitude),\(location.latitude).json?&access_token=\(MapBoxKey.publicToken)&language=vi&coutnry=VN",
                                      method: .get,
                                      params: nil,
                                      encoding: URLEncoding.default) { (response) in
            guard let jsonString = response.value,
                  let jsonData = jsonString.data(using: .utf8),
                  let geocodingResult = try? JSONDecoder().decode(GeocodingJSONResult.self, from: jsonData),
                  let features = geocodingResult.features
            else { return }
            if features.count > 0 {
                guard let address = features[0].placeName else { return }
                self.addressTextField.text = address
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
    func didPickLocation(coordinate: CLLocationCoordinate2D, address: String) {
        self.selectedCoordinates = coordinate
        self.addressTextField.text = address
    }

}

extension EventPostingViewController: ImagesSelectingViewControllerDelegate {
    func didSelect(images: [UIImage]) {
        self.selectedImages = images
        self.setupImageSources(with: images)
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

// MARK: - UITextView Delegate
extension EventPostingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Nội dung sự cố"
            textView.textColor = UIColor.lightGray
        }
    }
}

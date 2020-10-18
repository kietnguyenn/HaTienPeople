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

class EventPostingViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var eventTypeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var coordinatesLabel: UILabel!
    
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
        }
    }
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var eventTypes = [EventType]() {
        didSet {
            print(eventTypes.count)
            self.setupDropdown()
        }
    }
    
    var selectedEventType: EventType?
    
    var selectedCoordinates = CLLocationCoordinate2D(latitude: MyLocation.lat, longitude: MyLocation.long) {
        didSet {
            self.getAddress(of: selectedCoordinates)
            coordinatesLabel.text = "Lat: \(selectedCoordinates.latitude), lng: \(selectedCoordinates.longitude)"
        }
    }
    
    var dropdown = DropDown()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Báo cáo sự cố"
        self.getEventTypes()
        self.checkCoreLocationPermission()
        self.scrollView.delegate = self
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
        self.postEvent(content: content, eventTypeId: eventType.id, lat: "", lng: "", address: address)
        
    }
    
    func postEvent(content: String, eventTypeId: String, lat: String, lng: String, address: String) {
        let params = [
            "decription": content,
            "latitude": lat,
            "longitude": lng,
            "phoneContact": "0706567579",
            "emergency": false,
            "eventTypeId": eventTypeId,
            "postedByUser": Account.current!.id,
            "address": address
            ] as [String : Any]
        
        requestApiResponseString(urlString: Api.event, method: .post, params: params, encoding: JSONEncoding.default) { (responseString) in
            guard let jsonString = responseString.value else { return }
            let jsonData = Data(jsonString.utf8)
            guard let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : Any] else { return }
            guard let eventLogId = dict["id"] as? String else { return }
            print(eventLogId)
            self.showAlert(title: "Thành công", message: "báo cáo sự cố thành công", style: .alert, hasTwoButton: false) { (action) in
                self.postImage(eventLogId: eventLogId)
            }
            self.resignFirstResponder()
        }
        
    }
    
    func postImage(eventLogId: String) {
        if self.selectedImages.count > 0 {
            self.uploadImage(images: self.selectedImages, eventLogId: eventLogId)
        } else {
            print("No Image selected!")
        }
    }
    
    func getEventTypes() {
        requestApiResponseString(urlString: Api.eventTypes + "?pageIndex=1&pageSize=10", method: .get, encoding: JSONEncoding.default) { (responseString) in
            guard let jsonString = responseString.value else { return }
            guard let data = jsonString.data(using: .utf8) else { return }
            guard let eventTypes = try? JSONDecoder().decode([EventType].self, from: data) else { return }
            self.eventTypes = eventTypes
        }
    }
    
//    func getAssetThumbnail(asset: PHAsset) -> UIImage {
//        let manager = PHImageManager.default()
//        let option = PHImageRequestOptions()
//        var thumbnail = UIImage()
//        option.isSynchronous = true
//        manager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
//                thumbnail = result!
//        })
//        return thumbnail
//    }

    func clearData() {
        selectedImages.removeAll()
        setup(scrollView: scrollView)
        contentTextField.text = ""
        addressTextField.text = ""
        eventTypeTextField.text = ""
        selectedEventType = nil
    }
    
    // MARK: - Upload image
    func uploadImage(images: [UIImage], eventLogId: String) {
        self.showHUD()
        let urlString = "https://apindashboard.vkhealth.vn/\(eventLogId)/Files"
        guard let token = Account.current?.access_token else { return }
        let headers: HTTPHeaders = ["Content-Type": "application/form-data",
                                    "Authorization" : "Bearer \(token)"]
        Alamofire.upload(multipartFormData: { multipartFormData in
            for image in images {
                guard let imgData = image.jpegData(compressionQuality: 0.2) else { return }
                multipartFormData.append(imgData, withName: "files",fileName: "\(randomString(length: 6)).jpg", mimeType: "image/jpg")
            }
        },
        to: urlString, method: .put, headers: headers)
        { (result) in
            self.hideHUD()
            print(result)
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.response!.statusCode)
                    self.clearData()
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    // MARK: Get address of location
    fileprivate func getAddress(of location: CLLocationCoordinate2D) {
        requestNonTokenResponseString(urlString: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(location.latitude),\(location.longitude)&key=\(GMSApiKey.garageKey)",
                                      method: .post,
                                      params: nil,
                                      encoding: URLEncoding.default) { (response) in
            guard let jsonString = response.value,
                  let jsonData = jsonString.data(using: .utf8),
                  let resultCoordinates = try? JSONDecoder().decode(CoordinateResult.self, from: jsonData)
                  else { return }
            let formattedAddress = resultCoordinates.results[0].formattedAddress
            self.addressTextField.text = formattedAddress
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
        UInt(GMSPlaceField.placeID.rawValue))!
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
    print("Place name: \(place.name)")
    print("Place ID: \(place.placeID)")
    print("Place attributions: \(place.attributions)")
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

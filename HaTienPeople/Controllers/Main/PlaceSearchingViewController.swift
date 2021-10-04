//
//  PlaceSearchingViewController.swift
//  HaTienPeople
//
//  Created by Apple on 10/13/20.
//

import Foundation
import UIKit
import GooglePlaces
import DropDown

class PlaceSearchingViewController: BaseViewController {

    var placeClient = GMSPlacesClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue))
        self.placeClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
          (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
          if let error = error {
            print("An error occurred: \(error.localizedDescription)")
            return
          }

          if let placeLikelihoodList = placeLikelihoodList {
            for likelihood in placeLikelihoodList {
              let place = likelihood.place
              print("Current Place name \(String(describing: place.name)) at likelihood \(likelihood.likelihood)")
              print("Current PlaceID \(String(describing: place.placeID))")
            }
          }
        })

    }

}



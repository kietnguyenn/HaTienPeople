//
//  GeoJsonResponse.swift
//  HaTienPeople
//
//  Created by Nguyễn Anh Kiệt on 07/10/2021.
//

import Foundation

// MARK: - GeoCoding
struct GeoCoding: Codable {
    let plusCode: GeoCodingPlusCode?
    let results: [_Result]?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case plusCode = "plus_code"
        case results, status
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.geoCodingPlusCodeTask(with: url) { geoCodingPlusCode, response, error in
//     if let geoCodingPlusCode = geoCodingPlusCode {
//       ...
//     }
//   }
//   task.resume()

// MARK: - GeoCodingPlusCode
struct GeoCodingPlusCode: Codable {
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.resultTask(with: url) { result, response, error in
//     if let result = result {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Result
struct _Result: Codable {
    let addressComponents: [_AddressComponent]?
    let formattedAddress: String?
    let geometry: _Geometry?
    let placeID, reference: String?
    let plusCode: ResultPlusCode?
    let types: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case geometry
        case placeID = "place_id"
        case reference
        case plusCode = "plus_code"
        case types
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.addressComponentTask(with: url) { addressComponent, response, error in
//     if let addressComponent = addressComponent {
//       ...
//     }
//   }
//   task.resume()

// MARK: - AddressComponent
struct _AddressComponent: Codable {
    let longName, shortName: String?

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.geometryTask(with: url) { geometry, response, error in
//     if let geometry = geometry {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Geometry
struct _Geometry: Codable {
    let location: Location?
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.locationTask(with: url) { location, response, error in
//     if let location = location {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Location
struct _Location: Codable {
    let lat, lng: Double?
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.resultPlusCodeTask(with: url) { resultPlusCode, response, error in
//     if let resultPlusCode = resultPlusCode {
//       ...
//     }
//   }
//   task.resume()

// MARK: - ResultPlusCode
struct ResultPlusCode: Codable {
    let compoundCode, globalCode: String?

    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

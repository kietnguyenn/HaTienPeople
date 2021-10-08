//
//  GeoJsonResponse.swift
//  HaTienPeople
//
//  Created by Nguyễn Anh Kiệt on 07/10/2021.
//

import Foundation

// MARK: - GeoJSONResponse
struct GeocodingJSONResult: Codable {
    let type: String?
    let query: [Double]?
    let features: [Feature]?
    let attribution: String?
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.featureTask(with: url) { feature, response, error in
//     if let feature = feature {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Feature
struct Feature: Codable {
    let id, type: String?
    let placeType: [String]?
    let relevance: Int?
    let properties: Properties?
    let text, placeName: String?
    let center: [Double]?
    let geometry: _Geometry?
    let context: [Context]?
    let bbox: [Double]?

    enum CodingKeys: String, CodingKey {
        case id, type
        case placeType = "place_type"
        case relevance, properties, text
        case placeName = "place_name"
        case center, geometry, context, bbox
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.contextTask(with: url) { context, response, error in
//     if let context = context {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Context
struct Context: Codable {
    let id, text, wikidata, shortCode: String?

    enum CodingKeys: String, CodingKey {
        case id, text, wikidata
        case shortCode = "short_code"
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
    let coordinates: [Double]?
    let type: String?
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.propertiesTask(with: url) { properties, response, error in
//     if let properties = properties {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Properties
struct Properties: Codable {
    let foursquare: String?
    let landmark: Bool?
    let address, category, wikidata, shortCode: String?

    enum CodingKeys: String, CodingKey {
        case foursquare, landmark, address, category, wikidata
        case shortCode = "short_code"
    }
}

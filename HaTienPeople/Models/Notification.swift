//
//  Notification.swift
//  HaTienPeople
//
//  Created by Apple on 12/18/20.
//

import Foundation


// MARK: - File
struct File: Codable {
    let id, fileName: String?
}
//

// MARK: - Empty
struct NotificationsResponse: Codable {
    let pageIndex, pageSize, totalSize: Int?
    let data: [NotificationItem]?
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.datumTask(with: url) { datum, response, error in
//     if let datum = datum {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Datum
struct NotificationItem: Codable {
    let id: String?
    let files: [File]?
    let category: Category?
    let description, title, dateCreated, datePublic: String?
    let fromUnit: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, files, category
        case description = "description"
        case title, dateCreated, datePublic, fromUnit
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.categoryTask(with: url) { category, response, error in
//     if let category = category {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Category
struct Category: Codable {
    let id, categoryDescription: String?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryDescription = "description"
    }
}

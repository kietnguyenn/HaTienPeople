//
//  Notification.swift
//  HaTienPeople
//
//  Created by Apple on 12/18/20.
//

import Foundation

// MARK: - NotificationElement
struct NotificationElement: Codable {
    let id: String?
    let seen, starred, isDeleted: Bool?
    let dateCreated: String?
    let notification: NotificationClass?
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.notificationClassTask(with: url) { notificationClass, response, error in
//     if let notificationClass = notificationClass {
//       ...
//     }
//   }
//   task.resume()

// MARK: - NotificationClass
struct NotificationClass: Codable {
    let id: String?
    let files: [File]?
    let category: Category?
    let notificationDescription, title: String?

    enum CodingKeys: String, CodingKey {
        case id, files, category
        case notificationDescription = "description"
        case title
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

//
// To read values from URLs:
//
//   let task = URLSession.shared.fileTask(with: url) { file, response, error in
//     if let file = file {
//       ...
//     }
//   }
//   task.resume()

// MARK: - File
struct File: Codable {
    let id, fileName: String?
}

typealias Notification = [NotificationElement]

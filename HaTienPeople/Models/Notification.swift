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
    let files: [File]?
    let category: Category?
    let notificationDescription, title: String?

    enum CodingKeys: String, CodingKey {
        case id, files, category
        case notificationDescription = "description"
        case title
    }
}

// MARK: - Category
struct Category: Codable {
    let id: String?
    let categoryDescription: Description?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryDescription = "description"
    }
}

enum Description: String, Codable {
    case emergencyNoti = "Thông Báo Khẩn"
    case newNoti = "Thông Báo Mới"
    case fromClinicNoti = "Thông Báo Từ Sở Y Tế"
}

// MARK: - File
struct File: Codable {
    let id, fileName: String?
}

typealias Notification = [NotificationElement]

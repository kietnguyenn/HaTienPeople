//
//  EventHandlingUsers.swift
//  HTEmployee
//
//  Created by Apple on 1/25/21.
//

import Foundation

// MARK: - EventHandlingUsers
struct EventHandlingUsers: Codable {
    let owner: Owner?
    let employees: [Owner]?
}

// MARK: - Owner
struct Owner: Codable {
    let id, userName, phoneNumber, fullName: String?
    let title, email: String?
    let phoneAddress: String?
}

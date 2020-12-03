//
//  CustomerInfo.swift
//  HaTienPeople
//
//  Created by Apple on 12/3/20.
//


import Foundation

// MARK: - CustomerInfo
struct CustomerInfo: Codable {
    let fullName: String?
    let phoneAddress: String?
    let phoneNumber, id, userName, title: String?
    let positions: [String]?
    let email: String?
    let groups: [String]?
}

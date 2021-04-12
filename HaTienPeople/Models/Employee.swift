//
//  Employee.swift
//  HTEmployee
//
//  Created by Apple on 12/14/20.
//

import Foundation

// MARK: - Employee
struct Employee: Codable {
    let fullName, title: String?
    let jobTitle, phoneAddress: String?
    let id, userName, normalizedUserName, email: String?
    let normalizedEmail: String?
    let emailConfirmed: Bool?
    let passwordHash, securityStamp, concurrencyStamp, phoneNumber: String?
    let phoneNumberConfirmed, twoFactorEnabled: Bool?
    let lockoutEnd: JSONNull?
    let lockoutEnabled: Bool?
    let accessFailedCount: Int?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

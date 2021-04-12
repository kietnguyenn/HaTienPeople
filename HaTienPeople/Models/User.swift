//
//  User.swift
//  HaTienEmployee
//
//  Created by kiet on 27/08/2020.
//  Copyright © 2020 kiet. All rights reserved.
//

import Foundation
import Combine

struct User: Codable {
    var id, userName, fullName: String?
    var title: String?
    var email, phoneAddress: String?
    var phoneNumber: String?
    
    init() {
        self.id = ""
        self.userName = "Previews"
        self.phoneNumber = "91029109820"
        self.fullName = "flasdjfal"
        self.title = "COn hcim non"
        self.email = "@gmaul.com"
        self.phoneAddress = "098290183"
    }
}

extension User {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(User.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

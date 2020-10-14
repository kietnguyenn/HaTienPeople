//
//  EventType.swift
//  HaTienEmployeeLast
//
//  Created by Apple on 10/4/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation

// MARK: - EventTypeElement
struct EventType: Codable {
    var id, name: String
    var description: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case description = "description"
    }
}

extension EventType {
    init(data: Data) throws {
        self = try JSONDecoder().decode(EventType.self, from: data)
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

    func with(
        id: String? = nil,
        name: String? = nil,
        description: String?? = nil
    ) -> EventType {
        return EventType(
            id: id ?? self.id,
            name: name ?? self.name,
            description: description ?? self.description
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    
     func newJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        }
        return encoder
    }

}


//
//  EventDetails.swift
//  HaTienEmployee
//
//  Created by kiet on 27/08/2020.
//  Copyright © 2020 kiet. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

// MARK: - EventDetail
struct EventDetail: Codable {
    var eventLogs: [EventLog]
    var users: [User]
    var eventLog: EventLog?
    var totalTime: Int
    var user: User?
    var eventStatus: EventStatus?
    var id, decription: String
    var emergency: Bool
    var dateTime, latitude, longitude, eventTypeId: String
    var eventTypeName: String?
    var status: Int
    var address, phoneContact: String
}

extension EventDetail {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EventDetail.self, from: data)
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

//
//  Event.swift
//  HaTienAppEmployee (iOS)
//
//  Created by kiet on 09/08/2020.
//

import Foundation

struct _Event: Codable, Identifiable {
    let id, decription: String?
    let latitude, longitude: String
    let eventTypeId: String?
    let status: Int?
    let address: String?
    
    init() {
        self.id = "kiet"
        self.decription = "Hiếp dâm;;fjad;ajk;kfj"
        self.eventTypeId = "rqweriqwrpwirq"
        self.status = 0
        self.address = "244/70 Lê Văn Khương P.Thới An, Quận 12"
        self.latitude = ""
        self.longitude = ""
    }
}


struct Event : Codable, Identifiable {
//    var eventLog: EventLogInEvent?
//    var totalTime: Int
//    var user: User?
//    var eventStatus: EventStatus
    let id, decription: String?
    let emergency: Bool?
    let dateTime, latitude, longitude, eventTypeID: String?
    let eventTypeName: String?
    let status: Int?
    let address: String?
    let ward: String?
    let phoneContact: String?

    enum CodingKeys: String, CodingKey {
        case id, decription, emergency, dateTime, latitude, longitude
        case eventTypeID = "eventTypeId"
        case eventTypeName, status, address, ward, phoneContact
    }
}

extension Event {
    
    init() {
//        self.eventLog = EventLogInEvent(id: "", eventId: "", userId: "", dateTime: "", status: 1, information: "")
//        self.totalTime = 1
//        self.user = User()
//        self.eventStatus = EventStatus(id: 2, name: "Đã tiếp nhận")
        self.id = ""
        self.decription = ""
        self.emergency = false
        self.dateTime = "2020-08-27'T'13:29:38"
        self.latitude = "0.1231231"
        self.longitude = "10.9812039"
        self.eventTypeID = "sdhakj"
        self.eventTypeName = "jlksjdka"
        self.status = 1
        self.address = "Địa chỉ ma"
        self.phoneContact = "01293810928"
        self.ward = ""
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Event.self, from: data)
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

struct EventLogInEvent: Codable {
    var id, eventId, userId, dateTime: String
    var status: Int?
    var information: String
}

struct EventStatus: Codable {
    let id: Int
    let name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

let eventStatus =   [EventStatus(id: 0, name: "Mới"),
                     EventStatus(id: 1, name: "Mới"),
                     EventStatus(id: 2, name: "Mới"),
                     EventStatus(id: 3, name: "Mới"),
                     EventStatus(id: 4, name: "Mới")]




//
//  EventHandlingByModel.swift
//  HTEmployee
//
//  Created by Apple on 1/22/21.
//


import Foundation

// MARK: - EventHandlingByModel
struct EventHandlingByModel: Codable {
    let eventLogs: [_EventLog]?
    let users: [_Employee]?
    let eventLog: JSONNull?
    let totalTime: Int?
    let user, eventStatus: JSONNull?
    let id, decription: String?
    let emergency: Bool?
    let dateTime, latitude, longitude, eventTypeID: String?
    let eventTypeName: String?
    let status: Int?
    let address, ward, phoneContact: String?

    enum CodingKeys: String, CodingKey {
        case eventLogs, users, eventLog, totalTime, user, eventStatus, id, decription, emergency, dateTime, latitude, longitude
        case eventTypeID = "eventTypeId"
        case eventTypeName, status, address, ward, phoneContact
    }
}

// MARK: - EventLog
struct _EventLog: Codable {
    let id: String?
    let user: User?
    let taskMaster, event: JSONNull?
    let dateTime: String?
    let eventLogType, eventName, userName: String?
    let eventID, information, userID: String?
    let status, eventLogTypeID: Int?

    enum CodingKeys: String, CodingKey {
        case id, user, taskMaster, event, dateTime, eventLogType, eventName, userName
        case eventID = "eventId"
        case information
        case userID = "userId"
        case status
        case eventLogTypeID = "eventLogTypeId"
    }
}

// MARK: - User
struct _Employee: Codable {
    let id: String?
    let userName: String?
    let phoneNumber, fullName, title: String?
    let email: String?
    let phoneAddress: String?
}



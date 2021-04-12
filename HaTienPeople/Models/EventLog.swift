//
//  EventLog.swift
//  HaTienAppEmployee (iOS)
//
//  Created by kiet on 13/08/2020.
//

import Foundation

struct EventLog: Codable, Identifiable {
    
    let id: String
    let user: User?
    let taskMaster: TaskMaster?
    let event: _Event
    let dateTime: String
    let eventLogType: EventLogType?
    let eventName, userName: String?
    let information: String?
    let eventID, userID: String
    let status, eventLogTypeID: Int

    enum CodingKeys: String, CodingKey {
        case id, user, taskMaster, event, dateTime, eventLogType, eventName, userName
        case eventID = "eventId"
        case information
        case userID = "userId"
        case status
        case eventLogTypeID = "eventLogTypeId"
    }
//
//    init(id: String, user: User, event: Event, eventName: String?, userName: String, dateTime: String, eventId: String, information: String, userId: String) {
//        self.id = id
//        self.user = user
//        self.event = event
//        self.eventName = eventName
//        self.userName = userName
//        self.dateTime = dateTime
//        self.eventID = eventId
//        self.information = information
////        self.userId = userId
//        self.status = 1
//    }
//
//    init() {
//        self.id = "id"
//        self.user = User()
//        self.event = Event()
//        self.eventName = "eventName"
//        self.userName = "userName"
//        self.dateTime = "dateTime"
//        self.eventID = "eventId"
//        self.information = "Sự kiện xịn"
//        self.status = 1
//    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}


extension URLSession {
    fileprivate func codableTask<T: Codable>(with urlString: String, method: String, param: [String: Any]?, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) {
        guard let token = Account.current?.access_token else { return }
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let param = param {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options: [.prettyPrinted])
            } catch {
                print("error when cast Dictionary to JSON")
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        self.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            print(statusCode)
            if 200..<300 ~= statusCode {
                completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
            } else {
                completionHandler(nil, response, error)
            }
        })
    }

    func eventLogRequest(url: String, method: String, param: [String: Any]?, completionHandler: @escaping ([EventLog]?, URLResponse?, Error?) -> Void) {
        self.codableTask(with: url, method: method, param: param, completionHandler: completionHandler)
    }
}

struct EventLogType: Codable {
    var id : Int?
    var description: String?
}

// MARK: - TaskMaster
struct TaskMaster: Codable {
    let id, userName, phoneNumber, fullName: String?
    let title: String?
    let email, phoneAddress: String?
}

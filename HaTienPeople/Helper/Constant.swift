//
//  Constant.swift
//  HaTienPeople
//
//  Created by Apple on 10/14/20.
//

import Foundation

struct GMSApiKey {
    static let garageKey = "AIzaSyBXZQStB98vcE6Lzkrm4qxAqyknKKRPIgo"
}

struct Constant {
    static var statusList = [EventStatus]() {
        didSet {
            for status in statusList {
                print("status = \(status.name)")
            }
        }
    }
    
    static var eventTypes = [EventType]() {
        didSet {
            for type in eventTypes {
                print("Event Type: \(type.name)")
            }
        }
    }
    
    struct title {
        static let eventCreating = "Tạo sự kiện"
        static let newEvents = "Chờ tiếp nhận"
        static let taskList = "Công việc"
        static let notifications = "Thông báo"
        static let account = "Tài khoản"
    }

}

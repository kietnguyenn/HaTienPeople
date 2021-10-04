//
//  Constant.swift
//  HaTienPeople
//
//  Created by Apple on 10/14/20.
//

import Foundation
import UIKit

let accentColorName = "AccentColor"
let accentColor = UIColor(named: accentColorName)

struct GMSApiKey {
//    static let iosKey = "AIzaSyA8o9zr__FemrWZ_xyVFQdPQFC03Uqlbhw"
    static let iosKey = "AIzaSyCMbslNBmuqgVsJXXyYHS7CI5RdwUdkZZw"
//    static let iosKey = "AIzaSyCSqne0SIdhxLVnPqn51P48DKTUSRFoA9s"
    
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
    
    struct AlertContent {
        static let serverError = "Hệ thống đang gặp sự cố, xin thử lại trong giây lát!"
        static let api400 = ""
        static let phoneNumberDidVerified = "Số điện thoại đang dùng đã được xác thực"
    }

}

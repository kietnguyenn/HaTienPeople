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
    static let iosKey = "AIzaSyAmFnTIuypzz79WDqtozYSyOm6-nBtVkQk"
}

struct MapBoxKey {
    static let key1 = "pk.eyJ1Ijoia2lldDA5MTAiLCJhIjoiY2t1ZXhhNXpoMW9zdjJxbG05M29rdGx0ZyJ9.-IxknyAMP64-ncyzScMquQ"
    static let apiKey = "rhRrzINdW1pw0GMmcVSpN2okwjb6rEp1ilxOzP6D"
    static let publicToken = "pk.eyJ1Ijoia2lldDA5MTAiLCJhIjoiY2t1ZXhhNXpoMW9zdjJxbG05M29rdGx0ZyJ9.-IxknyAMP64-ncyzScMquQ"
    static let privateToken = "pk.eyJ1Ijoia2lldDA5MTAiLCJhIjoiY2t1ZTV3ZGlsMWhjNzJubW80NWZmN2E1ayJ9.VC9vcZTWVFRLy07AFc4agQ"
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
        static let phoneNumberDidVerified = "Số điện thoại đang dùng đã được xác thực"
    }

}

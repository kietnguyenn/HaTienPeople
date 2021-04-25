//
//  EventLogTypeId.swift
//  HTEmployee
//
//  Created by Apple on 2/3/21.
//

import Foundation

import Foundation

enum EventLogTypeId: Int {
    case createNew = 1 // Tạo mới
    case empAsigned = 2 // Đăng kí xử lý
    case empStartHandle = 3 // Cán bộ bắt đầu xử lý
    case empInvite = 4 // Cán bộ mời
    case cancelAssigning = 5 // Hủy tiếp nhận
    case empForward = 6 // Cán bộ Chuyển
    case userUpdated = 7 // Người dùng cập nhật
    case makeRecord = 8 // Lập biên bản
    case startMoving = 9 // Bắt đầu di chuyển
    case stopMoving = 10 // Dừng di chuyển
    case approachEvent = 11 // Tiếp cận sự kiện
    case timedOut = 12 // Chuyển sang ngoài quy trình
    case complete = 13 // Cán bộ hoàn thành xử lý
    case removeEmp = 14 // Xóa cán bộ ra khỏi đăng ký xử lý sự kiện
    case cancelHandling = 15 // Hủy xử lý
}

import Foundation

// MARK: - EventLogTypeElement
struct EventLogType: Codable {
    let id: Int?
    let dateCreated, dateUpdated, eventLogTypeDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, dateCreated, dateUpdated
        case eventLogTypeDescription = "description"
    }
}

typealias EventLogTypeList = [EventLogType]
var eventLogTypeList = EventLogTypeList() {
    didSet {
        print("didSetEventLogTypeList")
    }
}

struct EventLogTypeName {
    static let createNew = "Tạo sự kiện"
    static let moveOutOfProgress = "Chuyển ngoài quy trình"
    static let assign = "Tiếp nhận sự kiện"
    static let update = "Cập nhật sự kiện"
    
    static let cancelAssigning = "Hủy tiếp nhận"
    static let cancelHandling = "Hủy xử lý"
    
    static let inviteEmployee = "Mời xử lý"
    static let forward = "Chuyển xử lý cho"
    static let complete = "Hoàn tất xử lý"
    static let startHandle = "Bắt đầu xử lý"
    static let removeEmployee = "Mời ra khỏi sự kiện"
    static let startMoving = "Bắt đầu di chuyển"
    static let stopMoving = "Dừng di chuyển"
    static let approachEvent = "Đã tiếp cận sự kiện"
}


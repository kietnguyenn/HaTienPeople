//
//  EventLogTypeId.swift
//  HTEmployee
//
//  Created by Apple on 2/3/21.
//

import Foundation

enum EventLogTypeId: Int {
    case createNew = 1 // Tạo mới
    case timedOut = 2 // Chuyển sang ngoài quy trình
    case empAsigned = 3 // Đăng kí xử lý
    case userUpdated = 4 // Người dùng cập nhật
    case empCancel = 5 // Cán bộ Hủy
    case empInvite = 6 // Cán bộ mời
    case adminForward = 7 // Admin điều phối
    case employeeCompleted = 8 // Cán bộ hoàn thành xử lý
    case userCancelUploadEvent = 9 // Người dùng hủy sự cố
    case empForward = 10 // Cán bộ Chuyển
    case empStartHandle = 11 // Cán bộ bắt đầu xử lý
}

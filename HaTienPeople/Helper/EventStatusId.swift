//
//  EventStatusId.swift
//  HTEmployee
//
//  Created by Apple on 2/3/21.
//

import Foundation

enum EventStatusId: Int {
    case newEvent = 0 // Sự kiện mới
    case handling = 1 // Đang xử lý
    case arrived = 2 // Cán bộ đã đén nơi
    case completed = 3 // Hoàn thành xử lý
//    case eventUpdated = 4
    case outDated = 5 // quá thời gian chờ
    case empMoving = 6 // Cán bộ đang di chuyển
    case waitingForHandling = 7 // Đang chờ xử lý
}

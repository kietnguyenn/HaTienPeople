//
//  File.swift
//  HaTienEmployee
//
//  Created by MacBook on 9/29/20.
//  Copyright © 2020 kiet. All rights reserved.
//

import Foundation

struct EventLogFile: Codable, Identifiable {
    let id, name, fileType, file: String
    let eventLogId: String

    enum CodingKeys: String, CodingKey {
        case id, name, fileType, file
        case eventLogId = "eventLogId"
    }
}

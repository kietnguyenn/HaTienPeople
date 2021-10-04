//
//  UserInfo.swift
//  HaTienPeople
//
//  Created by Nguyễn Anh Kiệt on 30/09/2021.
//

import Foundation

struct UserInfo: Codable {
    var id : String
    var access_token: String
    var fullname: String
    var userName: String
    var roles: String
    var expires_in: Int
    
    static var current: CustomerInfo? {
        didSet {
            guard let current = current else {
                print ("Did remove current Customer Info")
                return
            }
            print(current.fullName)
            print(current.userName)
        }
    }
}

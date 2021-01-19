//
//  Account.swift
//  HaTienEmployeeLast
//
//  Created by MacBook on 10/1/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation

struct Account: Codable {
    var id : String
    var access_token: String
    var fullname: String
    var userName: String
    var roles: String
    var expires_in: Int
    
    static var current: Account? {
        didSet {
            guard let current = current else {
                print ("Did remove current User")
                return
            }
            print("Token: ", current.access_token)
            print("User ID: ", current.id)
        }
    }
}

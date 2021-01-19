//
//  Api.swift
//  HaTienAppPeople (iOS)
//
//  Created by kiet on 05/08/2020.
//

import Foundation

struct ApiDomain {
    static let test = "http://202.78.227.112:60006/"
    static let new = "https://apindashboard.vkhealth.vn/"
    static let product = "http://14.241.195.74:30080/"
}

struct Api {
    struct Auth {
        static let login = ApiDomain.product + "api/Auth/login" // POST
    }
    static let users = ApiDomain.product + "api/Users" // POST, GET
    static let eventTypes = ApiDomain.product + "api/EventTypes"
    static let event = ApiDomain.product + "api/Events" // post
    static let eventNew = ApiDomain.product + "api/Events/GetEventsNew" // GET
    static let status = ApiDomain.product + "api/EventStatus" // GET
    static let eventGetByStatusId = ApiDomain.product + "api/Events/GetByStatusId" // get
    static let coordinator = ApiDomain.product + "api/Events/Coordinator" // POST
    static let eventPostedByUser = ApiDomain.product + "api/Events/PostedByUser" // get
    
    static let password = ApiDomain.product + "api/Users/Password"
    static let userInfo = ApiDomain.product + "api/Users/Info"
    static let files = ApiDomain.product + "api/Notification/File"
    static let notifications = ApiDomain.product + "api/Notification"
}

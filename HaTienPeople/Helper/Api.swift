//
//  Api.swift
//  HaTienAppPeople (iOS)
//
//  Created by kiet on 05/08/2020.
//

import Foundation

struct ApiDomain {
    static let test = "http://202.78.227.112:60006/api"
    static let new = "https://apindashboard.vkhealth.vn/api"
}

struct Api {
    struct Auth {
        static let login = ApiDomain.new + "/Auth/login" // POST
    }
    static let users = ApiDomain.new + "/Users" // POST, GET
    static let eventTypes = ApiDomain.new + "/EventTypes"
    static let event = ApiDomain.new + "/Events" // post 
    static let eventNew = ApiDomain.new + "/Events/GetEventsNew" // GET
    static let status = ApiDomain.new + "/EventStatus" // GET
    static let eventGetByStatusId = ApiDomain.new + "/Events/GetByStatusId" // get
    static let coordinator = ApiDomain.new + "/Events/Coordinator" // POST
    static let eventPostedByUser = ApiDomain.new + "/Events/PostedByUser" // get
}

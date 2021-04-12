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
//    static let new = "http://14.241.195.74:30080/"
}

struct Api {
    struct Auth {
        static let login = ApiDomain.new + "api/Auth/login" // POST
    }
    static let employee = ApiDomain.new + "api/Employees" // post
    static let users = ApiDomain.new + "api/Users" // POST, GET
    static let eventTypes = ApiDomain.new + "api/EventTypes"
    static let event = ApiDomain.new + "api/Events" // post
    static let eventNew = ApiDomain.new + "api/Events/GetEventsNew" // GET
    static let status = ApiDomain.new + "api/EventStatus" // GET
    static let eventGetByStatusId = ApiDomain.new + "api/Events/GetByStatusId" // get
    static let coordinator = ApiDomain.new + "api/Events/Coordinator" // POST
    static let eventPostedByUser = ApiDomain.new + "api/Events/PostedByUser" // get
    static let eventLogs = ApiDomain.new + "api/EventLog"
    static let eventLogsById = ApiDomain.new + "api/EventsLog/GetByEventId"
    
    static let password = ApiDomain.new + "api/Users/Password"
    static let userInfo = ApiDomain.new + "api/Users/Info"
    static let files = ApiDomain.new + "api/Notification/File"
    static let notifications = ApiDomain.new + "api/Notification"
    static let notificationFilter = ApiDomain.new + "api/NotificationUser/Filter?dateDescending=true&pageIndex=1&pageSize=10"
    static let eventsRelatedUser = ApiDomain.new + "api/Events/RelatedUsers"
    static let notificationsForUser = ApiDomain.new + "api/NotificationUser/Filter"
    static let addEmpToEvent = ApiDomain.new + "api/EventsAd/SetEventToUser"
    static let eventForm = ApiDomain.new + "api/EventForm"
    static let eventFormFilter = ApiDomain.new + "api/EventForm/Event"

}

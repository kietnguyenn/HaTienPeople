//
//  SocketMessage.swift
//  HaTienPeople
//
//  Created by Nguyễn Anh Kiệt on 26/04/2021.
//

import Foundation

class SocketMessage: NSObject {
    static let shared = SocketMessage()
    var lat = String() {
        didSet {
            print("Socket message lat:", lat)
        }
    }
    var lng = String(){
        didSet {
            print("Socket message lng:", lat)
        }
    }
    var eventId = String(){
        didSet {
            print("Socket message guid:", lat)
        }
    }
    weak var delegate : SocketMessageDelegate?
    
    func `init`(_ lat: String, _ lng: String, _ eventId: String) {
        self.lat = lat
        self.lng = lng
        self.eventId = eventId
        guard let delegate = self.delegate else { return }
        delegate.didReceiveMessage()
    }
}

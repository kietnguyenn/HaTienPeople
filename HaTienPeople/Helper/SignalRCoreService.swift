//
//  SignalRCoreService.swift
//  HTEmployee
//
//  Created by Apple on 26/03/2021.
//

import Foundation
import SwiftSignalRClient

public class SignalRCoreService {
    static let shared = SignalRCoreService(urlString: "https://apindashboard.vkhealth.vn/centerhub")
    
    var connection: HubConnection
    
    private init(urlString: String) {
        let url = URL(string: urlString)!
        connection = HubConnectionBuilder(url: url)
            .withLogging(minLogLevel: .debug)
            .withHttpConnectionOptions(configureHttpOptions: { (option) in
                guard let current = Account.current else { return }
                option.accessTokenProvider = {return current.access_token}
            })
            .withAutoReconnect()
            .build()
        connection.delegate = self
    }
}

extension SignalRCoreService: HubConnectionDelegate {
    func connectionDidOpen(connection: Connection) {
        print("Connection did open")
    }
    
    func connectionDidReceiveData(connection: Connection, data: Data) {
        guard let dataDict = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else { return }
        print("Connection did receive Data: \(dataDict)")
    }

    public func connectionDidOpen(hubConnection: HubConnection) {
        print("HubConnectionDidOpen")
    }

    public func connectionDidFailToOpen(error: Error) {
        print("connectionDidFailToOpen")
    }

    public func connectionDidClose(error: Error?) {
        print("connectionDidClose")
    }
    
    public func connectionDidReconnect() {
        print("Connection did reconnect")
    }
    
    
}

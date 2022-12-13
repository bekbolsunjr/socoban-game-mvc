//
//  RemoteServerManager.swift
//  Socoban Game MVC Pattern
//
//  Created by bekbolsun on 28/9/22.
//

import Foundation


public class RemoteServerManager {
    static let shared = RemoteServerManager(host: "194.152.37.7", port: 5543)
    private var connectedToServer = false
    private var serverWorker: ServerManager
    private var map = ""
    
    private init(host: String, port: UInt32) {
        serverWorker = ServerManager(host: host, port: port, messageEncoding: .isoLatin1)
        configureCallbacks()
    }
    
    private func configureCallbacks() {
        serverWorker.connectionCompleted = { [weak self] in
            self?.connectedToServer = true
        }
        serverWorker.didRecieveMessage  = { [weak self] message in
            self?.map = message
        }
    }
    
    public func getMap() -> String {
        return map
    }
    
    public func checkConnection() -> Bool {
        return connectedToServer
    }
    
    public func getLevel(levelName name: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.serverWorker.sendMessage(message: ServerRequests.getLevel(levelName: name).requestString)
        }
    }
}

fileprivate enum ServerRequests {
    case getLevel(levelName: String)
    var requestString: String {
        switch self {
        case .getLevel(let levelName):
            return "GET_LEVEL: " + levelName
        }
    }
}

fileprivate enum ServerResponse {
    case gotLevel
    case endOfFile
    var responseString: String {
        switch self {
        case .gotLevel:
            return "GOT_LEVEL: "
        case .endOfFile:
            return "END_OF_MESSAGE"
        }
    }
}


//
//  SocketIOManager.swift
//  TaxiParty
//
//  Created by Greed on 5/18/24.
//

import Foundation
import SocketIO
import RxSwift
import RxCocoa

final class SocketIOManager {
    
    static let shared = SocketIOManager()
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    var receivedChatData = PublishRelay<ChatModel>()
    var roomId: String!
    
    init() {
        
        manager = SocketManager(socketURL: URL(string: APIKey.baseURL.rawValue + "/v1")!, config: [.log(true), .compress])
        socket = manager.socket(forNamespace: "/chats-\(roomId)")
        
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        
        socket.on("chat") { dataArray, ack in
            print(dataArray)
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func leaveConnection() {
        socket.disconnect()
    }
    
}

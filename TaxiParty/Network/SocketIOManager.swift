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
    let baseURL = URL(string: "\(APIKey.baseURL.rawValue)/v1")!
    
    var receivedChatData = PublishSubject<ChatModel>()
    
    init() { }
    
    private func configureSocket(roomId: String) {
        manager = SocketManager(socketURL: baseURL, config: [.log(true), .compress])
        socket = manager.socket(forNamespace: "/chats-" + "\(roomId)")

        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        
        socket.on("chat") { dataArray, ack in
            if let data = dataArray.first, let jsonData = try? JSONSerialization.data(withJSONObject: data) {
                    do {
                        let decodedData = try JSONDecoder().decode(ChatModel.self, from: jsonData)
                        self.receivedChatData.onNext(decodedData)
                    } catch {
                        print("Decoding error: \(error)")
                    }
                }
        }
    }
    
    func establishConnection(roomId: String) {
        configureSocket(roomId: roomId)
        socket.connect()
    }
    
    func leaveConnection() {
        socket.disconnect()
//        socket = nil
//        manager = nil
    }
    
}

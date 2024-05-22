//
//  ChatModel.swift
//  TaxiParty
//
//  Created by Greed on 5/18/24.
//

import Foundation

struct ChatModel: Decodable {
    let chatId: String
    let content: String
    let createdAt: String
    let sender: Sender
    var isMe: Bool {
        return TokenManager.userId == sender.userId
    }
    
    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case content
        case createdAt
        case sender
    }
}

struct Sender: Decodable {
    let userId: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}

struct ChatInfo {
    let chatModel: ChatModel
    var isContinuous: Bool
    var isSameTime: Bool
}

extension ChatModel {
    func toChatInfo() -> ChatInfo {
        return ChatInfo(chatModel: self, isContinuous: false, isSameTime: false)
    }
}

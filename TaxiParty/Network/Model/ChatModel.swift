//
//  ChatModel.swift
//  TaxiParty
//
//  Created by Greed on 5/18/24.
//

import Foundation

struct ChatModel: Decodable {
    let content: String
    let createdAt: String
    let sender: Sender
    var isMe: Bool {
        return TokenManager.userId == sender.userId
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

//
//  CreateChatRoomModel.swift
//  TaxiParty
//
//  Created by Greed on 5/17/24.
//

import Foundation

struct CreateChatModel: Decodable {
    let room_id: String
    let createdAt: String
    let updatedAt: String
    let participants: [Participants]
}

struct Participants: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}

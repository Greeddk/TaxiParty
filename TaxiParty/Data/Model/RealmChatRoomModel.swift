//
//  RealmChatModel.swift
//  TaxiParty
//
//  Created by Greed on 5/22/24.
//

import Foundation
import RealmSwift

final class RealmChatRoomModel: Object {
    @Persisted(primaryKey: true) var roomId: String
    @Persisted var createdAt: String
    @Persisted var updateAt: String
    @Persisted var chatArray: List<RealmChatModel>
    
    convenience init(roomId: String, createdAt: String, updateAt: String, chatArray: List<RealmChatModel>) {
        self.init()
        self.roomId = roomId
        self.createdAt = createdAt
        self.updateAt = updateAt
        self.chatArray = chatArray
    }
}

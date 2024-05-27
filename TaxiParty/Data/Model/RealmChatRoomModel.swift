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
    @Persisted var chatArray: List<RealmChatInfoModel>
    @Persisted var opponent: Opponent?
    
    convenience init(roomId: String, createdAt: String, updateAt: String, chatArray: List<RealmChatInfoModel>, opponent: Participants) {
        self.init()
        self.roomId = roomId
        self.createdAt = createdAt
        self.updateAt = updateAt
        self.chatArray = chatArray
        self.opponent = Opponent(user_id: opponent.user_id, nick: opponent.nick, profileImage: opponent.profileImage)
    }
}

final class Opponent: EmbeddedObject {
    @Persisted var user_id: String
    @Persisted var nick: String
    @Persisted var profileImage: String?
    
    convenience init(user_id: String, nick: String, profileImage: String? = nil) {
        self.init()
        self.user_id = user_id
        self.nick = nick
        self.profileImage = profileImage
    }
}

//
//  RealmChatModel.swift
//  TaxiParty
//
//  Created by Greed on 5/22/24.
//

import Foundation
import RealmSwift

final class RealmChatModel: Object {
    @Persisted(primaryKey: true) var chatId: String
    @Persisted var content: String
    @Persisted var createdAt: String
    @Persisted var sender: RealmChatSender?
    @Persisted var files: List<String?>
    
    convenience init(chatId: String, content: String, createdAt: String, sender: RealmChatSender, files: List<String?>) {
        self.init()
        self.chatId = chatId
        self.content = content
        self.createdAt = createdAt
        self.sender = sender
        self.files = files
    }
}

final class RealmChatSender: Object {
    @Persisted(primaryKey: true) var userId: String
    @Persisted var nick: String
    @Persisted var profileImage: String?
    
    convenience init(userId: String, nick: String, profileImage: String? = nil) {
        self.init()
        self.userId = userId
        self.nick = nick
        self.profileImage = profileImage
    }
}

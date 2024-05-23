//
//  RealmChatModel.swift
//  TaxiParty
//
//  Created by Greed on 5/22/24.
//

import Foundation
import RealmSwift

final class RealmChatInfoModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var chatModel: RealmChatModel?
    @Persisted var isContinuous: Bool
    @Persisted var isSameTime: Bool
    
    convenience init(chatModel: RealmChatModel? = nil, isContinuous: Bool, isSameTime: Bool) {
        self.init()
        self.chatModel = chatModel
        self.isContinuous = isContinuous
        self.isSameTime = isSameTime
    }
}

extension RealmChatInfoModel {
    func toChatInfo() -> ChatInfo {
        let item = self.chatModel
        let chatModel = ChatModel(
            chatId: item?.chatId ?? "",
            content: item?.content ?? "",
            createdAt: item?.createdAt ?? "",
            sender: Sender(userId: item?.sender?.userId ?? "", nick: item?.sender?.nick ?? "", profileImage: item?.sender?.profileImage ?? "")
        )
        
        return ChatInfo(chatModel: chatModel, isContinuous: self.isContinuous, isSameTime: self.isSameTime)
    }
}

final class RealmChatModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var chatId: String
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

final class RealmChatSender: EmbeddedObject {
    @Persisted var userId: String
    @Persisted var nick: String
    @Persisted var profileImage: String?
    
    convenience init(userId: String, nick: String, profileImage: String? = nil) {
        self.init()
        self.userId = userId
        self.nick = nick
        self.profileImage = profileImage
    }
}

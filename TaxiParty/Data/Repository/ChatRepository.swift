//
//  ChatRepository.swift
//  TaxiParty
//
//  Created by Greed on 5/22/24.
//

import Foundation
import RealmSwift

final class ChatRepository {
    
    private let realm = try! Realm()
    
    func createChatRoom(item: CreateChatModel) {
        let chatRoom = RealmChatRoomModel(roomId: item.room_id, createdAt: item.createdAt, updateAt: item.updatedAt, chatArray: List())
        do {
            try realm.write {
                realm.add(chatRoom)
            }
        } catch {
            print("realm createChatRoom error")
        }
    }
    
    func appendChatList(id: String, chatList: [ChatModel]) {
        let chatRoom = realm.objects(RealmChatRoomModel.self).where {
            $0.roomId == id
        }
        do {
            try realm.write {
                chatList.forEach { item in
                    chatRoom.first?.chatArray.append(RealmChatModel(chatId: item.chatId, content: item.content, createdAt: item.createdAt, sender: RealmChatSender(userId: item.sender.userId, nick: item.sender.nick, profileImage: item.sender.profileImage ?? nil), files: List()))
                }
            }
        } catch {
            print("realm saveChat error")
        }
    }
    
    func fetchChatList(id: String) -> [RealmChatModel?] {
        let chatRoom = realm.objects(RealmChatRoomModel.self).where {
            $0.roomId == id
        }
        let chatArray = chatRoom.first?.chatArray ?? List()
        return Array(chatArray)
    }
    
}

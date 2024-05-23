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
    
    func appendChatList(id: String, chat: ChatInfo) {
        let chatRoom = realm.objects(RealmChatRoomModel.self).filter { $0.roomId == id }
        do {
            try realm.write {
                chatRoom.first?.chatArray.append(RealmChatInfoModel(chatModel: RealmChatModel(
                    chatId: chat.chatModel.chatId,
                    content: chat.chatModel.content,
                    createdAt: chat.chatModel.createdAt,
                    sender: RealmChatSender(
                        userId: chat.chatModel.sender.userId,
                        nick: chat.chatModel.sender.nick,
                        profileImage: chat.chatModel.sender.profileImage ?? nil), files: List()),
                    isContinuous: chat.isContinuous,
                    isSameTime: chat.isSameTime))
            }
        } catch {
            print("realm saveChat error")
        }
    }
    
    func updateChatInfo(index: Int, id: String, isContinuous: Bool?, isSameTime: Bool?) {
        guard let chatRoom = realm.objects(RealmChatRoomModel.self).filter({ $0.roomId == id }).first else {
            print("채팅방을 찾을 수 없습니다")
            return
        }
        
        do {
            try realm.write {
                let chatInfo = chatRoom.chatArray[index]
                
                if let isContinuous = isContinuous {
                    chatInfo.isContinuous = isContinuous
                }
                if let isSameTime = isSameTime {
                    chatInfo.isSameTime = isSameTime
                }
            }
        } catch {
            print("realm updateChatInfo error: \(error.localizedDescription)")
        }
    }

    
    func fetchChatList(id: String) -> [RealmChatInfoModel?] {
        let chatRoom = realm.objects(RealmChatRoomModel.self).filter { $0.roomId == id }
        let chatArray = chatRoom.first?.chatArray ?? List()
        return Array(chatArray)
    }
    
}

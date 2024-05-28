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
        let chatRoom = RealmChatRoomModel(roomId: item.room_id, createdAt: item.createdAt, updateAt: item.updatedAt, chatArray: List(), opponent: item.opponent)
        do {
            try realm.write {
                realm.add(chatRoom)
            }
        } catch {
            print("realm createChatRoom error")
        }
    }
    
    func appendChatList(id: String, chat: ChatInfo) {
        guard let chatRoom = realm.object(ofType: RealmChatRoomModel.self, forPrimaryKey: id) else {
            print("채팅방이 없습니다.", #function)
            return
        }
        do {
            try realm.write {
                let newChat = RealmChatInfoModel(chatModel: RealmChatModel(
                    chatId: chat.chatModel.chatId,
                    content: chat.chatModel.content,
                    createdAt: chat.chatModel.createdAt,
                    sender: RealmChatSender(
                        userId: chat.chatModel.sender.userId,
                        nick: chat.chatModel.sender.nick,
                        profileImage: chat.chatModel.sender.profileImage ?? nil), files: List()),
                    isContinuous: chat.isContinuous,
                    isSameTime: chat.isSameTime)
                chatRoom.chatArray.append(newChat)
            }
        } catch {
            print("realm saveChat error")
        }
    }
    
    func updateChatInfo(index: Int, id: String, isContinuous: Bool?, isSameTime: Bool?) {
        guard let chatRoom = realm.object(ofType: RealmChatRoomModel.self, forPrimaryKey: id) else {
            print("채팅방을 찾을 수 없습니다")
            return
        }
        
        do {
            try realm.write {
                let chatInfo = chatRoom.chatArray[index]
                chatRoom.updateAt = chatInfo.chatModel?.createdAt ?? ""
                
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

    
    func fetchChatList(id: String) -> [RealmChatInfoModel] {
        let chatRoom = realm.object(ofType: RealmChatRoomModel.self, forPrimaryKey: id)
        let chatArray = chatRoom?.chatArray ?? List()
        return Array(chatArray)
    }
    
    func checkRoomExist(id: String) -> Bool {
        let chatRoom = realm.object(ofType: RealmChatRoomModel.self, forPrimaryKey: id)
        if chatRoom == nil {
            return false
        }
        return true
    }
    
    func fetchLastChat(id: String) -> String {
        let lastChatInfo = fetchChatList(id: id)
        guard let lastDate = lastChatInfo.last?.chatModel?.createdAt else { return ""}
        return lastDate
    }
    
    func fetchChatRoomList() -> [ChatRoomCellInfoModel] {
        let chatRoomList = realm.objects(RealmChatRoomModel.self)
            .sorted(byKeyPath: "updateAt", ascending: false)
            .filter {
            $0.chatArray.count > 0
        }
        var chatRoomCellInfoList: [ChatRoomCellInfoModel] = []
        for item in chatRoomList {
            guard let lastChat = item.chatArray.last?.toChatInfo() else { return [] }
            let newItem = ChatRoomCellInfoModel(roomId: item.roomId, opponent: item.opponent ?? Opponent(user_id: "", nick: ""), lastContent: lastChat.chatModel.content, lastDate: lastChat.chatModel.createdAt, unreadCount: 0)
            chatRoomCellInfoList.append(newItem)
        }

        return Array(chatRoomCellInfoList)
    }
    
    func deleteAllData() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("delete error")
        }
    }
    
}

//
//  ChattingRouter.swift
//  TaxiParty
//
//  Created by Greed on 5/17/24.
//

import Foundation
import Alamofire

enum ChattingRouter {
    case createChatRoom(query: CreateChatQuery)
    case fetchAllChatList
    case sendChat(roomId: String, content: SendChatQuery)
    case fetchChat(roomId: String, lastDate: String)
}

extension ChattingRouter: RouterType {

    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .createChatRoom:
            return .post
        case .fetchAllChatList:
            return .get
        case .sendChat:
            return .post
        case .fetchChat:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .createChatRoom:
            return "/v1/chats"
        case .fetchAllChatList:
            return "/v1/chats"
        case .sendChat(let roomId, _):
            return "/v1/chats/\(roomId)"
        case .fetchChat(let roomId, _):
            return "/v1/chats/\(roomId)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .createChatRoom:
            return [HTTPHeader.authorization.rawValue: TokenManager.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue]
        case .fetchAllChatList:
            return [HTTPHeader.authorization.rawValue: TokenManager.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .sendChat:
            return [HTTPHeader.authorization.rawValue: TokenManager.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue]
        case .fetchChat:
            return [HTTPHeader.authorization.rawValue: TokenManager.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItem: [URLQueryItem]? {
        switch self {
        case .createChatRoom:
            return nil
        case .fetchAllChatList:
            return nil
        case .sendChat:
            return nil
        case .fetchChat(_, let lastDate):
            let queryItem = [URLQueryItem(name: "cursor_date", value: lastDate)]
            return queryItem
        }
    }
    
    var body: Data? {
        switch self {
        case .createChatRoom(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .fetchAllChatList:
            return nil
        case .sendChat(_, let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .fetchChat:
            return nil
        }
    }
}


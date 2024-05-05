//
//  PostRouter.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case fetchPost(next: String, limit: Int)
    case writePost(query: PostQuery)
    case joinParty(postId: String, status: JoinPartyQuery)
    case getOnePost(postId: String)
}

extension PostRouter: RouterType {

    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchPost:
            return .get
        case .writePost:
            return .post
        case .joinParty:
            return .post
        case .getOnePost:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchPost:
            return "/v1/posts"
        case .writePost:
            return "/v1/posts"
        case .joinParty(let postId, _):
            return "/v1/posts/\(postId)/like"
        case .getOnePost(let postId):
            return "/v1/posts/\(postId)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchPost:
            return [HTTPHeader.authorization.rawValue: TokenManager.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .writePost:
            return [HTTPHeader.authorization.rawValue: TokenManager.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue]
        case .joinParty:
            return [HTTPHeader.authorization.rawValue: TokenManager.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                    HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue]
        case .getOnePost:
            return [HTTPHeader.authorization.rawValue: TokenManager.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItem: [URLQueryItem]? {
        switch self {
        case .fetchPost(let next, let limit):
            let queryItem = [
                URLQueryItem(name: "product_id", value: ProductId.taxiParty.rawValue),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "next", value: next)
            ]
            return queryItem
        case .writePost:
            return nil
        case .joinParty:
            return nil
        case .getOnePost:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchPost:
            return nil
        case .writePost(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .joinParty(_, let status):
            let encoder = JSONEncoder()
            return try? encoder.encode(status)
        case .getOnePost:
            return nil
        }
    }
}

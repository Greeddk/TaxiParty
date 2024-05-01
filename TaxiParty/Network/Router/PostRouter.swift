//
//  PostRouter.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case fetchPost
    case writePost(query: PostQuery)
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
        }
    }
    
    var path: String {
        switch self {
        case .fetchPost:
            return "/v1/posts"
        case .writePost:
            return "/v1/posts"
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
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItem: [URLQueryItem]? {
        switch self {
        case .fetchPost:
            let queryItem = [URLQueryItem(name: "product_id", value: ProductId.taxiParty.rawValue), URLQueryItem(name: "limit", value: "20")]
            return queryItem
        case .writePost:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchPost:
            return nil
        case .writePost(let query):
            return nil
        }
    }
}

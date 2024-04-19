//
//  PostRouter.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case fetchPost(query: String)
}

extension PostRouter: RouterType {

    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchPost:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchPost:
            return "/v1/posts"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchPost:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: Token.accessToken.rawValue)!, HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItem: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .fetchPost(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        }
    }
}

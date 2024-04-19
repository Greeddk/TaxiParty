//
//  AuthenticationRouter.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import Foundation
import Alamofire

enum Token: String {
    case accessToken
    case refreshToken
}

enum AuthenticationRouter {
    case login(query: LoginQuery)
    case join(query: joinQuery)
    case validationEmail(query: validationEmail)
    case withdraw
}

extension AuthenticationRouter: RouterType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            return .post
        case .join:
            return .post
        case .validationEmail:
            return .post
        case .withdraw:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/v1/users/login"
        case .join:
            return "/v1/users/join"
        case .validationEmail:
            return "/v1/validation/email"
        case .withdraw:
            return "/v1/users/withdraw"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue, HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .join:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue, HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .validationEmail:
            return [HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue, HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
        case .withdraw:
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
        case .login(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .join(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .validationEmail(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .withdraw:
            return nil
        }
    }
}


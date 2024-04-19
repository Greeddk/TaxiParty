//
//  RefreshTokenRouter.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import Foundation
import Alamofire

enum refreshTokenRouter {
    case refreshToken
}

extension refreshTokenRouter: RouterType {

    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .refreshToken:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .refreshToken:
            return "/v1/auth/refresh"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .refreshToken:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: Token.accessToken.rawValue)!,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                    HTTPHeader.refresh.rawValue: UserDefaults.standard.string(forKey: Token.refreshToken.rawValue)!
            ]
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
        case .refreshToken:
            return nil
        }
    }
}

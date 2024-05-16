//
//  RefreshTokenRouter.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import Foundation
import Alamofire

enum RefreshTokenRouter {
    case refreshToken
}

extension RefreshTokenRouter: RouterType {

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
            return [HTTPHeader.authorization.rawValue: TokenManager.accessToken,
                    HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                    HTTPHeader.refresh.rawValue: TokenManager.refreshToken
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

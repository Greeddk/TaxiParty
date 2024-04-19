//
//  ProfileRouter.swift
//  TaxiParty
//
//  Created by Greed on 4/19/24.
//

import Foundation
import Alamofire

enum ProfileRouter {
    case fetchProfile
}

extension ProfileRouter: RouterType {

    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchProfile:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchProfile:
            return "/v1/users/me/profile"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchProfile:
            return [HTTPHeader.authorization.rawValue: TokenManager.accessToken, HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue]
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
        case .fetchProfile:
            return nil
        }
    }
}

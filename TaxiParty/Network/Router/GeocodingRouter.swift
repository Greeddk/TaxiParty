//
//  ReverseGeocodingRouter.swift
//  TaxiParty
//
//  Created by Greed on 4/24/24.
//

import Foundation
import Alamofire

enum GeocodingRouter {
    case getAddress(coords: String)
    case keywordSearch(query: String)
}

extension GeocodingRouter: RouterType {

    var baseURL: String {
        switch self {
        case .getAddress(let coords):
            return APIKey.naverBaseURL.rawValue
        case .keywordSearch(let query):
            return APIKey.kakaoBaseURL.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getAddress:
            return .get
        case .keywordSearch:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getAddress:
            return "/map-reversegeocode/v2/gc"
        case .keywordSearch:
            return "/v2/local/search/keyword"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getAddress:
            return [HTTPHeader.naverClientId.rawValue: APIKey.naverClientId.rawValue, HTTPHeader.naverClinetSecret.rawValue: APIKey.naverClientSecret.rawValue]
        case .keywordSearch:
            return [HTTPHeader.authorization.rawValue: APIKey.kakaoRestAPI.rawValue]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItem: [URLQueryItem]? {
        switch self {
        case .getAddress(let coords):
            let queryItem = [URLQueryItem(name: "coords", value: coords), URLQueryItem(name: "orders", value: "addr,roadaddr"), URLQueryItem(name: "output", value: "json")]
            return queryItem
        case .keywordSearch(let query):
            let queryItem = [URLQueryItem(name: "query", value: query)]
            return queryItem
        }
    }
    
    var body: Data? {
        return nil
    }
}

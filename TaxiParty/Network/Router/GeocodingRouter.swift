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
    case getCoord(address: String)
    case keywordSearch(query: String)
    case fetchDirection(start: String, goal: String)
}

extension GeocodingRouter: RouterType {

    var baseURL: String {
        switch self {
        case .getAddress:
            return APIKey.naverBaseURL.rawValue
        case .keywordSearch:
            return APIKey.kakaoBaseURL.rawValue
        case .getCoord:
            return APIKey.naverBaseURL.rawValue
        case .fetchDirection:
            return APIKey.naverBaseURL.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getAddress:
            return .get
        case .keywordSearch:
            return .get
        case .getCoord:
            return .get
        case .fetchDirection:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getAddress:
            return "/map-reversegeocode/v2/gc"
        case .keywordSearch:
            return "/v2/local/search/keyword"
        case .getCoord:
            return "/map-geocode/v2/geocode"
        case .fetchDirection:
            return "/map-direction/v1/driving"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getAddress:
            return [HTTPHeader.naverClientId.rawValue: APIKey.naverClientId.rawValue, HTTPHeader.naverClinetSecret.rawValue: APIKey.naverClientSecret.rawValue]
        case .keywordSearch:
            return [HTTPHeader.authorization.rawValue: APIKey.kakaoRestAPI.rawValue]
        case .getCoord:
            return [HTTPHeader.naverClientId.rawValue: APIKey.naverClientId.rawValue, HTTPHeader.naverClinetSecret.rawValue: APIKey.naverClientSecret.rawValue]
        case .fetchDirection:
            return [HTTPHeader.naverClientId.rawValue: APIKey.naverClientId.rawValue, HTTPHeader.naverClinetSecret.rawValue: APIKey.naverClientSecret.rawValue]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItem: [URLQueryItem]? {
        switch self {
        case .getAddress(let coords):
            let queryItem = [URLQueryItem(name: "coords", value: coords),
                             URLQueryItem(name: "orders", value: "addr,roadaddr"),
                             URLQueryItem(name: "output", value: "json")]
            return queryItem
        case .keywordSearch(let query):
            let queryItem = [URLQueryItem(name: "query", value: query)]
            return queryItem
        case .getCoord(let address):
            let queryItem = [URLQueryItem(name: "query", value: address)]
            return queryItem
        case .fetchDirection(let start, let goal):
            let queryItem = [URLQueryItem(name: "start", value: start),
                             URLQueryItem(name: "goal", value: goal),
                             URLQueryItem(name: "option", value: "trafast")]
            return queryItem
        }
    }
    
    var body: Data? {
        return nil
    }
}

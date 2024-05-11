//
//  TargetType.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import Foundation
import Alamofire

protocol RouterType: URLRequestConvertible {
    
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var header: [String: String] { get }
    var parameters: String? { get }
    var queryItem: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension RouterType {
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpBody = parameters?.data(using: .utf8)
        urlRequest.httpBody = body
        urlRequest.url?.append(queryItems: queryItem ?? [])
        return urlRequest
    }
}
//
//  Token.swift
//  TaxiParty
//
//  Created by Greed on 4/18/24.
//

import Foundation

@propertyWrapper
struct TokenDefaults<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
}

enum TokenManager {
    enum Key: String {
        case userId
        case accessToken
        case refreshToken
    }
    
    @TokenDefaults(key: Key.userId.rawValue, defaultValue: "id 없음")
    static var userId
    
    @TokenDefaults(key: Key.accessToken.rawValue, defaultValue: "액세스 토큰 없음")
    static var accessToken
    
    @TokenDefaults(key: Key.refreshToken.rawValue, defaultValue: "리프레시 토큰 없음")
    static var refreshToken
    
}

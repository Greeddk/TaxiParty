//
//  LoginQuery.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import Foundation

struct LoginQuery: Encodable {
    let email: String
    let password: String
}

struct joinQuery: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String
}

struct validationEmail: Encodable {
    let email: String
}

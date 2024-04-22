//
//  LoginQuery.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import Foundation


struct LoginQuery: HTTPBodyProtocol {
    let email: String
    let password: String
}

struct JoinQuery: HTTPBodyProtocol {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String
}

struct validationEmail: HTTPBodyProtocol {
    let email: String
}

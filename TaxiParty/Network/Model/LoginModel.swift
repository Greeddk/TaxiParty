//
//  LoginModel.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import Foundation

struct LoginModel: Decodable {
    let accessToken: String
    let refreshToken: String
}

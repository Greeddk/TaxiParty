//
//  ProfileModel.swift
//  TaxiParty
//
//  Created by Greed on 4/19/24.
//

import Foundation

struct ProfileModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let phoneNum: String
    let profileImage: String?
    let posts: [String]?
}

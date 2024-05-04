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

struct ValidationEmail: HTTPBodyProtocol {
    let email: String
}

struct PostQuery: HTTPBodyProtocol {
    let title: String
    let startPlaceData: String
    let destinationData: String
    let numberOfPeople: String
    let dueDate: String
    let productId: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case startPlaceData = "content"
        case destinationData = "content1"
        case numberOfPeople = "content2"
        case dueDate = "content3"
        case productId = "product_id"
    }
}

struct JoinPartyQuery: HTTPBodyProtocol {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}

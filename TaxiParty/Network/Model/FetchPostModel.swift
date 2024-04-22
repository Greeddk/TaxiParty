//
//  FetchPostModel.swift
//  TaxiParty
//
//  Created by Greed on 4/21/24.
//

import Foundation

struct FetchPostModel: Decodable {
    let data: [Post]
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

struct Post: Decodable {
    let title: String
    let dueDate: String
    let startPoint: String
    let destination: String
    let maximumNum: String
    let joinPeople: [String]
    let creator: Creator

    enum CodingKeys: String, CodingKey {
        case title
        case dueDate = "content"
        case startPoint = "content1"
        case destination = "content2"
        case maximumNum = "content3"
        case joinPeople = "likes"
        case creator
    }

}

struct Creator: Decodable {
    let nick: String
    let profileImage: String
}


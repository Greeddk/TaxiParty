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
    let postId: String
    let title: String
    let startPlaceData: String
    let destinationData: String
    let numberOfPeople: String
    let dueDate: String
    let productId: String
    let createdAt: String
    let creator: Creator
    let together: [String]
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case title
        case startPlaceData = "content"
        case destinationData = "content1"
        case numberOfPeople = "content2"
        case dueDate = "content3"
        case productId = "product_id"
        case createdAt
        case creator
        case together = "likes"
    }
}

struct Creator: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}


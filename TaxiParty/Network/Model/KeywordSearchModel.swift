//
//  keywordSearchModel.swift
//  TaxiParty
//
//  Created by Greed on 4/25/24.
//

import Foundation

struct KeywordSearchModel: Decodable {
    let documents: [SearchedAddress]
    let meta: Meta
}

struct SearchedAddress: Decodable {
    let address: String
    let placeName: String
    let roadAddressName: String
    
    enum CodingKeys: String, CodingKey {
        case address = "address_name"
        case placeName = "place_name"
        case roadAddressName = "road_address_name"
    }
}

struct Meta: Decodable {
    let isEnd: Bool
    let pageCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageCount = "pageable_count"
    }
}

//
//  JoinPartyModel.swift
//  TaxiParty
//
//  Created by Greed on 5/4/24.
//

import Foundation

struct JoinPartyModel: Decodable {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}

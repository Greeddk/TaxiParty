//
//  GeocodingModel.swift
//  TaxiParty
//
//  Created by Greed on 5/1/24.
//

import Foundation

struct GeocodingModel: Decodable {
    let addresses: [Coordinate]
}

struct Coordinate: Decodable {
    let x, y: String
}

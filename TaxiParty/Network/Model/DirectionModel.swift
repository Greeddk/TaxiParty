//
//  DirectionModel.swift
//  TaxiParty
//
//  Created by Greed on 5/2/24.
//

import Foundation

struct DirectionModel: Decodable {
    let message: String
    let route: Route
}

struct Route: Decodable {
    let traoptimal: [Traoptimal]
}

struct Traoptimal: Decodable {
    let summary: Summary
    let path: [[Double]]
}

struct Summary: Decodable {
    let start: Start
    let goal: Goal
    let distance: Int
    let duration: Int
    let bbox: [[Double]]
    let taxiFare: Int
}

struct Goal: Decodable {
    let location: [Double]
}

struct Start: Decodable {
    let location: [Double]
}

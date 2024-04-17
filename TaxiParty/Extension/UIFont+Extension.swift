//
//  UIFont+Extension.swift
//  TaxiParty
//
//  Created by Greed on 4/16/24.
//

import UIKit

extension UIFont {
    enum SpoqaWeight: String {
        case bold    = "Bold"
        case medium  = "Medium"
        case regular = "Regular"
        case light   = "Light"
        case thin    = "Thin"
    }

    static func Spoqa(size: CGFloat, weight: SpoqaWeight) -> UIFont {
        return UIFont(name: "SpoqaHanSansNeo-\(weight.rawValue)", size: size)!
    }
}

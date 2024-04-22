//
//  UIView+Extension.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
    
    func addSubViews(views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}

//
//  UIView+Extension.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import UIKit

extension UIView {
    func addSubViews(views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}

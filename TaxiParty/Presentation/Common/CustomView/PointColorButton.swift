//
//  PointColorButton.swift
//  TaxiParty
//
//  Created by Greed on 4/18/24.
//

import UIKit

class PointColorButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.font = .Spoqa(size: 20, weight: .bold)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .pointPurple
        self.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

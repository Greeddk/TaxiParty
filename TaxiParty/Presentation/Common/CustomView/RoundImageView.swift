//
//  RoundImageView.swift
//  TaxiParty
//
//  Created by Greed on 4/21/24.
//

import UIKit

final class RoundImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

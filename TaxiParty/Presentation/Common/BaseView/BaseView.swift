//
//  BaseView.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setupAttributes()
        setupLayout()
        setupData()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setHierarchy() { }
    
    func setupData() { }
    
    func setupLayout() { }
    
    func setupAttributes() { }
    
    func formatAsDecimal(_ num: Int) -> String {
        let numberFormmater = NumberFormatter()
        numberFormmater.numberStyle = .decimal
        return numberFormmater.string(from: NSNumber(value: num)) ?? "0"
    }
    
}

//
//  PointBorderTextField.swift
//  TaxiParty
//
//  Created by Greed on 4/18/24.
//

import UIKit

class PointBorderTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.pointPurple.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 16
        self.font = .Spoqa(size: 18, weight: .regular)
        self.autocapitalizationType = .none
        self.clearButtonMode = .whileEditing
        self.returnKeyType = .done
        addLeftPadding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLeftPadding() {
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
      self.leftView = paddingView
      self.leftViewMode = ViewMode.always
    }
    
}

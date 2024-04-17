//
//  RoundTextField.swift
//  TaxiParty
//
//  Created by Greed on 4/16/24.
//

import UIKit
import TextFieldEffects

class FocusTextField: HoshiTextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.borderActiveColor = .pointPurple
        self.borderInactiveColor = .lightGray
        self.placeholderColor = .lightGray
        self.placeholderFontScale = 0.8
        self.autocapitalizationType = .none
        self.font = .Spoqa(size: 18, weight: .regular)
        self.clearButtonMode = .whileEditing
        self.returnKeyType = .done
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

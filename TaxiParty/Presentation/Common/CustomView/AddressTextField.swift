//
//  AddressTextField.swift
//  TaxiParty
//
//  Created by Greed on 4/28/24.
//

import UIKit

class AddressTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        setTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTextField() {
        self.layer.cornerRadius = 28
        let leftTextView = UILabel()
        leftTextView.text = "  ◦  "
        leftTextView.font = .Spoqa(size: 16, weight: .regular)
        self.leftView = leftTextView
        self.leftViewMode = .always
    }
    
    func focusTextField(isFocus: Bool) {
        if isFocus {
            self.backgroundColor = .systemGray6
        } else {
            self.backgroundColor = .clear
        }
    }
}

extension AddressTextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
}

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
        self.layer.cornerRadius = 32
        let leftTextView = UILabel()
        leftTextView.text = "  ◦  "
        leftTextView.font = .Spoqa(size: 16, weight: .regular)
        self.leftView = leftTextView
        self.leftViewMode = .always
    }
}

extension AddressTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.backgroundColor = .systemGray6
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.backgroundColor = .clear
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}

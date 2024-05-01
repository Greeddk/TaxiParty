//
//  UIViewController+Extension.swift
//  TaxiParty
//
//  Created by Greed on 4/16/24.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenViewIsTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setNavigationBackButton() {
        hideBackButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 19, weight: .regular)
        let image = UIImage(systemName: "arrow.backward", withConfiguration: imageConfig)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonClicked))
        backButton.tintColor = .pointPurple
        navigationItem.leftBarButtonItem = backButton
    }
    
    func hideBackButton() {
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @objc
    func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
}

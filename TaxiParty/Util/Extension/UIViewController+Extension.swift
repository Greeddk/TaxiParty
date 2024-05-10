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
    
    func setNavigationBackButton(title: String) {
        navigationController?.isNavigationBarHidden = false
        hideBackButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 19, weight: .regular)
        let image = UIImage(systemName: "arrow.backward", withConfiguration: imageConfig)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonClicked))
        backButton.tintColor = .pointPurple
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = title
    }
    
    func hideBackButton() {
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @objc
    func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAlertOnlyOK(title: String, message: String, action: @escaping (() -> Void?) ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            action()
        }
        
        alert.addAction(ok)
        
        present(alert, animated: true)
    }

    
    func showAlert(title: String, message: String, action: @escaping (() -> Void?) ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            action()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func changeFloatFormat(number : Double) -> String {
        return String(format: "%.6f", number)
    }
    
}

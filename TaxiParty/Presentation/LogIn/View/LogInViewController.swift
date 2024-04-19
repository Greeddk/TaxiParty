//
//  LogInViewController.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LogInViewController: BaseViewController {
    
    let mainView = LogInView()
    
    let viewModel = LogInViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenViewIsTapped()
    }

    override func bind() {
        
        let input = LogInViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty.asObservable(),
            passwordText: mainView.passwordTextField.rx.text.orEmpty.asObservable(),
            emailTextReturned: mainView.emailTextField.rx.controlEvent(.editingDidEndOnExit).asObservable(),
            passwordTextReturned: mainView.passwordTextField.rx.controlEvent(.editingDidEndOnExit).asObservable(),
            logInButtonTapped: mainView.logInButton.rx.tap.asObservable(),
            signUpButtonTapped: mainView.signUpButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.emailTextReturned
            .drive(with: self) { owner, _ in
                owner.mainView.passwordTextField.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
        
        output.loginSuccessTrigger
            .drive(with: self) { owner, value in
                if value {
                    owner.navigationController?.pushViewController(MainPagerViewController(), animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.indicatorTrigger
            .drive(with: self) { owner, value in
                owner.mainView.setIndicator(value: value)
            }
            .disposed(by: disposeBag)
        
        
        output.goSignUpPageTrigger
            .drive(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SignUpViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
}


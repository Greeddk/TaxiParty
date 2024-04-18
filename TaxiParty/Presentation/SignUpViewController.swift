//
//  SignUpViewController.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController {
    
    let mainView = SignUpView()
    let viewModel = SignUpViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setFirstResponder(selectedView: .emailTextField)
    }
    
    override func bind() {
        
        let input = SignUpViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty.asObservable(),
            passwordText: mainView.passwordTextField.rx.text.orEmpty.asObservable(),
            nicknameText: mainView.nicknameTextField.rx.text.orEmpty.asObservable(),
            phoneNumText: mainView.phoneNumTextField.rx.text.orEmpty.asObservable(),
            emailTextReturned: mainView.emailTextField.rx.controlEvent(.editingDidEndOnExit).asObservable(),
            passwordTextReturned: mainView.passwordTextField.rx.controlEvent(.editingDidEndOnExit).asObservable(),
            nicknameTextReturned: mainView.nicknameTextField.rx.controlEvent(.editingDidEndOnExit).asObservable(),
            phoneNumTextReturned: mainView.phoneNumTextField.rx.controlEvent(.editingDidEndOnExit).asObservable(),
            nextButtonTapped: mainView.nextButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.description
            .drive(mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.infoText
            .drive(mainView.infoLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.hidePasswordTextFieldTrigger
            .drive(with: self, onNext: { owner, value in
                owner.mainView.passwordTextField.isHidden = value
                if !value {
                    owner.mainView.setFirstResponder(selectedView: .passwordTextField)
                } else {
                    owner.mainView.setFirstResponder(selectedView: .emailTextField)
                }
            })
            .disposed(by: disposeBag)
        
        output.hideNicknameTextFieldTrigger
            .drive(with: self, onNext: { owner, value in
                owner.mainView.nicknameTextField.isHidden = value
                if !value {
                    owner.mainView.setFirstResponder(selectedView: .nicknameTextField)
                } else {
                    owner.mainView.setFirstResponder(selectedView: .passwordTextField)
                }
            })
            .disposed(by: disposeBag)
        
        output.hidePhoneNumTextFieldTrigger
            .drive(with: self, onNext: { owner, value in
                owner.mainView.phoneNumTextField.isHidden = value
                if !value{
                    owner.mainView.setFirstResponder(selectedView: .phoneNumTextField)
                } else {
                    owner.mainView.setFirstResponder(selectedView: .nicknameTextField)
                }
            })
            .disposed(by: disposeBag)
        
        output.nextButtonAppearTrigger
            .drive(mainView.nextButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.completeSignUpTrigger
            .drive(with: self, onNext: { owner, value in
                if value {
                    owner.navigationController?.pushViewController(CompleteSignUpViewController(), animated: true)
                }
            })
            .disposed(by: disposeBag)
        
    }
 
}

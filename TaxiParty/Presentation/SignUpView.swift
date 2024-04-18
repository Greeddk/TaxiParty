//
//  SignUpView.swift
//  TaxiParty
//
//  Created by Greed on 4/16/24.
//

import UIKit
import Then
import SnapKit

final class SignUpView: BaseView {
    
    enum CustomTextField {
        case emailTextField
        case passwordTextField
        case nicknameTextField
        case phoneNumTextField
    }

    let infoLabel = UILabel().then {
        $0.text = "이메일을 입력해주세요"
        $0.font = .Spoqa(size: 25, weight: .bold)
    }
    let descriptionLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .red
        $0.font = .Spoqa(size: 16, weight: .bold)
    }
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    let emailTextField = FocusTextField().then {
        $0.placeholder = "이메일"
        $0.keyboardType = .emailAddress
    }
    let passwordTextField = FocusTextField().then {
        $0.placeholder = "비밀번호"
        $0.isSecureTextEntry = true
    }
    let nicknameTextField = FocusTextField().then {
        $0.placeholder = "닉네임"
    }
    let phoneNumTextField = FocusTextField().then {
        $0.placeholder = "전화번호"
        $0.keyboardType = .phonePad
    }
    let nextButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .Spoqa(size: 20, weight: .medium)
        $0.backgroundColor = .pointPurple
        $0.layer.cornerRadius = 12
    }

    override func setHierarchy() {
        addSubViews(views: [infoLabel, descriptionLabel, stackView, nextButton])
        stackView.addArrangedSubview(phoneNumTextField)
        stackView.addArrangedSubview(nicknameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(emailTextField)
    }
    
    override func setupLayout() {
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(emailTextField)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
            make.leading.equalTo(infoLabel)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.lessThanOrEqualTo(300)
        }
        phoneNumTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(stackView)
            make.height.equalTo(60)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(stackView)
            make.height.equalTo(60)
        }
        passwordTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(stackView)
            make.height.equalTo(60)
        }
        emailTextField.snp.makeConstraints { make in            make.horizontalEdges.equalTo(stackView)
            make.height.equalTo(60)
        }
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.centerX.equalTo(self)
            make.height.equalTo(50)
        }
    }

    override func setupAttributes() {
        passwordTextField.isHidden = true
        nicknameTextField.isHidden = true
        phoneNumTextField.isHidden = true
    }
    
    func setFirstResponder(selectedView: CustomTextField) {
        switch selectedView {
        case .emailTextField:
            DispatchQueue.main.async {
                self.emailTextField.becomeFirstResponder()
            }
        case .passwordTextField:
            DispatchQueue.main.async {
                self.passwordTextField.becomeFirstResponder()
            }
        case .nicknameTextField:
            DispatchQueue.main.async {
                self.nicknameTextField.becomeFirstResponder()
            }
        case .phoneNumTextField:
            DispatchQueue.main.async {
                self.phoneNumTextField.becomeFirstResponder()
            }
        }
    }

}

//
//  LogInView.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import UIKit
import Then
import SnapKit
import NVActivityIndicatorView

final class LogInView: BaseView {
    
    lazy var indicatorView = NVActivityIndicatorView(frame: CGRect(x: (self.frame.width - 50) / 2, y: (self.frame.height - 50) / 2, width: 50, height: 50), type: .ballRotateChase, color: .white)
    lazy var loadingBackView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        $0.backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    let emailTextField = PointBorderTextField().then {
        $0.placeholder = "이메일을 입력해주세요"
        $0.keyboardType = .emailAddress
    }
    let passwordTextField = PointBorderTextField().then {
        $0.placeholder = "비밀번호를 입력해주세요"
        $0.isSecureTextEntry = true
    }
    let logInButton = PointColorButton().then {
        $0.setTitle("로그인", for: .normal)
    }
    let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = .Spoqa(size: 20, weight: .bold)
        $0.setTitleColor(.pointPurple, for: .normal)
    }
    
    override func setHierarchy() {
        addSubViews(views: [emailTextField, passwordTextField, logInButton, signUpButton])
    }
    
    override func setupLayout() {
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(100)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(60)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(emailTextField)
            make.height.equalTo(emailTextField)
        }
        logInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(60)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(logInButton.snp.bottom).offset(10)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func setIndicator(value: Bool) {
        if value {
            addSubview(loadingBackView)
            addSubview(indicatorView)
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
            indicatorView.removeFromSuperview()
            loadingBackView.removeFromSuperview()
        }
    }
}

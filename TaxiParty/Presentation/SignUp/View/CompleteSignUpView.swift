//
//  CompleteSignUpView.swift
//  TaxiParty
//
//  Created by Greed on 5/5/24.
//

import UIKit
import Then
import SnapKit

final class CompleteSignUpView: BaseView {

    let completeLabel = UILabel().then {
        $0.font = .Spoqa(size: 24, weight: .bold)
        $0.textColor = .pointPurple
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    let infoLabel = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .regular)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    override func setHierarchy() {
        addSubViews(views: [completeLabel, infoLabel])
    }
    
    override func setupLayout() {
        completeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(40)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(completeLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(self).inset(20)
            make.centerX.equalTo(self)
        }
    }

    override func setupAttributes() {
        completeLabel.text = "회원가입이 \n 완료되었습니다!"
        infoLabel.text = "3초 뒤 자동으로 로그인 화면으로 이동합니다!"
    }
    
}

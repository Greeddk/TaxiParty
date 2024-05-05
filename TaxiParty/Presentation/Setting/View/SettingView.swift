//
//  SettingView.swift
//  TaxiParty
//
//  Created by Greed on 4/22/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class SettingView: BaseView {

    private let backView = UIView().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayBorder.cgColor
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 7
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    private let profileImageView = RoundImageView(frame: .zero).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.pointPurple.cgColor
        $0.contentMode = .scaleAspectFill
    }
    private let nicknameLabel = UILabel().then {
        $0.font = .Spoqa(size: 20, weight: .bold)
    }
    private let emailLabel = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .light)
        $0.textColor = .lightGray
    }
    private let phoneIcon = UIImageView().then {
        $0.image = UIImage(systemName: "phone.circle")
        $0.tintColor = .pointPurple
    }
    private let phoneLabel = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .regular)
    }
    let editButton = UIButton().then {
        $0.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
        $0.tintColor = .pointPurple
    }
    let withdrawButton = UIButton().then {
        $0.setTitle("회원 탈퇴", for: .normal)
        $0.setTitleColor(.pointPurple, for: .normal)
        $0.titleLabel?.font = .Spoqa(size: 16, weight: .regular)
    }
    
    override func setHierarchy() {
        self.addSubViews(views: [backView, profileImageView, nicknameLabel, emailLabel, phoneIcon, phoneLabel, editButton, withdrawButton])
    }
    
    override func setupLayout() {
        backView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(self)
            make.width.equalTo(350)
            make.height.equalTo(120)
        }
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(backView).offset(18)
            make.size.equalTo(87)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(backView).offset(18)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(6)
            make.leading.equalTo(nicknameLabel)
            make.trailing.equalTo(backView).offset(-10)
        }
        phoneIcon.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom).offset(-4)
            make.leading.equalTo(nicknameLabel)
        }
        phoneLabel.snp.makeConstraints { make in
            make.leading.equalTo(phoneIcon.snp.trailing).offset(4)
            make.centerY.equalTo(phoneIcon)
        }
        editButton.snp.makeConstraints { make in
            make.trailing.equalTo(backView).offset(-18)
            make.centerY.equalTo(nicknameLabel)
        }
        withdrawButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-60)
            make.centerX.equalTo(self)
        }
    }
    
    func configureView(profile: ProfileModel) {
        nicknameLabel.text = profile.nick
        emailLabel.text = profile.email
        phoneLabel.text = profile.phoneNum
        guard let url = URL(string: APIKey.baseURL.rawValue + "/v1/" +  (profile.profileImage ?? "default")) else { return }
        let options: KingfisherOptionsInfo = [
            .requestModifier(ImageDownloadRequest())
        ]
        profileImageView.kf.setImage(with: url, options: options)
        if url.absoluteString == APIKey.baseURL.rawValue + "/v1/" + "default" {
            profileImageView.image = UIImage(named: "defaultProfile")
        }
    }
}

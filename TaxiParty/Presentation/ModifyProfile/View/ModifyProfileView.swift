//
//  ModifyProfileView.swift
//  TaxiParty
//
//  Created by Greed on 5/5/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class ModifyProfileView: BaseView {

    let profileImageView = RoundImageView(frame: .zero).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.pointPurple.cgColor
        $0.contentMode = .scaleAspectFill
    }
    let nicknameTextField = PointBorderTextField().then {
        $0.textAlignment = .center
    }
    let modifyButton = PointColorButton().then {
        $0.setTitle("수정", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nicknameTextField.delegate = self
    }
    
    override func setHierarchy() {
        addSubViews(views: [profileImageView, nicknameTextField, modifyButton])
    }

    override func setupLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(40)
            make.centerX.equalTo(self)
            make.size.equalTo(150)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
        }
        modifyButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-40)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(60)
        }
    }
    
    func configureProfile(profile: ProfileModel) {
        nicknameTextField.text = profile.nick
        guard let url = URL(string: APIKey.baseURL.rawValue + "/v1/" +  profile.profileImage!) else { return }
        let options: KingfisherOptionsInfo = [
            .requestModifier(ImageDownloadRequest())
        ]
        profileImageView.kf.setImage(with: url, options: options)
    }
    
}

extension ModifyProfileView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}

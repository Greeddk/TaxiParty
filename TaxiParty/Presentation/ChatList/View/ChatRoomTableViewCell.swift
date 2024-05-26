//
//  ChatListTableViewCell.swift
//  TaxiParty
//
//  Created by Greed on 5/26/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class ChatRoomTableViewCell: BaseTableViewCell {

    let profileImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.image = UIImage(named: "defaultProfile")
    }
    let nickname = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .medium)
    }
    let lastTime = UILabel().then {
        $0.font = .Spoqa(size: 10, weight: .regular)
        $0.textColor = .systemGray2
    }
    let lastText = UILabel().then {
        $0.font = .Spoqa(size: 12, weight: .medium)
        $0.textColor = .systemGray
        $0.numberOfLines = 2
    }
    
    override func configureHierarchy() {
        contentView.addSubViews(views: [profileImage, nickname, lastTime, lastText])
    }
    
    override func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
            make.size.equalTo(32)
        }
        nickname.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
            make.trailing.equalTo(lastTime.snp.leading).offset(-12)
            make.top.lessThanOrEqualTo(profileImage.snp.top).offset(10)
        }
        lastTime.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-16)
            make.top.equalTo(profileImage.snp.top).offset(8)
        }
        lastText.snp.makeConstraints { make in
            make.top.equalTo(nickname.snp.bottom).offset(4)
            make.leading.equalTo(nickname)
            make.trailing.equalTo(nickname)
            make.bottom.lessThanOrEqualTo(profileImage.snp.bottom)
        }
    }
    
    func configureCell(item: ChatRoomCellInfoModel) {
        nickname.text = item.sender.nick
        lastText.text = item.lastContent
        lastTime.text = item.lastDate
        
        guard let url = URL(string: APIKey.baseURL.rawValue + "/v1/" +  (item.sender.profileImage ?? "default")) else { return }
        let options: KingfisherOptionsInfo = [
            .requestModifier(ImageDownloadRequest())
        ]
        profileImage.kf.setImage(with: url, options: options)
        if item.sender.profileImage == "" {
            profileImage.image = UIImage(named: "defaultProfile")
        }
    }

}

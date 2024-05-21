//
//  OpponentChatTableViewCell.swift
//  TaxiParty
//
//  Created by Greed on 5/18/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class OpponentChatTableViewCell: BaseTableViewCell {
    
    let opponentImage = RoundImageView(frame: .zero).then {
        $0.image = UIImage(named: "defaultProfile")
    }
    let nickname = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .medium)
    }
    let text = PaddingLabel().then {
        $0.backgroundColor = .systemGray5
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.numberOfLines = 0
        $0.font = .Spoqa(size: 14, weight: .medium)
    }
    let date = UILabel().then {
        $0.font = .Spoqa(size: 8, weight: .medium)
        $0.textColor = .systemGray2
    }
    
    override func configureHierarchy() {
        contentView.addSubViews(views: [opponentImage, nickname, text, date])
    }
    
    override func setConstraints() {
        opponentImage.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(10)
            make.size.equalTo(32)
        }
        nickname.snp.makeConstraints { make in
            make.top.equalTo(opponentImage)
            make.leading.equalTo(opponentImage.snp.trailing).offset(10)
        }
        text.snp.makeConstraints { make in
            make.top.equalTo(nickname.snp.bottom).offset(4)
            make.leading.equalTo(nickname)
            make.width.lessThanOrEqualTo(220)
            make.bottom.equalTo(contentView).offset(-2)
        }
        date.snp.makeConstraints { make in
            make.bottom.equalTo(text.snp.bottom)
            make.leading.equalTo(text.snp.trailing).offset(5)
        }
    }
    
    func configureCell(item: ChatInfo) {
        text.text = item.chatModel.content
        
        if item.isSameTime {
            date.text = ""
        } else {
            date.text = convertToTextDateFormat(item.chatModel.createdAt)
        }
        
        if !item.isContinuous {
            nickname.text = item.chatModel.sender.nick
            guard let url = URL(string: APIKey.baseURL.rawValue + "/v1/" +  (item.chatModel.sender.profileImage ?? "default")) else { return }
            let options: KingfisherOptionsInfo = [
                .requestModifier(ImageDownloadRequest())
            ]
            opponentImage.kf.setImage(with: url, options: options)
            if url.absoluteString == APIKey.baseURL.rawValue + "/v1/" + "default" {
                opponentImage.image = UIImage(named: "defaultProfile")
            }
        } else {
            opponentImage.image = nil
            opponentImage.backgroundColor = .white
            nickname.text = nil
        }
    }

}

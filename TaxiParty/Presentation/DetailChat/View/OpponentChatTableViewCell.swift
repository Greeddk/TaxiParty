//
//  OpponentChatTableViewCell.swift
//  TaxiParty
//
//  Created by Greed on 5/18/24.
//

import UIKit
import Then
import SnapKit

final class OpponentChatTableViewCell: BaseTableViewCell {

    let opponentImage = RoundImageView(frame: .zero).then {
        $0.image = UIImage(named: "defaultProfile")
    }
    let text = PaddingLabel().then {
        $0.backgroundColor = .systemGray5
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.numberOfLines = 0
    }
    
    override func configureHierarchy() {
        contentView.addSubViews(views: [opponentImage, text])
    }
    
    override func setConstraints() {
        opponentImage.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(12)
            make.leading.equalTo(10)
            make.size.equalTo(32)
        }
        text.snp.makeConstraints { make in
            make.top.equalTo(opponentImage)
            make.leading.equalTo(opponentImage.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualTo(contentView).offset(-20)
            make.bottom.equalTo(contentView).offset(-2)
        }
    }

}

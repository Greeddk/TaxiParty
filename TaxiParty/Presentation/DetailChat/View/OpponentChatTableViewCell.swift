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

    let opponentImage = RoundImageView(frame: .zero)
    let text = UILabel().then {
        $0.backgroundColor = .pointPurple
        $0.layer.cornerRadius = 12
    }
    
    override func configureHierarchy() {
        contentView.addSubViews(views: [opponentImage, text])
    }
    
    override func setConstraints() {
        opponentImage.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(2)
            make.leading.equalTo(10)
        }
        text.snp.makeConstraints { make in
            make.top.equalTo(opponentImage)
            make.leading.equalTo(opponentImage.snp.trailing).offset(2)
            make.bottom.equalTo(contentView).offset(-2)
        }
    }

}

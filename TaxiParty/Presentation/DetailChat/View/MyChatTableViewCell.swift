//
//  MyChatTableViewCell.swift
//  TaxiParty
//
//  Created by Greed on 5/18/24.
//

import UIKit
import Then
import SnapKit

final class MyChatTableViewCell: BaseTableViewCell {

    let text = UILabel().then {
        $0.backgroundColor = .pointPurple
        $0.layer.cornerRadius = 12
        $0.textColor = .black
    }
    
    override func configureHierarchy() {
        contentView.addSubViews(views: [text])
    }
    
    override func setConstraints() {
        text.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(2)
            make.trailing.equalTo(contentView).offset(-10)
            make.centerY.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-2)
        }
    }

}

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

    let text = PaddingLabel().then {
        $0.backgroundColor = .tabbar
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    override func configureHierarchy() {
        contentView.addSubViews(views: [text])
    }
    
    override func setConstraints() {
        text.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(2)
            make.leading.greaterThanOrEqualTo(contentView).offset(20)
            make.trailing.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-2)
        }
    }

}

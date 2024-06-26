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

    let text = PaddingTextView(backgroundColor: .tabbar)
    let date = UILabel().then {
        $0.font = .Spoqa(size: 8, weight: .medium)
        $0.textColor = .systemGray2
    }
    
    override func configureHierarchy() {
        contentView.addSubViews(views: [text, date])
    }
    
    override func setConstraints() {
        text.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(2)
            make.trailing.equalTo(contentView).offset(-20)
            make.bottom.equalTo(contentView).offset(-2)
            make.width.lessThanOrEqualTo(280)
        }
        date.snp.makeConstraints { make in
            make.bottom.equalTo(text.snp.bottom)
            make.trailing.equalTo(text.snp.leading).offset(-5)
        }
    }
    
    func configureCell(item: ChatInfo) {
        text.text = item.chatModel.content
        
        if item.isSameTime {
            date.text = ""
        } else {
            date.text = convertToTextDateFormat(item.chatModel.createdAt)
        }
    }

}

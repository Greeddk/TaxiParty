//
//  DetailChatView.swift
//  TaxiParty
//
//  Created by Greed on 5/18/24.
//

import UIKit
import Then
import SnapKit

final class DetailChatView: BaseView {

    let tableView = UITableView().then {
        $0.register(MyChatTableViewCell.self, forCellReuseIdentifier: MyChatTableViewCell.identifier)
        $0.register(OpponentChatTableViewCell.self, forCellReuseIdentifier: OpponentChatTableViewCell.identifier)
    }
    let textField = UITextField().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.pointPurple.cgColor
        $0.layer.borderWidth = 1
        $0.addLeftPadding()
    }
    let sendButton = UIButton().then {
        $0.setImage(UIImage(systemName: "paperplane"), for: .normal)
    }
    
    override func setHierarchy() {
        addSubViews(views: [tableView, textField, sendButton])
    }
    
    override func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self)
            make.bottom.equalTo(textField.snp.top)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-4)
            make.height.equalTo(40)
        }
        sendButton.snp.makeConstraints { make in
            make.trailing.equalTo(self).offset(-20)
            make.centerY.equalTo(textField)
            make.size.equalTo(32)
        }
    }
    
    override func setupAttributes() {
        tableView.separatorStyle = .none
    }

}

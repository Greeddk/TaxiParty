//
//  ChatListView.swift
//  TaxiParty
//
//  Created by Greed on 5/26/24.
//

import UIKit
import SnapKit
import Then

final class ChatListView: BaseView {

    let tableView = UITableView()
    
    override func setHierarchy() {
        addSubViews(views: [tableView])
    }
    
    override func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-45)
        }
    }
    
    override func setupAttributes() {
        tableView.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: ChatRoomTableViewCell.identifier)
        tableView.separatorStyle = .none
    }

}

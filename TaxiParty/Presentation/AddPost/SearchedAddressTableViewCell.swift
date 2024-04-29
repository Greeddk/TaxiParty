//
//  SearchedAddressTableViewCell.swift
//  TaxiParty
//
//  Created by Greed on 4/28/24.
//

import UIKit
import Then
import SnapKit

final class SearchedAddressTableViewCell: BaseTableViewCell {

    let placeName = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .regular)
    }
    let address = UILabel().then {
        $0.font = .Spoqa(size: 13, weight: .regular)
        $0.textColor = .systemGray3
    }
    let selectButton = UIButton().then {
        $0.setTitle("선택", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .Spoqa(size: 12, weight: .regular)
        $0.layer.cornerRadius = 4
        $0.layer.borderColor = UIColor.systemGray3.cgColor
        $0.layer.borderWidth = 1
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        self.addSubViews(views: [placeName, address, selectButton])
    }
    
    override func setConstraints() {
        placeName.snp.makeConstraints { make in
            make.top.leading.equalTo(self).offset(15)
            make.trailing.equalTo(self).offset(-60)
        }
        address.snp.makeConstraints { make in
            make.top.equalTo(placeName.snp.bottom)
            make.leading.equalTo(placeName)
            make.bottom.equalTo(self).offset(-15)
        }
        selectButton.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).offset(-15)
            make.width.equalTo(40)
            make.height.equalTo(25)
        }
    }
}

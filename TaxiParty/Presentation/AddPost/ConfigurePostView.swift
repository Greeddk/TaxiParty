//
//  ConfigurePostViewController.swift
//  TaxiParty
//
//  Created by Greed on 4/22/24.
//

import UIKit
import SnapKit
import Then

final class ConfigurePostView: BaseView {

    let backButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let image = UIImage(systemName: "arrow.backward", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.tintColor = .black
        $0.isHidden = true
    }
    let startPointTextField = AddressTextField().then {
        $0.font = .Spoqa(size: 16, weight: .regular)
    }
    private let intervalLine = UIView().then {
        $0.backgroundColor = .systemGray6
    }
    let destinationTextField = AddressTextField().then {
        $0.font = .Spoqa(size: 16, weight: .regular)
        $0.placeholder = "어디로 갈까요?"
    }
    let dividerView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.isHidden = true
    }
    let headerLabel = UILabel().then {
        $0.text = "장소결과"
        $0.font = .Spoqa(size: 14, weight: .regular)
        $0.textColor = .systemGray3
        $0.isHidden = true
    }
    let tableView = UITableView().then {
        $0.isHidden = true
    }

    override func setHierarchy() {
        addSubViews(views: [backButton, startPointTextField, intervalLine, destinationTextField, dividerView, headerLabel, tableView])
    }
    
    override func setupLayout() {
        backButton.snp.makeConstraints { make in
            make.bottom.equalTo(startPointTextField.snp.top)
            make.leading.equalTo(20)
            make.size.equalTo(32)
        }
        startPointTextField.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.left.equalTo(self).offset(30)
            make.horizontalEdges.equalTo(self).inset(20)
            make.height.equalTo(50)
        }
        intervalLine.snp.makeConstraints { make in
            make.top.equalTo(startPointTextField.snp.bottom)
            make.horizontalEdges.equalTo(startPointTextField).inset(24)
            make.height.equalTo(1)
        }
        destinationTextField.snp.makeConstraints { make in
            make.top.equalTo(startPointTextField.snp.bottom)
            make.left.equalTo(startPointTextField)
            make.horizontalEdges.equalTo(startPointTextField)
            make.height.equalTo(50)
        }
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(destinationTextField.snp.bottom).offset(30)
            make.width.equalTo(self)
            make.height.equalTo(8)
        }
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).offset(20)
            make.leading.equalTo(15)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self)
            make.bottom.equalTo(self).offset(-85)
        }
    }
    
    override func setupAttributes() {
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchedAddressTableViewCell.self, forCellReuseIdentifier: SearchedAddressTableViewCell.identifier)
    }
}

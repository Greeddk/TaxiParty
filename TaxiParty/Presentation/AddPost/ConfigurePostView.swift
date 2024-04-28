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
    let tableView = UITableView()

    override func setHierarchy() {
        addSubViews(views: [backButton, startPointTextField, intervalLine, destinationTextField, tableView])
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
            make.height.equalTo(60)
        }
        intervalLine.snp.makeConstraints { make in
            make.top.equalTo(startPointTextField.snp.bottom)
            make.horizontalEdges.equalTo(startPointTextField).inset(10)
            make.height.equalTo(1)
        }
        destinationTextField.snp.makeConstraints { make in
            make.top.equalTo(startPointTextField.snp.bottom)
            make.left.equalTo(startPointTextField)
            make.horizontalEdges.equalTo(startPointTextField)
            make.height.equalTo(60)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(destinationTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}

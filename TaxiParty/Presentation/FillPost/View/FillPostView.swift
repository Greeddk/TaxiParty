//
//  FillPostView.swift
//  TaxiParty
//
//  Created by Greed on 4/30/24.
//

import UIKit
import SnapKit
import Then

final class FillPostView: BaseView {
    
    let title = PointBorderTextField().then {
        $0.placeholder = "택시팟 모집 문구를 작성해주세요"
        $0.font = .Spoqa(size: 16, weight: .medium)
    }
    private let routeLabel = UILabel().then {
        $0.text = "택시팟 루트"
        $0.font = .Spoqa(size: 12, weight: .regular)
    }
    private let startPointIcon = UIImageView().then {
        $0.image = UIImage(named: "startPoint")
    }
    private let destinationIcon = UIImageView().then {
        $0.image = UIImage(named: "destination")
    }
    private let interLineImage = UIImageView().then {
        $0.image = UIImage(named: "dotLine")
    }
    let startPointLabel = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .bold)
    }
    let destinationLabel = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .bold)
    }
    private let startInfoLabel = UILabel().then {
        $0.font = .Spoqa(size: 12, weight: .medium)
        $0.textColor = .lightGray
        $0.text = "출발지"
    }
    private let destinationInfoLabel = UILabel().then {
        $0.font = .Spoqa(size: 12, weight: .medium)
        $0.textColor = .lightGray
        $0.text = "도착지"
    }
    private let countStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalCentering
    }
    private let countLabel = UILabel().then {
        $0.text = "몇 분과 파티 하실래요? (본인포함)"
        $0.font = .Spoqa(size: 12, weight: .regular)
    }
    private let countContentView = UIView()
    let countMinusButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let image = UIImage(systemName: "minus.circle", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.tintColor = .pointPurple
    }
    let countPlusButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.tintColor = .pointPurple
    }
    let peopleCount = UILabel().then {
        $0.text = "2"
        $0.textAlignment = .center
    }
    private let dueDateLabel = UILabel().then {
        $0.text = "언제 출발하세요?"
        $0.font = .Spoqa(size: 12, weight: .regular)
    }
    let dueDate = UIDatePicker().then {
        $0.preferredDatePickerStyle = .compact
        $0.datePickerMode = .dateAndTime
        $0.locale = Locale(identifier: "ko_KR")
        $0.tintColor = .pointPurple
    }
    let postButton = PointColorButton().then {
        $0.setTitle("파티 구하기", for: .normal)
    }
    
    override func setHierarchy() {
        addSubViews(views: [title, routeLabel, startPointIcon, destinationIcon, interLineImage, startPointLabel, destinationLabel, startInfoLabel, destinationInfoLabel, countLabel, countStackView, dueDateLabel, dueDate, postButton])
        countStackView.addArrangedSubview(countMinusButton)
        countStackView.addArrangedSubview(peopleCount)
        countStackView.addArrangedSubview(countPlusButton)
    }
    
    override func setupLayout() {
        title.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalTo(self).inset(30)
            make.height.equalTo(50)
        }
        routeLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(30)
            make.leading.equalTo(self).offset(20)
        }
        startPointIcon.snp.makeConstraints { make in
            make.top.equalTo(routeLabel.snp.bottom).offset(10)
            make.leading.equalTo(title)
            make.size.equalTo(24)
        }
        startPointLabel.snp.makeConstraints { make in
            make.leading.equalTo(startPointIcon.snp.trailing).offset(12)
            make.centerY.equalTo(startPointIcon)
        }
        startInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(startPointLabel.snp.bottom).offset(0)
            make.leading.equalTo(startPointLabel)
        }
        destinationIcon.snp.makeConstraints { make in
            make.top.equalTo(startPointIcon.snp.bottom).offset(30)
            make.centerX.equalTo(startPointIcon)
            make.width.equalTo(18.45)
            make.height.equalTo(24)
        }
        destinationLabel.snp.makeConstraints { make in
            make.leading.equalTo(startPointLabel)
            make.centerY.equalTo(destinationIcon)
        }
        destinationInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(destinationLabel.snp.bottom).offset(0)
            make.leading.equalTo(destinationLabel)
        }
        interLineImage.snp.makeConstraints { make in
            make.top.equalTo(startPointIcon.snp.bottom)
            make.bottom.equalTo(destinationIcon.snp.top)
            make.centerX.equalTo(startPointIcon)
            make.width.equalTo(5)
        }
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(destinationInfoLabel.snp.bottom).offset(30)
            make.leading.equalTo(self).offset(20)
        }
        countStackView.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self).inset(120)
            make.height.equalTo(50)
        }
        dueDateLabel.snp.makeConstraints { make in
            make.top.equalTo(countStackView.snp.bottom).offset(30)
            make.leading.equalTo(self).offset(20)
        }
        dueDate.snp.makeConstraints { make in
            make.top.equalTo(dueDateLabel.snp.bottom).offset(20)
            make.centerX.equalTo(self)
        }
        postButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-40)
            make.horizontalEdges.equalTo(self).inset(20)
            make.height.equalTo(60)
        }
    }
    
    func updateRoute(start: String, destination: String) {
        startPointLabel.text = start
        destinationLabel.text = destination
    }
}

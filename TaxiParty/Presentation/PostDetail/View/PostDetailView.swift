//
//  PostDetailView.swift
//  TaxiParty
//
//  Created by Greed on 5/3/24.
//

import UIKit
import SnapKit
import Then

final class PostDetailView: BaseView {
    
    private let title = UILabel().then {
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
    private let startPointLabel = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .bold)
        $0.numberOfLines = 0
    }
    private let destinationLabel = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .bold)
        $0.numberOfLines = 0
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
    private let taxiFareInfoLabel = UILabel().then {
        $0.font = .Spoqa(size: 12, weight: .medium)
        $0.textColor = .lightGray
        $0.text = "예상 택시비"
    }
    private let taxiFareLabel = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .bold)
        $0.textColor = .pointPurple
    }
    private let taxiFarePerOneInfoLabel = UILabel().then {
        $0.font = .Spoqa(size: 12, weight: .medium)
        $0.textColor = .lightGray
        $0.text = "1인당 예상 택시비"
    }
    private let taxiFarePerOneLabel = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .bold)
        $0.textColor = .pointPurple
    }
    private let numberOfPeople = UILabel().then {
        $0.font = .Spoqa(size: 12, weight: .regular)
    }
    private let dueDateLabel = UILabel().then {
        $0.text = "출발 일정"
        $0.font = .Spoqa(size: 12, weight: .regular)
    }
    private let dueDate = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .medium)
    }
    private let joinNumInfoLabel = UILabel().then {
        $0.font = .Spoqa(size: 12, weight: .regular)
        $0.text = "같이 타는 인원"
    }
    private let joinNumLabel = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .medium)
    }
    private let mapView = BaseMapView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    let joinButton = PointColorButton().then {
        $0.setTitle("택시 같이타기", for: .normal)
    }
    
    override func setHierarchy() {
        addSubViews(views: [title, routeLabel, startPointIcon, startPointLabel, startInfoLabel, destinationIcon, destinationLabel, destinationInfoLabel, interLineImage, taxiFareInfoLabel, taxiFareLabel, taxiFarePerOneInfoLabel, taxiFarePerOneLabel, numberOfPeople, dueDate, dueDateLabel, joinNumInfoLabel, joinNumLabel, mapView, joinButton])
    }
    
    override func setupLayout() {
        title.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self).inset(20)
            make.height.equalTo(50)
        }
        routeLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
        }
        startPointIcon.snp.makeConstraints { make in
            make.top.equalTo(routeLabel.snp.bottom).offset(10)
            make.leading.equalTo(title)
            make.size.equalTo(24)
        }
        startPointLabel.snp.makeConstraints { make in
            make.top.equalTo(startPointIcon)
            make.leading.equalTo(startPointIcon.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(taxiFareInfoLabel.snp.leading)
        }
        startInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(startPointLabel.snp.bottom).offset(0)
            make.leading.equalTo(startPointLabel)
        }
        destinationIcon.snp.makeConstraints { make in
            make.top.equalTo(startPointIcon.snp.bottom).offset(20)
            make.centerX.equalTo(startPointIcon)
            make.width.equalTo(18.45)
            make.height.equalTo(24)
        }
        destinationLabel.snp.makeConstraints { make in
            make.top.equalTo(destinationIcon)
            make.leading.equalTo(startPointLabel)
            make.trailing.lessThanOrEqualTo(taxiFarePerOneInfoLabel.snp.leading)
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
        taxiFareInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(startPointLabel)
            make.trailing.equalTo(self).offset(-60)
        }
        taxiFareLabel.snp.makeConstraints { make in
            make.top.equalTo(taxiFareInfoLabel.snp.bottom)
            make.leading.equalTo(taxiFareInfoLabel)
        }
        taxiFarePerOneInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(destinationLabel)
            make.leading.equalTo(taxiFareInfoLabel)
        }
        taxiFarePerOneLabel.snp.makeConstraints { make in
            make.top.equalTo(taxiFarePerOneInfoLabel.snp.bottom)
            make.leading.equalTo(taxiFarePerOneInfoLabel)
        }
        dueDateLabel.snp.makeConstraints { make in
            make.top.equalTo(destinationInfoLabel.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(20)
        }
        dueDate.snp.makeConstraints { make in
            make.top.equalTo(dueDateLabel.snp.bottom).offset(10)
            make.centerX.equalTo(self)
        }
        joinNumInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(dueDate.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(20)
        }
        joinNumLabel.snp.makeConstraints { make in
            make.top.equalTo(joinNumInfoLabel.snp.bottom).offset(10)
            make.centerX.equalTo(self)
        }
        mapView.snp.makeConstraints { make in
            make.top.equalTo(joinNumLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self).inset(20)
            make.bottom.equalTo(joinButton.snp.top).offset(-10)
        }
        joinButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-40)
            make.horizontalEdges.equalTo(self).inset(20)
            make.height.equalTo(60)
        }
    }
    
    func configureCell(item: Post, startPlace: String, destination: String, togetherNum: Int) {
        title.text = item.title
        startPointLabel.text = startPlace
        destinationLabel.text = destination
        dueDate.text = calculateLeftTime(item.dueDate) 
        let availableNum = (Int(item.numberOfPeople) ?? 4) - 1 - togetherNum
        joinNumLabel.text = availableNum <= 0 ? "마감" : "\(item.numberOfPeople) 자리 중 \(availableNum) 자리 남음"
    }
    
    func updateMapView(item: DirectionModel, currentNum: String) {
        mapView.updateMapRoute(item: item)
        taxiFareLabel.text = "\(item.route.trafast[0].summary.taxiFare)원"
        taxiFarePerOneLabel.text =
        "\(item.route.trafast[0].summary.taxiFare / (Int(currentNum) ?? 4))원"
    }
    
}

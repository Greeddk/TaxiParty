//
//  PartyPostCollectionViewCell.swift
//  TaxiParty
//
//  Created by Greed on 4/21/24.
//

import UIKit
import SnapKit
import Then

final class PartyPostCollectionViewCell: BaseCollectionViewCell {
    
    private let backView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayBorder.cgColor
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 7
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    let creatorImage = RoundImageView(frame: .zero)
    let creatorNick = UILabel().then {
        $0.font = .Spoqa(size: 12, weight: .medium)
    }
    private let title = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .medium)
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
    let dueDateLabel = UILabel().then {
        $0.font = .Spoqa(size: 14, weight: .regular)
        $0.text = "7시간 남음"
    }
    let leftNum = UILabel().then {
        $0.font = .Spoqa(size: 16, weight: .bold)
    }
    
    override func configureHierarchy() {
        self.addSubViews(views: [backView, creatorImage, creatorNick, title, startPointIcon, destinationIcon, interLineImage, interLineImage, startPointLabel, destinationLabel, startInfoLabel, destinationInfoLabel, dueDateLabel, leftNum])
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
        creatorImage.snp.makeConstraints { make in
            make.top.leading.equalTo(backView).offset(20)
            make.size.equalTo(24)
        }
        creatorNick.snp.makeConstraints { make in
            make.leading.equalTo(creatorImage.snp.trailing).offset(4)
            make.centerY.equalTo(creatorImage)
        }
        title.snp.makeConstraints { make in
            make.top.equalTo(creatorImage.snp.bottom).offset(10)
            make.leading.equalTo(creatorImage)
        }
        dueDateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(backView.snp.trailing).offset(-20)
            make.centerY.equalTo(creatorImage)
        }
        startPointIcon.snp.makeConstraints { make in
            make.top.equalTo(creatorImage.snp.bottom).offset(40)
            make.leading.equalTo(backView).offset(20)
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
        leftNum.snp.makeConstraints { make in
            make.trailing.equalTo(backView.snp.trailing).offset(-20)
            make.bottom.equalTo(backView.snp.bottom).offset(-20)
        }
    }
    
    func configureCell(post: Post) {
        title.text = post.title
        creatorImage.image = UIImage(systemName: "person")
        creatorNick.text = post.creator.nick
        startPointLabel.text = post.startPlaceData
        destinationLabel.text = post.destinationData
        leftNum.text = "\((Int(post.numberOfPeople) ?? 4) - 1 - post.together.count)명 남음"
    }
}

//
//  NoNetworkView.swift
//  TaxiParty
//
//  Created by Greed on 5/10/24.
//

import UIKit
import Then
import SnapKit

final class NoNetworkView: BaseView {

    let image = UIImageView().then {
        $0.image = UIImage(systemName: "wifi.exclamationmark")
        $0.tintColor = .pointPurple
    }
    let label = UILabel().then {
        $0.font = .Spoqa(size: 16, weight: .bold)
        $0.text = "인터넷 연결 상태를 확인해주세요!"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray4.withAlphaComponent(0.8)
    }
  
    override func setHierarchy() {
        addSubViews(views: [image, label])
    }
    
    override func setupLayout() {
        image.snp.makeConstraints { make in
            make.centerY.equalTo(self).offset(-50)
            make.centerX.equalTo(self)
            make.size.equalTo(100)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(10)
            make.centerX.equalTo(self)
        }
    }

}

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

    let backButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let image = UIImage(systemName: "arrow.backward", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.tintColor = .black
    }
    let title = UILabel()
    let startPointLabel = UILabel()
    let destinationLabel = UILabel()
    let dueDate = UIPickerView()
    let content = UITextView()
    
    override func setHierarchy() {
        addSubViews(views: [title, startPointLabel, destinationLabel, dueDate])
    }
    
    override func setupLayout() {
        backButton.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(30)
            make.leading.equalTo(20)
            make.size.equalTo(32)
        }
    }
    
    
}

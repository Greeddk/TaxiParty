//
//  PaddingTextView.swift
//  TaxiParty
//
//  Created by Greed on 5/20/24.
//

import UIKit

final class PaddingTextView: UITextView {
    
    init(backgroundColor: UIColor) {
        super.init(frame: .zero, textContainer: nil)
        self.isScrollEnabled = false
        self.isEditable = false
        self.backgroundColor = backgroundColor // 전달받은 배경 색상 설정
        self.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.font = .Spoqa(size: 14, weight: .medium)
        self.layer.cornerRadius = 12
        self.sizeToFit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  BottomSheetView.swift
//  TaxiParty
//
//  Created by Greed on 4/24/24.
//

import UIKit
import SnapKit

final class BottomSheetView: PassThroughView {
    
    enum Mode {
        case tip
        case full
    }
    
    private enum Const {
        static let duration = 0.5
        static let cornerRadius = 20.0
        static let bottomSheetRatio: (Mode) -> Double = { mode in
            switch mode {
            case .tip:
                return 0.7
            case .full:
                return 0
            }
        }
        static let bottomSheetYPosition: (Mode) -> Double = { mode in
            Self.bottomSheetRatio(mode) * UIScreen.main.bounds.height
        }
    }
    
    let bottomSheetView = ConfigurePostView()
    let addressLabel = UILabel()
    
    lazy var mode: Mode = .tip {
        didSet {
            switch self.mode {
            case .tip:
                self.bottomSheetView.backButton.isHidden = true
                self.bottomSheetView.dividerView.isHidden = true
                self.bottomSheetView.headerLabel.isHidden = true
                self.bottomSheetView.tableView.isHidden = true
                break
            case .full:
                self.bottomSheetView.backButton.isHidden = false
                self.bottomSheetView.dividerView.isHidden = false
                self.bottomSheetView.headerLabel.isHidden = false
                self.bottomSheetView.tableView.isHidden = false
                break
            }
            self.updateConstraint(offset: Const.bottomSheetYPosition(self.mode))
        }
    }
    var bottomSheetColor: UIColor? {
        didSet { self.bottomSheetView.backgroundColor = self.bottomSheetColor }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init() has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize.zero
        
        self.backgroundColor = .clear
        
        self.bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.bottomSheetView.layer.cornerRadius = Const.cornerRadius
        self.bottomSheetView.clipsToBounds = true
        
        self.addSubview(self.bottomSheetView)
        
        self.bottomSheetView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(Const.bottomSheetYPosition(.tip))
            $0.bottom.equalTo(keyboardLayoutGuide)
        }
        
        self.bottomSheetView.startPointTextField.addTarget(self, action: #selector(textFieldTapped), for: .editingDidBegin)
        self.bottomSheetView.destinationTextField.addTarget(self, action: #selector(textFieldTapped), for: .editingDidBegin)
        self.bottomSheetView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped(sender: UIButton) {
        UIView.animate(
            withDuration: Const.duration,
            delay: 0,
            options: .allowAnimatedContent,
            animations: {
                self.mode = .tip
            },
            completion: nil
        )
    }
    
    @objc private func textFieldTapped(sender: UITextField) {
        UIView.animate(
            withDuration: Const.duration,
            delay: 0,
            options: .allowAnimatedContent,
            animations: {
                self.mode = .full
            },
            completion: nil
        )
    }
    
    private func updateConstraint(offset: Double) {
        self.bottomSheetView.snp.remakeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(offset)
        }
    }
    
}

//
//  SettingViewController.swift
//  TaxiParty
//
//  Created by Greed on 4/19/24.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

struct SettingRepresentableView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> some UIViewController {
        SettingViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

final class SettingViewController: BaseViewController {
    
    let label = UILabel()
    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        label.text = "세팅이라고 생각하셈"
        
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(label).offset(30)
            make.centerX.equalTo(view)
        }
        button.setTitle("프로필 조회", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        
    }
    
    override func bind() {
        button.rx.tap
            .flatMap {
                return NetworkManager.shared.callRequest(type: ProfileModel.self, router: APIRouter.profileRouter(.fetchProfile).convertToURLRequest())
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    print(success)
                    owner.label.text = "\(success.email) \(success.user_id)"
                case .failure(let error):
                    print(error)
                    switch error {
                    case .expireRefreshToken:
                        print("리프레시 토큰 만료")
                    default:
                        print("error")
                    }
                }
            }
            .disposed(by: disposeBag)
    }

}

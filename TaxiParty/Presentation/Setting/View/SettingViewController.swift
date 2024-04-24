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

    let mainView = SettingView()
    let viewModel = SettingViewModel()
    
    let viewDidLoadTrigger = PublishRelay<Void>()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadTrigger.accept(())
    }
    
    override func bind() {
        
        let withdrawTrigger = PublishRelay<Void>()
        
        let input = SettingViewModel.Input(fetchProfile: viewDidLoadTrigger.asObservable(), withdrawButtonTapped: mainView.withdrawButton.rx.tap.asObservable(), withdrawTrigger: withdrawTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.profileInfo
            .drive(with: self) { owner, value in
                owner.mainView.configureView(profile: value)
            }
            .disposed(by: disposeBag)
        
        output.showAlertTrigger
            .drive(with: self) { owner, _ in
                owner.showAlert {
                    withdrawTrigger.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        output.withdrawComplete
            .drive(with: self) { owner, _ in
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate

                sceneDelegate?.window?.rootViewController = UINavigationController(rootViewController: LogInViewController())
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            .disposed(by: disposeBag)
    }
    
    func showAlert(action: @escaping () -> Void) {
        let alert = UIAlertController(title: "탈퇴", message: "정말 회원 탈퇴하실거예요?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "네", style: .default) { _ in
            action()
        }
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }

}

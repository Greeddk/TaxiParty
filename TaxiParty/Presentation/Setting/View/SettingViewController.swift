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

protocol fetchNewData {
    func fetch()
}

struct SettingRepresentableView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> some UIViewController {
        SettingViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

final class SettingViewController: BaseViewController, fetchNewData {

    let mainView = SettingView()
    let viewModel = SettingViewModel()
    
    let fetchDataTrigger = PublishRelay<Void>()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataTrigger.accept(())
    }
    
    override func bind() {
        
        let withdrawTrigger = PublishRelay<Void>()
        
        let input = SettingViewModel.Input(
            fetchProfile: fetchDataTrigger.asObservable(),
            withdrawButtonTapped: mainView.withdrawButton.rx.tap.asObservable(),
            withdrawTrigger: withdrawTrigger.asObservable(),
            modifyButtonTapped: mainView.editButton.rx.tap.asObservable())
        
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
        
        output.moveToModifyPage
            .withLatestFrom(output.profileInfo) { ($0, $1) }
            .map { (value: $0.0, profile: $0.1) }
            .drive(with: self) { owner, value in
                if value.value {
                    let modifyViewModel = ModifyProfileViewModel(profileData: value.profile)
                    let modifyVC = ModifyProfileViewController(viewModel: modifyViewModel)
                    modifyVC.delegate = self
                    owner.navigationController?.pushViewController(modifyVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.tableViewMenu
            .drive(mainView.tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = element
                cell.accessoryType = .disclosureIndicator
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rx
            .itemSelected
            .bind(with: self) { owner, indexPath in
                owner.mainView.tableView.deselectRow(at: indexPath, animated: true)
                if indexPath.row == 0 {
                    owner.navigationController?.pushViewController(PostHistoryViewController(), animated: true)
                } else {
                    owner.navigationController?.pushViewController(JoinPartyListViewController(), animated: true)
                }
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

    func fetch() {
        fetchDataTrigger.accept(())
    }
}

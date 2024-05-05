//
//  CompleteSignUpViewController.swift
//  TaxiParty
//
//  Created by Greed on 5/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CompleteSignUpViewController: BaseViewController {
    
    let mainView = CompleteSignUpView()
    let viewModel = CompleteSignUpViewModel()
    let startTimerTrigger = PublishRelay<Void>()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackButton()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        startTimerTrigger.accept(())
    }
    
    override func bind() {
        
        let input = CompleteSignUpViewModel.Input(
            startTimerTrigger: startTimerTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.backToRootViewTrigger
            .drive(with: self) { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

}

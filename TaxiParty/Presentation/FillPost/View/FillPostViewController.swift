//
//  FillPostViewController.swift
//  TaxiParty
//
//  Created by Greed on 4/29/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FillPostViewController: BaseViewController {
    
    let mainView = FillPostView()
    let viewModel = FillPostViewModel()
    let fetchDataTrigger = PublishRelay<Void>()
 
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        setNavigationBackButton()
        navigationItem.title = "파티 만들기"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataTrigger.accept(())
    }
    
    override func bind() {
        
        let input = FillPostViewModel.Input(
            fetchDataTrigger: fetchDataTrigger.asObservable(),
            inputTitleText: mainView.title.rx.text.orEmpty.asObservable(),
            plusButtonTapped: mainView.countPlusButton.rx.tap.asObservable(),
            minusButtonTapped: mainView.countMinusButton.rx.tap.asObservable(),
            dueDate: mainView.dueDate.rx.date.asObservable(),
            postButtonTapped: mainView.postButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.startPlaceName
            .drive(mainView.startPointLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.destinationName
            .drive(mainView.destinationLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.currentPeopleNum
            .drive(with: self, onNext: { owner, value in
                owner.mainView.peopleCount.text = value
            })
            .disposed(by: disposeBag)
        
        output.enablePlusButton
            .drive(mainView.countPlusButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.enableMinusButton
            .drive(mainView.countMinusButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

}

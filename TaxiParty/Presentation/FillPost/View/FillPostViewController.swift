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
        setNavigationBackButton(title: "파티 만들기")
        fetchDataTrigger.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        output.postComplete
            .drive(with: self) { owner, value in
                if value {
                    //TODO: 탭바 첫 페이지로 이동...
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.errorAlertTrigger
            .drive(with: self) { owner, value in
                if value {
                    owner.showAlertOnlyOK(title: "포스트 에러", message: "택시팟 모집글을 다시 작성해주세요", action: { })
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(output.directionInfo.asObservable(), output.currentPeopleNum.asObservable())
            .bind(with: self) { owner, value in
                owner.mainView.updateMapView(item: value.0, currentNum: value.1)
            }
            .disposed(by: disposeBag)
    }

}

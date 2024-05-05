//
//  CompleteSignUpViewModel.swift
//  TaxiParty
//
//  Created by Greed on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CompleteSignUpViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let startTimerTrigger: Observable<Void>
    }
    
    struct Output {
        let backToRootViewTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let backToRootViewTrigger = PublishRelay<Void>()
        
        input.startTimerTrigger
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .bind(onNext: {
                backToRootViewTrigger.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(backToRootViewTrigger: backToRootViewTrigger.asDriver(onErrorJustReturn: ()))
    }
    
}

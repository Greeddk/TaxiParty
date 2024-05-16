//
//  NearMapViewModel.swift
//  TaxiParty
//
//  Created by Greed on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NearMapViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let fetchDataTrigger: Observable<Void>
        let moveToDetailViewTrigger: Observable<ControlEvent<UITapGestureRecognizer>.Element>
    }
    
    struct Output {
        let fetchedData: Driver<[Post]>
        let moveToDetailViewTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let nextCursor = PublishRelay<String>()
        var dataSource: [Post] = []
        let fetchedData = PublishRelay<[Post]>()
        let moveToDetailViewTrigger = PublishRelay<Void>()
        
        input.fetchDataTrigger
            .flatMap {
                return NetworkManager.shared.callRequest(type: FetchPostModel.self, router: .postRouter(.fetchPost(next: "", limit: 500)))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    print(success.data)
                    dataSource.append(contentsOf: success.data)
                    fetchedData.accept(dataSource)
                    nextCursor.accept(success.nextCursor)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.moveToDetailViewTrigger
            .bind(with: self) { onwer, _ in
                moveToDetailViewTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            fetchedData: fetchedData.asDriver(onErrorJustReturn: []),
            moveToDetailViewTrigger: moveToDetailViewTrigger.asDriver(onErrorJustReturn: ())
        )
    }
    
}

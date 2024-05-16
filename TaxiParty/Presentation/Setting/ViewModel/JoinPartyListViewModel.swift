//
//  JoinPartyListViewModel.swift
//  TaxiParty
//
//  Created by Greed on 5/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class JoinPartyListViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let fetchDataTrigger: Observable<Void>
        let paginationTrigger: Observable<Void>
    }
    
    struct Output {
        let fetchedData: Driver<[Post]>
    }
    
    func transform(input: Input) -> Output {
        
        let nextCursor = PublishRelay<String>()
        var dataSource: [Post] = []
        let fetchedData = PublishRelay<[Post]>()
        
        input.fetchDataTrigger
            .flatMap {
                return NetworkManager.shared.callRequest(type: FetchPostModel.self, router: .postRouter(.fetchJoinPosts(next: "")))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    dataSource.append(contentsOf: success.data)
                    fetchedData.accept(dataSource)
                    nextCursor.accept(success.nextCursor)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.paginationTrigger
            .withLatestFrom(nextCursor)
            .filter { $0 != "0" }
            .flatMapLatest { nextCursor in
                return NetworkManager.shared.callRequest(type: FetchPostModel.self, router: .postRouter(.fetchJoinPosts(next: nextCursor)))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    dataSource.append(contentsOf: success.data)
                    fetchedData.accept(dataSource)
                    nextCursor.accept(success.nextCursor)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            fetchedData: fetchedData.asDriver(onErrorJustReturn: [])
        )
    }
    
}

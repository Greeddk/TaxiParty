//
//  SearchPostViewModel.swift
//  TaxiParty
//
//  Created by Greed on 5/1/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchPostViewModel: ViewModelProtocol {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let fetchDataTrigger: Observable<Void>
    }
    
    struct Output {
        let fetchedData: Driver<[Post]>
    }
    
    func transform(input: Input) -> Output {
        
        let fetchedData = PublishRelay<[Post]>()
        
        input.fetchDataTrigger
            .flatMap {
                return NetworkManager.shared.callRequest(type: FetchPostModel.self, router: APIRouter.postRouter(.fetchPost).convertToURLRequest())
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    print(success.data)
                    fetchedData.accept(success.data)
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

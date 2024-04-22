//
//  SettingViewModel.swift
//  TaxiParty
//
//  Created by Greed on 4/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let fetchProfile: Observable<Void>
        let withdrawButtonTapped: Observable<Void>
    }
    
    struct Output {
        let profileInfo: Driver<ProfileModel>
        let withdrawComplete: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let profileInfo = PublishRelay<ProfileModel>()
        let withdrawComplete = PublishRelay<Void>()
        
        input.fetchProfile
            .flatMap {
                return NetworkManager.shared.callRequest(type: ProfileModel.self, router: APIRouter.profileRouter(.fetchProfile).convertToURLRequest())
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    print(success)
                    profileInfo.accept(success)
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
        
        input.withdrawButtonTapped
            .flatMap {
                return NetworkManager.shared.callRequest(type: WithdrawModel.self, router: APIRouter.authenticationRouter(.withdraw).convertToURLRequest())
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    print(success)
                    withdrawComplete.accept(())
                case .failure(let error):
                    switch error {
                    case .invalidToken:
                        print(error)
                    case .expireRefreshToken:
                        print(error)
                    default:
                        print(error)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        
        let errorModel = ProfileModel(user_id: "", email: "", nick: "error", phoneNum: "", profileImage: "", posts: nil)
        return Output(profileInfo: profileInfo.asDriver(onErrorJustReturn: errorModel), withdrawComplete: withdrawComplete.asDriver(onErrorJustReturn: ()))
    }
    
}

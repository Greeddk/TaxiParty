//
//  ModifyProfileViewModel.swift
//  TaxiParty
//
//  Created by Greed on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ModifyProfileViewModel: ViewModelProtocol {
    
    var disposeBag = DisposeBag()
    var profileImage = PublishRelay<Data>()
    
    struct Input {
        let profileImageTapped: Observable<ControlEvent<UITapGestureRecognizer>.Element>
        let nicknameTextFieldText: Observable<String>
        let modifyButtonTapped: Observable<Void>
    }
    
    struct Output {
        let openImagePickerTrigger: Driver<Void>
        let backToSettingViewTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let openImagePickerTrigger = PublishRelay<Void>()
        let backToSettingViewTrigger = PublishRelay<Void>()
        
        let profileObservable = Observable.combineLatest(input.nicknameTextFieldText, profileImage)
            .filter { $0.0.count >= 3 }
            .filter { $0.0.count <= 10 }
        
        input.profileImageTapped
            .bind { _ in
                openImagePickerTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        input.modifyButtonTapped
            .withLatestFrom(profileObservable)
            .flatMap { profile in
                print(profile)
                return NetworkManager.shared.editProfile(data: profile.1, nick: profile.0)
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    print(success)
                    backToSettingViewTrigger.accept(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            openImagePickerTrigger: openImagePickerTrigger.asDriver(onErrorJustReturn: ()),
            backToSettingViewTrigger: backToSettingViewTrigger.asDriver(onErrorJustReturn: ())
        )
    }
    
}

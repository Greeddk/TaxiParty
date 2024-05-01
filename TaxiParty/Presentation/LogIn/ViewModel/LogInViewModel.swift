//
//  LogInViewModel.swift
//  TaxiParty
//
//  Created by Greed on 4/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LogInViewModel: ViewModelProtocol {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let emailTextReturned: Observable<Void>
        let passwordTextReturned: Observable<Void>
        let logInButtonTapped: Observable<Void>
        let signUpButtonTapped: Observable<Void>
    }
    
    struct Output {
        let emailTextReturned: Driver<Void>
        let goSignUpPageTrigger: Driver<Void>
        let loginSuccessTrigger: Driver<Bool>
        let indicatorTrigger: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let loginSuccessTrigger = PublishRelay<Bool>()
        let indicatorTrigger = PublishRelay<Bool>()
        
        let logInObservable = Observable.combineLatest(input.emailText, input.passwordText)
            .map { email, password in
                return LoginQuery(email: email, password: password)
            }
        
        Observable.merge(input.passwordTextReturned, input.logInButtonTapped)
            .withLatestFrom(logInObservable)
            .flatMapLatest { logInQuery in
                indicatorTrigger.accept(true)
                return NetworkManager.shared.callRequest(type: LoginModel.self, router: APIRouter.authenticationRouter(.login(query: logInQuery)).convertToURLRequest())
            }
            .bind { response in
                switch response {
                case .success(let success):
                    print(success)
                    TokenManager.accessToken = success.accessToken
                    TokenManager.refreshToken = success.refreshToken
                    indicatorTrigger.accept(false)
                    loginSuccessTrigger.accept(true)
                case .failure(let error):
                    // TODO: 로그인 실패 라벨로 보내기
                    print(error)
                    indicatorTrigger.accept(false)
                    loginSuccessTrigger.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            emailTextReturned: input.emailTextReturned.asDriver(onErrorJustReturn: ()),
            goSignUpPageTrigger: input.signUpButtonTapped.asDriver(onErrorJustReturn: ()),
            loginSuccessTrigger: loginSuccessTrigger.asDriver(onErrorJustReturn: false),
            indicatorTrigger: indicatorTrigger.asDriver(onErrorJustReturn: false))
    }
    
}

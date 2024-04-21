//
//  SignUpViewModel.swift
//  TaxiParty
//
//  Created by Greed on 4/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel {
    
    let disposeBag = DisposeBag()
    
    let networkManager = NetworkManager.shared
    
    struct Input {
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let nicknameText: Observable<String>
        let phoneNumText: Observable<String>
        let emailTextReturned: Observable<Void>
        let passwordTextReturned: Observable<Void>
        let nicknameTextReturned: Observable<Void>
        let phoneNumTextReturned: Observable<Void>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let infoText: Driver<String>
        let description: Driver<String>
        let hidePasswordTextFieldTrigger: Driver<Bool>
        let hideNicknameTextFieldTrigger: Driver<Bool>
        let hidePhoneNumTextFieldTrigger: Driver<Bool>
        let nextButtonAppearTrigger: Driver<Bool>
        let completeSignUpTrigger: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let hidePasswordTextFieldTrigger = BehaviorRelay(value: true)
        let hideNicknameTextFieldTrigger = BehaviorRelay(value: true)
        let hidePhoneNumTextFieldTrigger = BehaviorRelay(value: true)
        let infoText = BehaviorRelay(value: "이메일을 입력해주세요")
        let descriptionText = PublishRelay<String>()
        let nextButtonAppearTrigger = BehaviorRelay(value: false)
        let completeSignUpTrigger = BehaviorRelay(value: false)
        
        let SignUpObservable = Observable.combineLatest(input.emailText, input.passwordText, input.nicknameText, input.phoneNumText)
            .map { email, password, nick, phoneNum in
                return SignUpQuery(email: email, password: password, nick: nick, phoneNum: phoneNum)
            }
        
        Observable.merge(input.phoneNumTextReturned, input.nextButtonTapped)
            .withLatestFrom(SignUpObservable)
            .flatMap { signUpQuery in
                return NetworkManager.shared.callRequest(type: SignUpModel.self, router: APIRouter.authenticationRouter(.join(query: joinQuery(email: signUpQuery.email, password: signUpQuery.password, nick: signUpQuery.nick, phoneNum: signUpQuery.phoneNum))).convertToURLRequest())
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let success):
                    print(success)
                    completeSignUpTrigger.accept(true)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.emailTextReturned
            .withLatestFrom(input.emailText)
            .flatMap { email in
                if email.contains("@") && email.contains(".") {
                    return Observable.just(email)
                } else {
                    descriptionText.accept("올바른 이메일 형식이 아니예요")
                    hidePasswordTextFieldTrigger.accept(true)
                    return Observable.empty()
                }
            }
            .flatMap { email in
                descriptionText.accept("이메일 중복 체크 중이에요")
                return self.networkManager.callRequest(
                    type: ValidationEmailModel.self,
                    router: APIRouter.authenticationRouter(.validationEmail(query: validationEmail(email: email)))
                        .convertToURLRequest()
                )
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let success):
                    infoText.accept("비밀번호를 입력해주세요")
                    descriptionText.accept("")
                    hidePasswordTextFieldTrigger.accept(false)
                case .failure(let error):
                    print(error)
                    
                    descriptionText.accept("중복된 이메일이에요")
                    hidePasswordTextFieldTrigger.accept(true)
                }
            }
            .disposed(by: disposeBag)

        
        input.passwordTextReturned
            .withLatestFrom(input.passwordText)
            .bind(with: self) { owner, password in
                guard password.count >= 8 else {
                    descriptionText.accept("8자리 이상의 비밀번호가 필요해요")
                    hideNicknameTextFieldTrigger.accept(true)
                    return
                }
                infoText.accept("닉네임을 입력해주세요")
                descriptionText.accept("")
                hideNicknameTextFieldTrigger.accept(false)
            }
            .disposed(by: disposeBag)
        
        input.nicknameTextReturned
            .withLatestFrom(input.nicknameText)
            .bind(with: self) { owner, nick in
                guard nick.count >= 3 && nick.count <= 10 else {
                    descriptionText.accept("3자리 이상 10자리 이하의 닉네임만 쓸 수 있어요")
                    hidePhoneNumTextFieldTrigger.accept(true)
                    return
                }
                infoText.accept("전화번호를 입력해주세요")
                hidePhoneNumTextFieldTrigger.accept(false)
            }
            .disposed(by: disposeBag)
        
        input.phoneNumText
            .bind(with: self) { owner, value in
                if value.count > 11 {
                    nextButtonAppearTrigger.accept(false)
                } else {
                    nextButtonAppearTrigger.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            infoText: infoText.asDriver(),
            description: descriptionText.asDriver(onErrorJustReturn: ""),
            hidePasswordTextFieldTrigger: hidePasswordTextFieldTrigger.asDriver(),
            hideNicknameTextFieldTrigger: hideNicknameTextFieldTrigger.asDriver(),
            hidePhoneNumTextFieldTrigger: hidePhoneNumTextFieldTrigger.asDriver(),
            nextButtonAppearTrigger: nextButtonAppearTrigger.asDriver(),
            completeSignUpTrigger: completeSignUpTrigger.asDriver())
    }
    
}

struct SignUpQuery {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String
}

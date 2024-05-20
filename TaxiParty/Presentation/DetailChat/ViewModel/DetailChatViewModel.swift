//
//  DetailChatViewModel.swift
//  TaxiParty
//
//  Created by Greed on 5/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailChatViewModel {
    
    let disposeBag = DisposeBag()
    private var roomId: String!
    
    init(roomId: String) {
        self.roomId = roomId
    }
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let sendText: Observable<String>
        let sendButtonTapped: Observable<Void>
        let enterTapped: Observable<Void>
    }
    
    struct Output {
        let outputMessages: Driver<[ChatModel]>
        let removeTextTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let roomIdSubject = BehaviorSubject(value: roomId)
        var messages: [ChatModel] = []
        let outputMessages = PublishRelay<[ChatModel]>()
        let removeTextTrigger = PublishRelay<Void>()
        
        let viewDidLoadTrigger = input.viewDidLoadTrigger
            .withLatestFrom(roomIdSubject)
        
        viewDidLoadTrigger
            .bind(with: self) { owner, id in
                SocketIOManager.shared.establishConnection(roomId: id ?? "")
            }
            .disposed(by: disposeBag)
        
        SocketIOManager.shared.receivedChatData
            .bind(with: self) { owner, chat in
                print(chat)
                messages.append(chat)
                outputMessages.accept(messages)
            }
            .disposed(by: disposeBag)
        
        Observable.merge(input.sendButtonTapped, input.enterTapped)
            .throttle(.seconds(1), scheduler: MainScheduler())
            .withLatestFrom(input.sendText)
            .flatMap { text in
                return NetworkManager.shared.callRequest(type: ChatModel.self, router: .chattingRouter(.sendChat(roomId: self.roomId, content: SendChatQuery(content: text))))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    print(success)
                    removeTextTrigger.accept(())
                case .failure(let failure):
                    print(failure)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            outputMessages: outputMessages.asDriver(onErrorJustReturn: []),
            removeTextTrigger: removeTextTrigger.asDriver(onErrorJustReturn: ()))
    }
    
}

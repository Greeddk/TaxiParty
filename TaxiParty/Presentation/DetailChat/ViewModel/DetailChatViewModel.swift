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
    private let repository = ChatRepository()
    
    init(roomId: String) {
        self.roomId = roomId
    }
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let sendText: Observable<String>
        let sendButtonTapped: Observable<Void>
        let enterTapped: Observable<Void>
        let textFieldTapped: Observable<Void>
    }
    
    struct Output {
        let outputMessages: Driver<[ChatInfo]>
        let removeTextTrigger: Driver<Void>
        let textFieldTapped: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let roomIdSubject = BehaviorSubject(value: roomId)
        var messages: [ChatInfo] = []
        let outputMessages = PublishRelay<[ChatInfo]>()
        let removeTextTrigger = PublishRelay<Void>()
        
        let viewDidLoadTrigger = input.viewDidLoadTrigger
            .withLatestFrom(roomIdSubject)
        
        viewDidLoadTrigger
            .flatMap { id in
                return NetworkManager.shared.callRequest(type: ChatListModel.self, router: .chattingRouter(.fetchChat(roomId: id ?? "")))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    print(success)
                    success.data.forEach { item in
                        messages.append(item.toChatInfo())
                    }
                    outputMessages.accept(messages)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        viewDidLoadTrigger
            .bind(with: self) { owner, id in
                SocketIOManager.shared.establishConnection(roomId: id ?? "")
            }
            .disposed(by: disposeBag)
        
        SocketIOManager.shared.receivedChatData
            .bind(with: self) { owner, chatModel in
                let chatInfo = chatModel.toChatInfo()
                messages.append(chatInfo)
                
                if messages.count > 1 && messages[messages.count - 2].chatModel.sender.userId == chatModel.sender.userId {
                    messages[messages.count - 1].isContinuous = true
                    
                    if messages.count > 1 && self.convertToTextDateFormat(messages[messages.count - 2].chatModel.createdAt) == self.convertToTextDateFormat(chatModel.createdAt) {
                        messages[messages.count - 2].isSameTime = true
                    }
                }
                
                outputMessages.accept(messages)
            }
            .disposed(by: disposeBag)

        
        Observable.merge(input.sendButtonTapped, input.enterTapped)
            .throttle(.seconds(1), scheduler: MainScheduler())
            .withLatestFrom(input.sendText)
            .filter { $0.count > 0 }
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
            removeTextTrigger: removeTextTrigger.asDriver(onErrorJustReturn: ()), 
            textFieldTapped: input.textFieldTapped.asDriver(onErrorJustReturn: ()))
    }
    
}

extension DetailChatViewModel {
    
    private func convertToTextDateFormat(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: dateString)
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "a h시 mm분"
        
        return outputFormatter.string(from: date ?? Date())
    }
    
}

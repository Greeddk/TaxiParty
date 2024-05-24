//
//  DetailChatViewModel.swift
//  TaxiParty
//
//  Created by Greed on 5/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailChatViewModel: ViewModelProtocol {
    
    var disposeBag = DisposeBag()
    private var roomId: String!
    private let repository = ChatRepository()
    private let socket = SocketIOManager.shared
    
    init(roomId: String) {
        self.roomId = roomId
    }
    
    deinit {
        print("-----------------------------------")
        print("deinit")
    }
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let sendText: Observable<String>
        let sendButtonTapped: Observable<Void>
        let enterTapped: Observable<Void>
        let textFieldTapped: Observable<Void>
        let viewDidDisappearTrigger: Observable<Void>
    }
    
    struct Output {
        let outputMessages: Driver<[ChatInfo]>
        let removeTextTrigger: Driver<Void>
        let textFieldTapped: Driver<Void>
        let scrollToBottomTrigger: Driver<Int>
    }
    
    func transform(input: Input) -> Output {
        
        var messages: [ChatInfo] = []
        let outputMessages = PublishRelay<[ChatInfo]>()
        let removeTextTrigger = PublishRelay<Void>()
        let fetchRecentDataTrigger = PublishRelay<Void>()
        let connetSocketTrigger = PublishRelay<Void>()
        let scrollToBottomTrigger = PublishRelay<Int>()
        
        input.viewDidLoadTrigger
            .bind(with: self) { owner, _ in
                let loadMessages = owner.repository.fetchChatList(id: owner.roomId)
                loadMessages.forEach { item in
                    messages.append(item.toChatInfo())
                }
                outputMessages.accept(messages)
                fetchRecentDataTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        fetchRecentDataTrigger
            .flatMap { [weak self] in
                let lastDate = self?.repository.fetchLastChat(id: self?.roomId ?? "") ?? ""
                return NetworkManager.shared.callRequest(type: ChatListModel.self, router: .chattingRouter(.fetchChat(roomId: self?.roomId ?? "", lastDate: lastDate)))
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let success):
                    print(success)
                    for item in success.data {
                        let chatInfo = item.toChatInfo()
                        messages.append(chatInfo)
                        owner.repository.appendChatList(id: owner.roomId, chat: chatInfo)
                        messages = owner.updateInfo(messages: messages, chatModel: item)
                    }
                    outputMessages.accept(messages)
                    scrollToBottomTrigger.accept(messages.count)
                    connetSocketTrigger.accept(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        connetSocketTrigger
            .bind(with: self) { owner, _ in
                owner.socket.establishConnection(roomId: owner.roomId)
            }
            .disposed(by: disposeBag)
        
        socket.receivedChatData
            .subscribe(with: self) { owner, chatModel in
                let chatInfo = chatModel.toChatInfo()
                messages.append(chatInfo)
                owner.repository.appendChatList(id: owner.roomId, chat: chatInfo)
                messages = owner.updateInfo(messages: messages, chatModel: chatModel)
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
                    removeTextTrigger.accept(())
                case .failure(let failure):
                    print(failure)
                }
            }
            .disposed(by: disposeBag)
        
        input.viewDidDisappearTrigger
            .bind(with: self) { owner, _ in
                owner.socket.leaveConnection()
            }
            .disposed(by: disposeBag)
        
        return Output(
            outputMessages: outputMessages.asDriver(onErrorJustReturn: []),
            removeTextTrigger: removeTextTrigger.asDriver(onErrorJustReturn: ()),
            textFieldTapped: input.textFieldTapped.asDriver(onErrorJustReturn: ()),
            scrollToBottomTrigger: scrollToBottomTrigger.asDriver(onErrorJustReturn: 0)
        )
        
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
    
    private func updateInfo(messages: [ChatInfo], chatModel: ChatModel) -> [ChatInfo] {
        var updatedMessages = messages
        
        guard updatedMessages.count > 1 else { return updatedMessages }
        
        let lastIndex = updatedMessages.count - 1
        let secondLastIndex = lastIndex - 1
        
        if secondLastIndex >= 0, updatedMessages[secondLastIndex].chatModel.sender.userId == chatModel.sender.userId {
            
            updatedMessages[lastIndex].isContinuous = true
            repository.updateChatInfo(index: lastIndex, id: roomId, isContinuous: true, isSameTime: nil)
            
            if convertToTextDateFormat(updatedMessages[secondLastIndex].chatModel.createdAt) == convertToTextDateFormat(chatModel.createdAt) {
                updatedMessages[secondLastIndex].isSameTime = true
                repository.updateChatInfo(index: secondLastIndex, id: roomId, isContinuous: nil, isSameTime: true)
            }
        }
        
        return updatedMessages
    }
    
    
}

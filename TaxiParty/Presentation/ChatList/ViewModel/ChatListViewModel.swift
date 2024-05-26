//
//  ChatListViewModel.swift
//  TaxiParty
//
//  Created by Greed on 5/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChatListViewModel: ViewModelProtocol {
    
    var disposeBag = DisposeBag()
    let repository = ChatRepository()
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
    }
    
    struct Output {
        let chatRoomList: Driver<[ChatRoomListData]>
    }
    
    func transform(input: Input) -> Output {
        let chatRoomList = BehaviorSubject<[ChatRoomListData]>(value: [])
        
        input.viewDidLoadTrigger
            .bind(with: self) { owner, _ in
                let list = owner.repository.fetchChatRoomList()
                let data = ChatRoomListData(header: "", items: list)
                chatRoomList.onNext([data])
            }
            .disposed(by: disposeBag)
        
        return Output(chatRoomList: chatRoomList.asDriver(onErrorJustReturn: []))
    }
    
}

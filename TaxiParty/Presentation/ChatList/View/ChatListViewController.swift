//
//  ChatListViewController.swift
//  TaxiParty
//
//  Created by Greed on 4/21/24.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import RxDataSources

struct ChatListRepresentableView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        ChatListViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

final class ChatListViewController: BaseViewController {
    
    let mainView = ChatListView()
    let viewModel = ChatListViewModel()
    let viewDidLoadTrigger = PublishRelay<Void>()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadTrigger.accept(())
    }
    
    override func bind() {
        
        let dataSoruce = RxTableViewSectionedAnimatedDataSource<ChatRoomListData>( animationConfiguration: AnimationConfiguration(
            insertAnimation: .fade,
            reloadAnimation: .fade,
            deleteAnimation: .fade
        )
        ) { data, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewCell.identifier, for: indexPath) as? ChatRoomTableViewCell else { return UITableViewCell() }
            cell.configureCell(item: item)
            return cell
        }
        
        let input = ChatListViewModel.Input(viewDidLoadTrigger: viewDidLoadTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.chatRoomList
            .drive(mainView.tableView.rx.items(dataSource: dataSoruce))
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(ChatRoomCellInfoModel.self)
            .bind(with: self, onNext: { owner, item in
                let chatViewModel = DetailChatViewModel(roomId: item.roomId)
                let chatView = DetailChatViewController(viewModel: chatViewModel)
                owner.navigationController?.pushViewController(chatView, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.itemSelected.asDriver()
            .drive(with: self) { owner, indexPath in
                owner.mainView.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
}

struct ChatRoomListData {
    var header: String
    var items: [Item]
}

extension ChatRoomListData: AnimatableSectionModelType {
    typealias Item = ChatRoomCellInfoModel
    
    var identity: String {
        return header
    }
    
    init(original: ChatRoomListData, items: [ChatRoomCellInfoModel]) {
        self = original
        self.items = items
    }
}

struct ChatRoomCellInfoModel {
    let roomId: String
    let opponent: Opponent
    var lastContent: String
    var lastDate: String
    var unreadCount: Int
}

extension ChatRoomCellInfoModel: IdentifiableType, Equatable {
    static func == (lhs: ChatRoomCellInfoModel, rhs: ChatRoomCellInfoModel) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    var identity: String {
        return roomId
    }
}

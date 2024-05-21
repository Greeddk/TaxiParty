//
//  DetailChatViewController.swift
//  TaxiParty
//
//  Created by Greed on 5/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailChatViewController: BaseViewController {
    
    let mainView = DetailChatView()
    let viewModel: DetailChatViewModel
    
    let viewDidLoadTrigger = PublishRelay<Void>()
    
    init(viewModel: DetailChatViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadTrigger.accept(())
        hideKeyboardWhenViewIsTapped()
        setNavigationBackButton(title: "채팅")
    }
    
    override func bind() {
        
        let input = DetailChatViewModel.Input(
            viewDidLoadTrigger: viewDidLoadTrigger.asObservable(),
            sendText: mainView.textField.rx.text.orEmpty.asObservable(),
            sendButtonTapped: mainView.sendButton.rx.tap.asObservable(),
            enterTapped: mainView.textField.rx.controlEvent(.editingDidEnd).asObservable(),
            textFieldTapped: mainView.textField.rx.controlEvent(.touchDown).asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.outputMessages
            .drive(mainView.tableView.rx.items) { tableView, row, item in
                if item.chatModel.isMe {
                    let cell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.identifier) as! MyChatTableViewCell
                    cell.configureCell(item: item)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: OpponentChatTableViewCell.identifier) as! OpponentChatTableViewCell
                    cell.configureCell(item: item)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        output.removeTextTrigger
            .drive(with: self) { owner, _ in
                owner.mainView.textField.text = ""
            }
            .disposed(by: disposeBag)
        
    }
    
}

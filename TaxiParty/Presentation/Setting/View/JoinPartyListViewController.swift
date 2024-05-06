//
//  JoinPartyListViewController.swift
//  TaxiParty
//
//  Created by Greed on 5/6/24.
//

import UIKit
import RxSwift
import RxCocoa

final class JoinPartyListViewController: BaseViewController {
    
    let mainView = JoinPartyListView()
    let viewModel = JoinPartyListViewModel()
    let fetchDataTrigger = PublishRelay<Void>()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBackButton()
        fetchDataTrigger.accept(())
    }
    
    override func bind() {
        
        let input = JoinPartyListViewModel.Input(
            fetchDataTrigger: fetchDataTrigger.asObservable(),
            paginationTrigger: collectionViewContentOffsetChanged()
        )
        
        let output = viewModel.transform(input: input)
        
        output.fetchedData
            .drive(mainView.collectionView.rx.items(cellIdentifier: PartyPostCollectionViewCell.identifier, cellType: PartyPostCollectionViewCell.self)) { row, element, cell in
                cell.configureCell(post: element)
            }
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx
            .modelSelected(Post.self)
            .bind(with: self) { owner, item in
                let viewModel = PostDetailViewModel(postItem: item)
                let postDetailViewController = PostDetailViewController(viewModel: viewModel)
                owner.navigationController?.pushViewController(postDetailViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func collectionViewContentOffsetChanged() -> Observable<Void> {
        return mainView.collectionView.rx.contentOffset
            .withUnretained(self)
            .filter { (self, offset) in
                guard self.mainView.collectionView.contentSize.height != 0 else {
                    return false
                }
                return self.mainView.collectionView.frame.height + offset.y + 150 >= self.mainView.collectionView.contentSize.height
            }
            .map { _ in }
    }

}

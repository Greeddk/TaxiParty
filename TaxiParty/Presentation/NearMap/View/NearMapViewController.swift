//
//  NearMapViewController.swift
//  TaxiParty
//
//  Created by Greed on 4/19/24.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

protocol transferData {
    func transferData(item: Post)
}

struct NearMapRepresentableView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> some UIViewController {
        NearMapViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

final class NearMapViewController: BaseViewController, transferData {
    
    let mainView = NearMapView()
    let viewModel = NearMapViewModel()
    let fetchDataTrigger = PublishRelay<Void>()
    var currentItem: Post?
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataTrigger.accept(())
        mainView.delegate = self
    }
    
    override func bind() {
        
        let input = NearMapViewModel.Input(
            fetchDataTrigger: fetchDataTrigger.asObservable(),
            moveToDetailViewTrigger: mainView.backView.rx.tapGesture().when(.recognized).asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.fetchedData
            .drive(with: self) { owner, items in
                owner.mainView.configureMap(items: items)
            }
            .disposed(by: disposeBag)
        
        output.moveToDetailViewTrigger
            .drive(with: self) { owner, _ in
                let viewModel = PostDetailViewModel(postItem: owner.currentItem!)
                let detailVC = PostDetailViewController(viewModel: viewModel)
                owner.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    func transferData(item: Post) {
        currentItem = item
    }
    
}



//
//  SearchPostViewController.swift
//  TaxiParty
//
//  Created by Greed on 4/19/24.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

struct SearchPostRepresentableView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> some UIViewController {
        SearchPostViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

final class SearchPostViewController: BaseViewController {
    
    let mainView = SearchPostView()
    
    let data = Observable.just([
        Post(title: "test1", dueDate: "20240202", startPoint: "남부터미널", destination: "창동", maximumNum: "4", joinPeople: ["모아나","그리드"], creator: Creator(nick: "그리더", profileImage: "default")),
        Post(title: "test222", dueDate: "20240202", startPoint: "고터", destination: "영등포", maximumNum: "3", joinPeople: ["모아나","그리드"], creator: Creator(nick: "그리더", profileImage: "default")),
        Post(title: "te3333st", dueDate: "20240202", startPoint: "전주", destination: "창동", maximumNum: "4", joinPeople: ["모아나","그리드"], creator: Creator(nick: "그리더", profileImage: "default")),
        Post(title: "444test", dueDate: "20240202", startPoint: "인천", destination: "서울역", maximumNum: "3", joinPeople: ["모아나","그리드"], creator: Creator(nick: "그리더", profileImage: "default")),
        Post(title: "tes555", dueDate: "20240202", startPoint: "고대앞", destination: "창동", maximumNum: "4", joinPeople: ["모아나","그리드"], creator: Creator(nick: "그리더", profileImage: "default")),
        Post(title: "tes666t", dueDate: "20240202", startPoint: "교대", destination: "강남", maximumNum: "4", joinPeople: ["모아나","그리드"], creator: Creator(nick: "그리더", profileImage: "default"))
        ])
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        
        data
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: PartyPostCollectionViewCell.identifier, cellType: PartyPostCollectionViewCell.self)) { row, element, cell in
                cell.configureCell(post: element)
            }
            .disposed(by: disposeBag)
    }

}

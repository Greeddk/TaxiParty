//
//  PostDetailViewController.swift
//  TaxiParty
//
//  Created by Greed on 5/3/24.
//

import UIKit
import RxCocoa
import RxSwift

final class PostDetailViewController: BaseViewController {
    
    let mainView = PostDetailView()
    let viewModel: PostDetailViewModel
    
    init(viewModel: PostDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        setNavigationBackButton()
    }

    override func bind() {
        
        let input = PostDetailViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        Driver.combineLatest(output.item, output.startPlace, output.destinationPlace, output.directionInfo, output.joinPeopleNum) { item, startPlace, destinationPlace, direction, joinNum in
            return (item: item, startPlace: startPlace, destinationPlace: destinationPlace, direction: direction, joinPeopleNum: joinNum)
        }
        .drive(with: self) { owner, values in
            owner.mainView.configureCell(item: values.item, startPlace: values.startPlace, destination: values.destinationPlace)
            owner.mainView.updateMapView(item: values.direction, currentNum: values.joinPeopleNum)
        }
        .disposed(by: disposeBag)

    }
}

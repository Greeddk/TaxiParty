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
    let viewDidLoadTrigger = PublishRelay<Void>()
    
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
        viewDidLoadTrigger.accept(())
    }

    override func bind() {
        
        let input = PostDetailViewModel.Input(
            viewDidLoadTrigger: viewDidLoadTrigger.asObservable(),
            joinButtonTapped: mainView.joinButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.disableButton
            .drive(with: self, onNext: { owner, value in
                owner.mainView.joinButton.isEnabled = value
                if !value {
                    owner.mainView.joinButton.setTitle("유저님이 만든 파티예요!", for: .normal)
                    owner.mainView.joinButton.backgroundColor = .systemGray2
                }
            })
            .disposed(by: disposeBag)
        
        Driver.combineLatest(output.item, output.startPlace, output.destinationPlace, output.directionInfo, output.joinPeopleNum) { item, startPlace, destinationPlace, direction, joinNum in
            return (item: item, startPlace: startPlace, destinationPlace: destinationPlace, direction: direction, joinPeopleNum: joinNum)
        }
        .drive(with: self) { owner, values in
            owner.mainView.configureCell(item: values.item, startPlace: values.startPlace, destination: values.destinationPlace, togetherNum: values.joinPeopleNum)
            owner.mainView.updateMapView(item: values.direction, currentNum: values.item.numberOfPeople)
        }
        .disposed(by: disposeBag)
        
        output.joinStatus
            .drive(with: self) { owner, value in
                if value {
                    owner.mainView.joinButton.setTitle("참가 완료", for: .normal)
                    owner.mainView.joinButton.backgroundColor = .gray
                } else {
                    owner.mainView.joinButton.setTitle("택시 같이타기", for: .normal)
                    owner.mainView.joinButton.backgroundColor = .pointPurple
                }
            }
            .disposed(by: disposeBag)

    }
}

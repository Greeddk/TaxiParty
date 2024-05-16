//
//  PostDetailViewModel.swift
//  TaxiParty
//
//  Created by Greed on 5/3/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PostDetailViewModel: ViewModelProtocol {
    
    var disposeBag = DisposeBag()
    private var postItem: Post
    
    init(postItem: Post) {
        self.postItem = postItem
    }
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let joinButtonTapped: Observable<Void>
    }
    
    struct Output {
        let item: Driver<Post>
        let directionInfo: Driver<DirectionModel>
        let startPlace: Driver<String>
        let destinationPlace: Driver<String>
        let joinPeopleNum: Driver<Int>
        let joinStatus: Driver<Bool>
        let enableButton: Driver<Bool>
        let availableJoin: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let item = BehaviorSubject(value: postItem)
        let directionInfo = PublishRelay<DirectionModel>()
        let startPlace = PublishRelay<String>()
        let destinationPlace = PublishRelay<String>()
        let JoinPeopleNum = PublishRelay<Int>()
        let joinStatus = PublishRelay<Bool>()
        let refreshPostTrigger = PublishRelay<Void>()
        let enableButton = PublishRelay<Bool>()
        let availableJoin = PublishRelay<Bool>()
        
        input.viewDidLoadTrigger
            .withLatestFrom(item)
            .bind(with: self) { owner, item in
                if item.creator.user_id == TokenManager.userId {
                    enableButton.accept(false)
                } else {
                    enableButton.accept(true)
                }
                
                if item.together.count + 1 == Int(item.numberOfPeople) {
                    availableJoin.accept(false)
                }
                
                if item.together.contains(TokenManager.userId) {
                    joinStatus.accept(true)
                    availableJoin.accept(true)
                }
                
            }
            .disposed(by: disposeBag)
        
        item.asObservable()
            .flatMap { item -> PrimitiveSequence<SingleTrait, (startPlaceName: String, destinationName: String, numberOfPeople: Int, response: Result<DirectionModel, NetworkError>)> in
                
                let startData = item.startPlaceData.split(separator: ",")
                let startCoords = "\(startData[1]),\(startData[2])"
                
                let destiData = item.destinationData.split(separator: ",")
                let destiCoords = "\(destiData[1]),\(destiData[2])"
                
                return NetworkManager.shared.callGeocodingRequest(type: DirectionModel.self, router: APIRouter.geocodingRouter(.fetchDirection(start: startCoords, goal: destiCoords)).convertToURLRequest())
                    .map { response in
                        return (String(startData[0]), String(destiData[0]), item.together.count, response)
                    }
            }
            .subscribe(onNext: { values in
                startPlace.accept(values.startPlaceName)
                destinationPlace.accept(values.destinationName)
                JoinPeopleNum.accept(values.numberOfPeople)
                switch values.response {
                case .success(let success):
                    directionInfo.accept(success)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        input.joinButtonTapped
            .flatMap {
                let status = self.postItem.together.contains(TokenManager.userId)
                print(status)
                return NetworkManager.shared.callRequest(type: JoinPartyModel.self, router: .postRouter(.joinParty(postId: self.postItem.postId, status: JoinPartyQuery(likeStatus: !status))))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    joinStatus.accept(success.likeStatus)
                    refreshPostTrigger.accept(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        refreshPostTrigger.asObservable()
            .flatMap {
                return NetworkManager.shared.callRequest(type: Post.self, router: .postRouter(.getOnePost(postId: self.postItem.postId)))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    owner.postItem = success
                    JoinPeopleNum.accept(success.together.count)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            item: item.asDriver(onErrorJustReturn: Post(postId: "", title: "", startPlaceData: "", destinationData: "", numberOfPeople: "", dueDate: "", productId: "", createdAt: "", creator: Creator(user_id: "", nick: "", profileImage: ""), together: [])),
            directionInfo: directionInfo.asDriver(onErrorJustReturn: DirectionModel(message: "", route: Route(trafast: []))),
            startPlace: startPlace.asDriver(onErrorJustReturn: ""),
            destinationPlace: destinationPlace.asDriver(onErrorJustReturn: ""),
            joinPeopleNum: JoinPeopleNum.asDriver(onErrorJustReturn: 0),
            joinStatus: joinStatus.asDriver(onErrorJustReturn: false),
            enableButton: enableButton.asDriver(onErrorJustReturn: true),
            availableJoin: availableJoin.asDriver(onErrorJustReturn: true)
        )
    }
    
}

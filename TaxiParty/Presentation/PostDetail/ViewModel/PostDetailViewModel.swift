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
    let postItem: Post
    
    init(postItem: Post) {
        self.postItem = postItem
    }
    
    struct Input {
        
    }
    
    struct Output {
        let item: Driver<Post>
        let directionInfo: Driver<DirectionModel>
        let startPlace: Driver<String>
        let destinationPlace: Driver<String>
        let joinPeopleNum: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let item = BehaviorSubject(value: postItem)
        let directionInfo = PublishRelay<DirectionModel>()
        let startPlace = PublishRelay<String>()
        let destinationPlace = PublishRelay<String>()
        let numberOfPeople = PublishRelay<String>()
        
        item.asObservable()
            .flatMap { item -> PrimitiveSequence<SingleTrait, (startPlaceName: String, destinationName: String, numberOfPeople: String, response: Result<DirectionModel, NetworkError>)> in
                
                let startData = item.startPlaceData.split(separator: ",")
                let startCoords = "\(startData[1]),\(startData[2])"
                
                let destiData = item.destinationData.split(separator: ",")
                let destiCoords = "\(destiData[1]),\(destiData[2])"
                
                return NetworkManager.shared.callGeocodingRequest(type: DirectionModel.self, router: APIRouter.geocodingRouter(.fetchDirection(start: startCoords, goal: destiCoords)).convertToURLRequest())
                    .map { response in
                        return (String(startData[0]), String(destiData[0]), item.numberOfPeople, response)
                    }
            }
            .subscribe(onNext: { values in
                startPlace.accept(values.startPlaceName)
                destinationPlace.accept(values.destinationName)
                numberOfPeople.accept(values.numberOfPeople)
                switch values.response {
                case .success(let success):
                    directionInfo.accept(success)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)

        
        return Output(
            item: item.asDriver(onErrorJustReturn: Post(postId: "", title: "", startPlaceData: "", destinationData: "", numberOfPeople: "", dueDate: "", productId: "", createdAt: "", creator: Creator(user_id: "", nick: "", profileImage: ""), together: [])),
            directionInfo: directionInfo.asDriver(onErrorJustReturn: DirectionModel(message: "", route: Route(traoptimal: []))),
            startPlace: startPlace.asDriver(onErrorJustReturn: ""),
            destinationPlace: destinationPlace.asDriver(onErrorJustReturn: ""),
            joinPeopleNum: numberOfPeople.asDriver(onErrorJustReturn: "")
        )
    }
    
}

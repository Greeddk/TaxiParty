//
//  FillPostViewModel.swift
//  TaxiParty
//
//  Created by Greed on 5/1/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FillPostViewModel: ViewModelProtocol {
    
    var disposeBag = DisposeBag()
    private var count = 2
    var route: (startPlaceName: String, startPlaceCoord: String, destinationName: String, destinationAddress: String)!

    struct Input {
        let fetchDataTrigger: Observable<Void>
        let inputTitleText: Observable<String>
        let plusButtonTapped: Observable<Void>
        let minusButtonTapped: Observable<Void>
        let dueDate: Observable<Date>
        let postButtonTapped: Observable<Void>
    }
    
    struct Output {
        let startPlaceName: Driver<String>
        let destinationName: Driver<String>
        let currentPeopleNum: Driver<String>
        let enablePlusButton: Driver<Bool>
        let enableMinusButton: Driver<Bool>
        let postComplete: Driver<Bool>
        let errorAlertTrigger: Driver<Bool>
        let directionInfo: Driver<DirectionModel>
    }
    
    func transform(input: Input) -> Output {
        
        let startPlaceName = PublishRelay<String>()
        let destinationName = PublishRelay<String>()
        let startPlaceData = PublishRelay<String>()
        let destinationData = PublishRelay<String>()
        let currentPeopleNum = BehaviorSubject(value: "\(count)")
        let dueDate = PublishRelay<String>()
        let enablePlusButton = BehaviorSubject(value: true)
        let enableMinusButton = BehaviorSubject(value: false)
        let directionInfo = PublishRelay<DirectionModel>()
        
        let postComplete = PublishRelay<Bool>()
        let errorAlertTrigger = PublishRelay<Bool>()
        
        let startLngLat = PublishRelay<String>()
        let destinationLngLat = PublishRelay<String>()
        let directionObservable = Observable.combineLatest(startLngLat, destinationLngLat)
        let postObservable = Observable.combineLatest(input.inputTitleText, startPlaceData, destinationData, currentPeopleNum, dueDate)
        
        input.fetchDataTrigger
            .map {
                return self.route
            }
            .flatMap { route -> PrimitiveSequence<SingleTrait, (startPlaceName: String, startPlaceCoord: String, destinationName: String, response: Result<GeocodingModel, NetworkError>)> in
                    return NetworkManager.shared.callGeocodingRequest(type: GeocodingModel.self, router: APIRouter.geocodingRouter(.getCoord(address: route.destinationAddress)).convertToURLRequest())
                        .map { destinationCoord in
                            return (route.startPlaceName, route.startPlaceCoord, route.destinationName, destinationCoord)
                        }
                }
            .bind(with: self) { owner, value in
                startPlaceName.accept(value.startPlaceName)
                destinationName.accept(value.destinationName)
                startPlaceData.accept("\(value.startPlaceName),\(value.startPlaceCoord)")
                startLngLat.accept(value.startPlaceCoord)
                switch value.response {
                case .success(let success):
                    let coords = "\(success.addresses.first?.x ?? "0"),\(success.addresses.first?.y ?? "0")"
                    destinationData.accept("\(value.destinationName),\(coords)")
                    destinationLngLat.accept(coords)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        directionObservable
            .flatMap { coords in
                return NetworkManager.shared.callGeocodingRequest(type: DirectionModel.self, router: APIRouter.geocodingRouter(.fetchDirection(start: coords.0, goal: coords.1)).convertToURLRequest())
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    directionInfo.accept(success)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.minusButtonTapped
            .withLatestFrom(currentPeopleNum)
            .bind(with: self) { owner, value in
                owner.count -= 1
                currentPeopleNum.onNext("\(owner.count)")
            }
            .disposed(by: disposeBag)
        
        input.plusButtonTapped
            .withLatestFrom(currentPeopleNum)
            .bind(with: self) { owner, value in
                owner.count += 1
                currentPeopleNum.onNext("\(owner.count)")
            }
            .disposed(by: disposeBag)
        
        currentPeopleNum
            .bind(with: self) { owner, currentNum in
                if Int(currentNum) == 2 {
                    enableMinusButton.onNext(false)
                } else if Int(currentNum) == 4 {
                    enablePlusButton.onNext(false)
                } else {
                    enableMinusButton.onNext(true)
                    enablePlusButton.onNext(true)
                }
            }
            .disposed(by: disposeBag)
        
        input.dueDate
            .bind(with: self) { owner, date in
                dueDate.accept("\(date)")
            }
            .disposed(by: disposeBag)
        
        input.postButtonTapped
            .withLatestFrom(postObservable)
            .flatMap { postQuery in
                let query = PostQuery(title: postQuery.0, startPlaceData: postQuery.1, destinationData: postQuery.2, numberOfPeople: postQuery.3, dueDate: postQuery.4, productId: ProductId.taxiParty.rawValue)
                print("---------------------------------")
                print(query)
                return NetworkManager.shared.callRequest(type: Post.self, router: APIRouter.postRouter(.writePost(query: query)).convertToURLRequest())
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    postComplete.accept(true)
                    print(success)
                case .failure(let error):
                    errorAlertTrigger.accept(true)
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            startPlaceName: startPlaceName.asDriver(onErrorJustReturn: "오류"),
            destinationName: destinationName.asDriver(onErrorJustReturn: "오류") ,
            currentPeopleNum: currentPeopleNum.asDriver(onErrorJustReturn: "2"),
            enablePlusButton: enablePlusButton.asDriver(onErrorJustReturn: false),
            enableMinusButton: enableMinusButton.asDriver(onErrorJustReturn: false),
            postComplete: postComplete.asDriver(onErrorJustReturn: false),
            errorAlertTrigger: errorAlertTrigger.asDriver(onErrorJustReturn: false),
            directionInfo: directionInfo.asDriver(onErrorJustReturn: DirectionModel(message: "", route: Route(traoptimal: [])))
        )
    }

}

//
//  AddPostViewModel.swift
//  TaxiParty
//
//  Created by Greed on 4/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AddPostViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let coordinate: Observable<String>
        let startPointText: Observable<String>
        let destinationText: Observable<String>
        let startPointTextFieldSelected: Observable<Void>
        let destinationTextFieldSelected: Observable<Void>
    }
    
    struct Output {
        let startPoint: Driver<String>
        let startPointList: Observable<Array<SearchedAddress>>
        let destinationList: Observable<Array<SearchedAddress>>
        let focusStartPoint: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let addressString = PublishRelay<String>()
        let focusStartPoint = PublishRelay<Bool>()
        let startPointList = PublishRelay<Array<SearchedAddress>>()
        let destinationList = PublishRelay<Array<SearchedAddress>>()
        
        input.coordinate
            .skip(1)
            .flatMap { coords in
                NetworkManager.shared.callGeocodingRequest(type: ReverseGeocodingModel.self, router: APIRouter.geocodingRouter(.getAddress(coords: coords)).convertToURLRequest())
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    var address = ""
                    if success.results.count >= 2 {
                        let newValue = success.results[1]
                        var newAddress = ""
                        if newValue.land.addition0.value == "" {
                            newAddress = newValue.region.area3.name + " " + newValue.land.number1 + "-" + newValue.land.number2
                        } else {
                            newAddress = newValue.region.area3.name + " " + newValue.land.addition0.value
                        }
                        address = newAddress
                    } else {
                        let oldValue = success.results[0]
                        let oldAddress = oldValue.region.area1.alias + " " + oldValue.region.area2.name + " "  + oldValue.region.area3.name  + " "  + oldValue.land.number1 + "-" + oldValue.land.number2
                        address = oldAddress
                    }
                    addressString.accept(address)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.merge(input.startPointTextFieldSelected.asObservable().map { true }, input.destinationTextFieldSelected.asObservable().map { false })
            .bind(with: self) { owner, value in
                if value {
                    focusStartPoint.accept(true)
                } else {
                    focusStartPoint.accept(false)
                }
            }
            .disposed(by: disposeBag)
            
        Observable.merge(
            input.startPointText.asObservable().map { (isStartPoint: true, text: $0) },
            input.destinationText.asObservable().map { (isStartPoint: false, text: $0) }
        )
        .filter { !$0.text.isEmpty }
        .flatMap { value in
            let text = value.text
            let isStartPoint = value.isStartPoint
            return NetworkManager.shared.callGeocodingRequest(type: KeywordSearchModel.self, router: APIRouter.geocodingRouter(.keywordSearch(query: text )).convertToURLRequest())
                .map { (isStartPoint: isStartPoint, response: $0) }
        }
        .bind(with: self) { owner, value in
            let isStartPointText = value.isStartPoint
            let response = value.response
            switch response {
            case .success(let success):
                if isStartPointText {
                    startPointList.accept(success.documents)
                } else {
                    destinationList.accept(success.documents)
                }
                print(success)
            case .failure(let error):
                print(error)
            }
        }
        .disposed(by: disposeBag)
        
        return Output(
            startPoint: addressString.asDriver(onErrorJustReturn: "error"),
            startPointList: startPointList.asObservable(),
            destinationList: destinationList.asObservable(),
            focusStartPoint: focusStartPoint.asDriver(onErrorJustReturn: false)
        )
    }
    
}

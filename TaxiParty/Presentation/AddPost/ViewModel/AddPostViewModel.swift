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
    }
    
    struct Output {
        let startPoint: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let addressString = PublishRelay<String>()
        
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
            
        
        return Output(startPoint: addressString.asDriver(onErrorJustReturn: "error"))
    }
    
}

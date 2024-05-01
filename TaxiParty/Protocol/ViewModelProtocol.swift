//
//  ViewModelProtocol.swift
//  TaxiParty
//
//  Created by Greed on 5/1/24.
//

import Foundation
import RxSwift

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

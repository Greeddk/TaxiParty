//
//  NetworkManager.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import Foundation
import RxSwift
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case invalidStatusCode
    case failedRequest
    case cantUseIt
    case invalidSesacKey
    case overCalling
    case invalidRequest
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    func callRequest<T>(type: T.Type, router: TargetType) -> Single<Result<T, NetworkError>> where T: Decodable {
        return Single.create { single -> Disposable in
            
            do {
                let urlRequest = try router.asURLRequest()
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let success):
                            single(.success(.success(success)))
                            print(success)
                        case .failure(let error):
                            print(error)
                            let networkError: NetworkError
                            switch error.responseCode {
                            case 409:
                                networkError = .cantUseIt
                            case 420:
                                networkError = .invalidSesacKey
                            case 429:
                                networkError = .overCalling
                            case 444:
                                networkError = .invalidURL
                            case 500:
                                networkError = .invalidRequest
                            default:
                                networkError = .failedRequest
                            }
                            single(.success(.failure(networkError)))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
}

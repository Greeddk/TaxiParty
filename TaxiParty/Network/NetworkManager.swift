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
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    func callRequest<T>(type: T.Type, router: TargetType) -> Single<Result<T, NetworkError>> where T: Decodable {
        return Single.create { single in
            
            do {
                let urlRequest = try router.asURLRequest()
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let success):
                            single(.success(.success(success)))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
}

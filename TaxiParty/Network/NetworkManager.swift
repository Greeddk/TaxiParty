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
    case expireRefreshToken
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    func callRequest<T>(type: T.Type, router: RouterType) -> Single<Result<T, NetworkError>> where T: Decodable {
        return Single.create { single -> Disposable in
            
            do {
                let urlRequest = try router.asURLRequest()
                AF.request(urlRequest, interceptor: AuthInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let success):
                            single(.success(.success(success)))
                        case .failure(let error):
                            print(error)
                            let networkError: NetworkError
                            switch error.responseCode {
                            case 409:
                                networkError = .cantUseIt
                            case 418:
                                networkError = .expireRefreshToken
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

final class AuthInterceptor: RequestInterceptor {

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        let accessToken = TokenManager.accessToken
        if accessToken == urlRequest.headers.dictionary[HTTPHeader.authorization.rawValue] {
            completion(.success(urlRequest))
        } else {
            var urlRequest = urlRequest
            urlRequest.setValue(TokenManager.accessToken, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
            
            print("새 accessToken 적용 \(urlRequest.headers)")
            completion(.success(urlRequest))
        }
        
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        do {
            let urlRequest = try refreshTokenRouter.refreshToken.asURLRequest()
            AF.request(urlRequest)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: RefreshTokenModel.self) { response in
                    switch response.result {
                    case .success(let success):
                        TokenManager.accessToken = success.accessToken
                        completion(.retry)
                    case .failure(let error):
                        print(error)
                        completion(.doNotRetryWithError(NetworkError.expireRefreshToken))
                    }
                }
        } catch {
            print(error)
        }
    }
    
}

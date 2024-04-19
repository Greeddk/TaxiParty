//
//  Router.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import Foundation

enum APIRouter {
    case authenticationRouter(AuthenticationRouter)
    case refreshTokenRouter(refreshTokenRouter)
    case postRouter(PostRouter)
    
    func convertToURLRequest() -> RouterType {
        switch self {
        case .authenticationRouter(let authenticationRouter):
            return authenticationRouter
        case .refreshTokenRouter(let refreshTokenRouter):
            return refreshTokenRouter
        case .postRouter(let postRouter):
            return postRouter
        }
    }
}

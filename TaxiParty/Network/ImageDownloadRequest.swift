//
//  ImageDownloadRequest.swift
//  TaxiParty
//
//  Created by Greed on 5/5/24.
//

import Foundation
import Kingfisher

class ImageDownloadRequest: ImageDownloadRequestModifier {
    func modified(for request: URLRequest) -> URLRequest? {
        var requestBody = request
        requestBody.setValue(TokenManager.accessToken, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        requestBody.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
        return requestBody
    }
}

//
//  Route+URLConvertible.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

import Alamofire
import Foundation

// MARK: - Make Route conform to Alamofire URLRequestConvertible so it can be executed by the SessionManager
extension Route: URLRequestConvertible {

    public func asURLRequest() throws -> URLRequest {
        // building the URL
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme.rawValue
        urlComponents.host = self.baseUrl
        urlComponents.path = self.endpoint.prefixPath + self.endpoint.path.description

        // building the request, which is a combinaison of:
        // - the URL
        // - the parameters (encoded with URLEncoding, JSONEncoding and put in the URL Query or Http Body according to parameterEncoding)
        // - the headers
        var urlRequest = try URLRequest(url: urlComponents.asURL())
        urlRequest.httpMethod = self.endpoint.httpMethod.rawValue
        switch self.endpoint.parameterEncoding {
        case .json:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: self.parameter?.dictionary)
        case .url:
            urlRequest = try URLEncoding.methodDependent.encode(urlRequest, with: self.parameter?.dictionary)
        }
        self.headers.forEach { headerKey, headerValue in
            urlRequest.addValue(headerValue, forHTTPHeaderField: headerKey)
        }
        urlRequest.timeoutInterval = TimeInterval(integerLiteral: 20)
        return urlRequest
    }
}

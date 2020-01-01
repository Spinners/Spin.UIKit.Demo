//
//  NetworkService.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

import Combine
import Foundation
import ReactiveSwift
import RxSwift

/// Errors that can be thrown by the NetworkService
enum NetworkError: LocalizedError {
    case unauthorized
    case badRequest
    case forbidden
    case emptyData
    case responseDecodingFailure(error: Error)
    case failure(error: Error)

    var errorDescription: String? {
        switch self {
        case .unauthorized: return "unauthorized"
        case .badRequest: return "badRequest"
        case .forbidden: return "forbidden"
        case .emptyData: return "emptyData"
        case .responseDecodingFailure(error: let error):
            return "responseDecodingFailure \(error.localizedDescription)"
        case .failure(error: let innerError):
            return "failure \(innerError.localizedDescription)"
        }
    }
}

protocol NetworkService {
    func fetchRx<EndpointType: Endpoint> (route: Route<EndpointType>) -> Single<EndpointType.ResponseModel>
    func fetchReactive<EndpointType: Endpoint> (route: Route<EndpointType>) -> SignalProducer<EndpointType.ResponseModel, NetworkError>
    func fetchCombine<EndpointType: Endpoint> (route: Route<EndpointType>) -> AnyPublisher<EndpointType.ResponseModel, NetworkError>
}

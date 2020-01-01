//
//  ReactiveNetworkService.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

import Combine
import Foundation
import RxSwift
import ReactiveSwift

/// The only aim of the AlamofireNetworkService is to execute requests
/// and return parsed responses
public final class ReactiveNetworkService {

    public init () {}
}

extension ReactiveNetworkService: NetworkService {

    /// Fetches a Route. A Route is associated with a Decodable Model that will be parsed and returned
    /// as a result of this function.
    ///
    /// - Parameter route: the Route to fetch
    /// - Returns: the Model parsed from the response
    func fetchRx<EndpointType: Endpoint> (route: Route<EndpointType>) -> Single<EndpointType.ResponseModel> {
        guard let request = try? route.asURLRequest() else { return .error(NetworkError.badRequest) }

        return Single<EndpointType.ResponseModel>.create { observer -> RxSwift.Disposable in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    observer(.error(NetworkError.failure(error: error)))
                    return
                }

                guard let data = data else {
                    observer(.error(NetworkError.emptyData))
                    return
                }

                do {
                    let model = try JSONDecoder().decode(EndpointType.ResponseModel.self, from: data)
                    observer(.success(model))
                } catch {
                    observer(.error(NetworkError.responseDecodingFailure(error: error)))
                }
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }

    /// Fetches a Route. A Route is associated with a Decodable Model that will be parsed and returned
    /// as a result of this function.
    ///
    /// - Parameter route: the Route to fetch
    /// - Returns: the Model parsed from the response
    func fetchReactive<EndpointType: Endpoint> (route: Route<EndpointType>) -> SignalProducer<EndpointType.ResponseModel, NetworkError> {
        guard let request = try? route.asURLRequest() else { return SignalProducer<EndpointType.ResponseModel, NetworkError>(error: .badRequest) }

        return URLSession
            .shared
            .reactive
            .data(with: request)
            .attemptMap { (dataAndResponse) -> EndpointType.ResponseModel in
                let model = try JSONDecoder().decode(EndpointType.ResponseModel.self, from: dataAndResponse.0)
                return model
        }
        .mapError { error in return NetworkError.failure(error: error) }
    }

    /// Fetches a Route. A Route is associated with a Decodable Model that will be parsed and returned
    /// as a result of this function.
    ///
    /// - Parameter route: the Route to fetch
    /// - Returns: the Model parsed from the response
    func fetchCombine<EndpointType: Endpoint> (route: Route<EndpointType>) -> AnyPublisher<EndpointType.ResponseModel, NetworkError> {

        guard let request = try? route.asURLRequest() else { return Fail<EndpointType.ResponseModel, NetworkError>(error: .badRequest).eraseToAnyPublisher() }

        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: EndpointType.ResponseModel.self, decoder: JSONDecoder())
            .mapError { error in return NetworkError.failure(error: error) }
            .eraseToAnyPublisher()
    }
}

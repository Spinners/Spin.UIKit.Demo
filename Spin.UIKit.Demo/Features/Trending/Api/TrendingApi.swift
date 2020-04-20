//
//  TrendingApi.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2019-11-23.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine
import ReactiveSwift
import RxSwift

enum Trending {
}

extension Trending {
    enum Api {

        static let pageSize = 10

        // fetch trending endpoint
        // (ReactiveSwift implementation)
        static func load(baseUrl: String,
                         apiKey: String,
                         networkService: NetworkService,
                         page: Int = 0) -> SignalProducer<TrendingResponse, NetworkError> {
            let parameter = TrendingRequest(apiKey: apiKey, limit: Trending.Api.pageSize, offset: Trending.Api.pageSize * page)

            let route = Route<TrendingEndpoint>(baseUrl: baseUrl,
                                                endpoint: TrendingEndpoint(path: GiphyPath.trending),
                                                scheme: .https)
                .set(parameter: parameter)
            return networkService.fetchReactive(route: route)
        }

        // fetch trending endpoint
        // (Combine implementation)
        static func load(baseUrl: String,
                         apiKey: String,
                         networkService: NetworkService,
                         page: Int = 0) -> AnyPublisher<TrendingResponse, NetworkError> {
            let parameter = TrendingRequest(apiKey: apiKey, limit: Trending.Api.pageSize, offset: Trending.Api.pageSize * page)

            let route = Route<TrendingEndpoint>(baseUrl: baseUrl,
                                                endpoint: TrendingEndpoint(path: GiphyPath.trending),
                                                scheme: .https)
                .set(parameter: parameter)
            return networkService.fetchCombine(route: route)
        }

        // fetch trending endpoint
        // (RxSwift implementation)
        static func load(baseUrl: String,
                         apiKey: String,
                         networkService: NetworkService,
                         page: Int = 0) -> Observable<TrendingResponse> {
            let parameter = TrendingRequest(apiKey: apiKey, limit: Trending.Api.pageSize, offset: Trending.Api.pageSize * page)

            let route = Route<TrendingEndpoint>(baseUrl: baseUrl,
                                                endpoint: TrendingEndpoint(path: GiphyPath.trending),
                                                scheme: .https)
                .set(parameter: parameter)
            return networkService.fetchRx(route: route).asObservable()
        }
    }
}

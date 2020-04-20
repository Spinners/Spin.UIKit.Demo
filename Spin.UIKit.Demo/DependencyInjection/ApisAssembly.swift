//
//  ApisAssembly.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-12-19.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine
import ReactiveSwift
import RxSwift
import Swinject

typealias TrendingReactiveApi = (Int) -> SignalProducer<TrendingResponse, NetworkError>
typealias TrendingCombineApi = (Int) -> AnyPublisher<TrendingResponse, NetworkError>
typealias TrendingRxApi = (Int) -> Observable<TrendingResponse>

typealias GifReactiveApi = (String) -> SignalProducer<GetByIdResponse, NetworkError>
typealias GifCombineApi = (String) -> AnyPublisher<GetByIdResponse, NetworkError>
typealias GifRxApi = (String) -> Observable<GetByIdResponse>

final class ApisAssembly: Assembly {

    func assemble(container: Container) {
        // (ReactiveSwift implementation)
        container.register(TrendingReactiveApi.self) { resolver in
            let baseURL = resolver.resolve(String.self, name: "baseURL")!
            let apiKey = resolver.resolve(String.self, name: "apiKey")!
            let networkService = resolver.resolve(NetworkService.self)!
            return partial(Trending.Api.load, arg1: baseURL, arg2: apiKey, arg3: networkService, arg4: .partial)
        }

        // (Combine implementation)
        container.register(TrendingCombineApi.self) { resolver in
            let baseURL = resolver.resolve(String.self, name: "baseURL")!
            let apiKey = resolver.resolve(String.self, name: "apiKey")!
            let networkService = resolver.resolve(NetworkService.self)!
            return partial(Trending.Api.load, arg1: baseURL, arg2: apiKey, arg3: networkService, arg4: .partial)
        }

        // (RxSwift implementation)
        container.register(TrendingRxApi.self) { resolver in
            let baseURL = resolver.resolve(String.self, name: "baseURL")!
            let apiKey = resolver.resolve(String.self, name: "apiKey")!
            let networkService = resolver.resolve(NetworkService.self)!
            return partial(Trending.Api.load, arg1: baseURL, arg2: apiKey, arg3: networkService, arg4: .partial)
        }

        // (ReactiveSwift implementation)
        container.register(GifReactiveApi.self) { resolver -> GifReactiveApi in
            let baseURL = resolver.resolve(String.self, name: "baseURL")!
            let apiKey = resolver.resolve(String.self, name: "apiKey")!
            let networkService = resolver.resolve(NetworkService.self)!
            return partial(Gif.Api.load, arg1: baseURL, arg2: apiKey, arg3: networkService, arg4: .partial)
        }

        // (Combine implementation)
        container.register(GifCombineApi.self) { resolver in
            let baseURL = resolver.resolve(String.self, name: "baseURL")!
            let apiKey = resolver.resolve(String.self, name: "apiKey")!
            let networkService = resolver.resolve(NetworkService.self)!
            return partial(Gif.Api.load, arg1: baseURL, arg2: apiKey, arg3: networkService, arg4: .partial)
        }

        // (RxSwift implementation)
        container.register(GifRxApi.self) { resolver in
            let baseURL = resolver.resolve(String.self, name: "baseURL")!
            let apiKey = resolver.resolve(String.self, name: "apiKey")!
            let networkService = resolver.resolve(NetworkService.self)!
            return partial(Gif.Api.load, arg1: baseURL, arg2: apiKey, arg3: networkService, arg4: .partial)
        }
    }
}

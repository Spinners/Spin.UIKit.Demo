//
//  EntityAssembly.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2019-12-20.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine
import ReactiveSwift
import RxSwift
import Swinject

typealias TrendingReactiveSwiftEntity = (Int) -> SignalProducer<([(GifOverview, Bool)], Int, Int, Int), NetworkError>
typealias TrendingCombineEntity = (Int) -> AnyPublisher<([(GifOverview, Bool)], Int, Int, Int), NetworkError>
typealias TrendingRxSwiftEntity = (Int) -> Observable<([(GifOverview, Bool)], Int, Int, Int)>

typealias GifReactiveSwiftEntity = (String) -> SignalProducer<(GifDetail, Bool), NetworkError>
typealias GifCombineEntity = (String) -> AnyPublisher<(GifDetail, Bool), NetworkError>
typealias GifRxSwiftEntity = (String) -> Observable<(GifDetail, Bool)>

final class EntityAssembly: Assembly {

    func assemble(container: Container) {
        // (ReactiveSwift implementation)
        container.register(TrendingReactiveSwiftEntity.self) { resolver in
            let trendingApiFunction = resolver.resolve(TrendingReactiveApi.self)!
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(Trending.Entity.load, arg1: trendingApiFunction, arg2: favoriteService.isFavorite(for:), arg3: .partial)
        }

        // (Combine implementation)
        container.register(TrendingCombineEntity.self) { resolver in
            let trendingApiFunction = resolver.resolve(TrendingCombineApi.self)!
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(Trending.Entity.load, arg1: trendingApiFunction, arg2: favoriteService.isFavorite(for:), arg3: .partial)
        }

        // (RxSwift implementation)
        container.register(TrendingRxSwiftEntity.self) { resolver in
            let trendingApiFunction = resolver.resolve(TrendingRxApi.self)!
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(Trending.Entity.load, arg1: trendingApiFunction, arg2: favoriteService.isFavorite(for:), arg3: .partial)
        }

        // (ReactiveSwift implementation)
        container.register(GifReactiveSwiftEntity.self) { resolver in
            let trendingApiFunction = resolver.resolve(GifReactiveApi.self)!
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(Gif.Entity.load, arg1: trendingApiFunction, arg2: favoriteService.isFavorite(for:), arg3: .partial)
        }

        // (Combine implementation)
        container.register(GifCombineEntity.self) { resolver in
            let trendingApiFunction = resolver.resolve(GifCombineApi.self)!
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(Gif.Entity.load, arg1: trendingApiFunction, arg2: favoriteService.isFavorite(for:), arg3: .partial)
        }

        // (RxSwift implementation)
        container.register(GifRxSwiftEntity.self) { resolver in
            let trendingApiFunction = resolver.resolve(GifRxApi.self)!
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(Gif.Entity.load, arg1: trendingApiFunction, arg2: favoriteService.isFavorite(for:), arg3: .partial)
        }
    }
}

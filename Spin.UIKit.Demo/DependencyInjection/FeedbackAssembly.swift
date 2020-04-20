//
//  FeedbackAssembly.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-12-20.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine
import ReactiveSwift
import RxSwift
import Swinject

typealias TrendingReactiveSwiftFeedback = (Trending.State) -> SignalProducer<Trending.Event, Never>
typealias TrendingCombineFeedback = (Trending.State) -> AnyPublisher<Trending.Event, Never>
typealias TrendingRxSwiftFeedback = (Trending.State) -> Observable<Trending.Event>

typealias LoadGifReactiveSwiftFeedback = (Gif.State) -> SignalProducer<Gif.Event, Never>
typealias LoadGifCombineFeedback = (Gif.State) -> AnyPublisher<Gif.Event, Never>
typealias LoadGifRxSwiftFeedback = (Gif.State) -> Observable<Gif.Event>

typealias SetFavoriteReactiveSwiftFeedback = (Gif.State) -> SignalProducer<Gif.Event, Never>
typealias SetFavoriteCombineFeedback = (Gif.State) -> AnyPublisher<Gif.Event, Never>
typealias SetFavoriteRxSwiftFeedback = (Gif.State) -> Observable<Gif.Event>

final class FeedbackAssembly: Assembly {

    func assemble(container: Container) {
        // Load Page Feedback for Trending
        // (ReactiveSwift implementation)
        container.register(TrendingReactiveSwiftFeedback.self) { resolver in
            let loadEntityFunction = resolver.resolve(TrendingReactiveSwiftEntity.self)!
            return partial(Trending.Feedbacks.loadPage, arg1: loadEntityFunction, arg2: .partial)
        }

        // Load Page Feedback for Trending
        // (Combine implementation)
        container.register(TrendingCombineFeedback.self) { resolver in
            let loadEntityFunction = resolver.resolve(TrendingCombineEntity.self)!
            return partial(Trending.Feedbacks.loadPage, arg1: loadEntityFunction, arg2: .partial)
        }

        // Load Page Feedback for Trending
        // (RxSwift implementation
        container.register(TrendingRxSwiftFeedback.self) { resolver in
            let loadEntityFunction = resolver.resolve(TrendingRxSwiftEntity.self)!
            return partial(Trending.Feedbacks.loadPage, arg1: loadEntityFunction, arg2: .partial)
        }

        // Load Feedback for Gif
        // (ReactiveSwift implementation)
        container.register(LoadGifReactiveSwiftFeedback.self) { resolver in
            let loadEntityFunction = resolver.resolve(GifReactiveSwiftEntity.self)!
            return partial(Gif.Feedbacks.load, arg1: loadEntityFunction, arg2: .partial)
        }

        // Load Feedback for Gif
        // (Combine implementation)
        container.register(LoadGifCombineFeedback.self) { resolver in
            let loadEntityFunction = resolver.resolve(GifCombineEntity.self)!
            return partial(Gif.Feedbacks.load, arg1: loadEntityFunction, arg2: .partial)
        }

        // Load Feedback for Gif
        // (RxSwift implementation)
        container.register(LoadGifRxSwiftFeedback.self) { resolver in
            let loadEntityFunction = resolver.resolve(GifRxSwiftEntity.self)!
            return partial(Gif.Feedbacks.load, arg1: loadEntityFunction, arg2: .partial)
        }

        // Persiste favorite Feedback
        // (ReactiveSwift implementation)
        container.register(SetFavoriteReactiveSwiftFeedback.self, name: "ReactiveSwiftPersistFeedback") { resolver in
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(Gif.Feedbacks.persist, arg1: favoriteService.set(favorite:for:), arg2: .partial)
        }

        // Persiste favorite Feedback
        // (Combine implementation)
        container.register(SetFavoriteCombineFeedback.self, name: "CombinePersistFeedback") { resolver in
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(Gif.Feedbacks.persist, arg1: favoriteService.set(favorite:for:), arg2: .partial)
        }

        // Persiste favorite Feedback
        // (RxSwift implementation)
        container.register(SetFavoriteRxSwiftFeedback.self, name: "RxSwiftPersistFeedback") { resolver in
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(Gif.Feedbacks.persist, arg1: favoriteService.set(favorite:for:), arg2: .partial)
        }
    }
}

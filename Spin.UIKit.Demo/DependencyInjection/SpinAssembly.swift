//
//  SpinAssembly.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-02-04.
//  Copyright © 2020 Spinners. All rights reserved.
//

import Dispatch
import ReactiveSwift
import RxSwift
import SpinCommon
import SpinCombine
import SpinReactiveSwift
import SpinRxSwift
import Swinject

class SpinAssembly: Assembly {
    func assemble(container: Container) {
        // Trending Spin
        // (ReactiveSwift implementation)
        container.register(ReactiveSpin<Trending.State, Trending.Event>.self) { resolver -> ReactiveSpin<Trending.State, Trending.Event> in
            let loadFeedback = resolver.resolve(TrendingReactiveSwiftFeedback.self)!
            
            // build Spin with a Builder pattern
            return
                Spinner
                    .initialState(.idle)
                    .feedback(ReactiveFeedback(effect: loadFeedback, on: QueueScheduler()))
                    .reducer(ReactiveReducer(Trending.reducer))
        }

        // Trending Spin
        // (Combine implementation)
        container.register(CombineSpin<Trending.State, Trending.Event>.self) { resolver -> CombineSpin<Trending.State, Trending.Event> in
            let loadFeedback = resolver.resolve(TrendingCombineFeedback.self)!
            
            // build Spin with a Builder pattern
            return
                Spinner
                    .initialState(.idle)
                    .feedback(CombineFeedback(effect: loadFeedback, on: DispatchQueue(label: "background").eraseToAnyScheduler()))
                    .reducer(CombineReducer(Trending.reducer))
        }

        // Trending Spin
        // (RxSwift implementation)
        container.register(RxSpin<Trending.State, Trending.Event>.self) { resolver -> RxSpin<Trending.State, Trending.Event> in
            let loadFeedback = resolver.resolve(TrendingRxSwiftFeedback.self)!

            // build Spin with a Builder pattern
            return
                Spinner
                    .initialState(.idle)
                    .feedback(RxFeedback(effect: loadFeedback, on: SerialDispatchQueueScheduler(qos: .userInitiated)))
                    .reducer(RxReducer(Trending.reducer))
        }
        
        // Gif Spin
        // (ReactiveSwift implementation)
        container.register(ReactiveSpin<Gif.State, Gif.Event>.self) { (resolver, gif: GifOverview)
            -> ReactiveSpin<Gif.State, Gif.Event> in
            let loadFavoriteFeedback = resolver.resolve(LoadGifReactiveSwiftFeedback.self)!
            let persistFavoriteFeedback = resolver.resolve(SetFavoriteReactiveSwiftFeedback.self, name: "ReactiveSwiftPersistFeedback")!

            // build Spin with a declarative "SwiftUI" pattern
            return
                ReactiveSpin(initialState: .loading(id: gif.id), reducer: ReactiveReducer(Gif.reducer)) {
                    ReactiveFeedback(effect: loadFavoriteFeedback)
                        .execute(on: QueueScheduler())
                    ReactiveFeedback(effect: persistFavoriteFeedback)
                        .execute(on: QueueScheduler())
            }
        }

        // Gif Spin
        // (Combine implementation)
        container.register(CombineSpin<Gif.State, Gif.Event>.self) { (resolver, gif: GifOverview)
            -> CombineSpin<Gif.State, Gif.Event> in
            let loadFavoriteFeedback = resolver.resolve(LoadGifCombineFeedback.self)!
            let persistFavoriteFeedback = resolver.resolve(SetFavoriteCombineFeedback.self, name: "CombinePersistFeedback")!

            // build Spin with a declarative "SwiftUI" pattern
            return
                CombineSpin(initialState: .loading(id: gif.id), reducer: CombineReducer(Gif.reducer)) {
                    CombineFeedback(effect: loadFavoriteFeedback)
                        .execute(on: DispatchQueue(label: "background").eraseToAnyScheduler())
                    CombineFeedback(effect: persistFavoriteFeedback)
                        .execute(on: DispatchQueue(label: "background").eraseToAnyScheduler())
            }
        }

        // Gif Spin
        // (RxSwift implementation)
        container.register(RxSpin<Gif.State, Gif.Event>.self) { (resolver, gif: GifOverview)
            -> RxSpin<Gif.State, Gif.Event> in
            let loadFavoriteFeedback = resolver.resolve(LoadGifRxSwiftFeedback.self)!
            let persistFavoriteFeedback = resolver.resolve(SetFavoriteRxSwiftFeedback.self, name: "RxSwiftPersistFeedback")!

            // build Spin with a declarative "SwiftUI" pattern
            return
                RxSpin(initialState: .loading(id: gif.id), reducer: RxReducer(Gif.reducer)) {
                    RxFeedback(effect: loadFavoriteFeedback)
                        .execute(on: SerialDispatchQueueScheduler(qos: .userInitiated))
                    RxFeedback(effect: persistFavoriteFeedback)
                        .execute(on: SerialDispatchQueueScheduler(qos: .userInitiated))
            }
        }
    }
}
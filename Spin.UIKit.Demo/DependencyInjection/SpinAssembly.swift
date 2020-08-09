//
//  SpinAssembly.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-02-04.
//  Copyright © 2020 Spinners. All rights reserved.
//

import Dispatch
import Foundation
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
                    .reducer(Reducer(Trending.reducer))
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
                    .reducer(Reducer(Trending.reducer))
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
                    .reducer(Reducer(Trending.reducer))
        }
        
        // Gif Spin
        // (ReactiveSwift implementation)
        container.register(ReactiveSpin<Gif.State, Gif.Event>.self) { (resolver, gif: GifOverview)
            -> ReactiveSpin<Gif.State, Gif.Event> in
            let loadGifFeedback = resolver.resolve(LoadGifReactiveSwiftFeedback.self, name: "ReactiveSwiftLoadFeedback")!
            let persistFavoriteFeedback = resolver.resolve(SetFavoriteReactiveSwiftFeedback.self, name: "ReactiveSwiftPersistFeedback")!

            // build Spin with a declarative "SwiftUI" pattern
            return
                ReactiveSpin(initialState: .loading(id: gif.id)) {
                    ReactiveFeedback(effect: loadGifFeedback)
                        .execute(on: QueueScheduler())
                    ReactiveFeedback(effect: persistFavoriteFeedback)
                        .execute(on: QueueScheduler())
                    Reducer(Gif.reducer)
            }
        }

        // Gif Spin
        // (Combine implementation)
        container.register(CombineSpin<Gif.State, Gif.Event>.self) { (resolver, gif: GifOverview)
            -> CombineSpin<Gif.State, Gif.Event> in
            let loadGifFeedback = resolver.resolve(LoadGifCombineFeedback.self, name: "CombineLoadFeedback")!
            let persistFavoriteFeedback = resolver.resolve(SetFavoriteCombineFeedback.self, name: "CombinePersistFeedback")!

            // build Spin with a declarative "SwiftUI" pattern
            return
                CombineSpin(initialState: .loading(id: gif.id)) {
                    CombineFeedback(effect: loadGifFeedback)
                        .execute(on: DispatchQueue(label: "\(UUID())", qos: .userInitiated).eraseToAnyScheduler())
                    CombineFeedback(effect: persistFavoriteFeedback)
                        .execute(on: DispatchQueue(label: "\(UUID())", qos: .userInitiated).eraseToAnyScheduler())
                    Reducer(Gif.reducer)
            }
        }

        // Gif Spin
        // (RxSwift implementation)
        container.register(RxSpin<Gif.State, Gif.Event>.self) { (resolver, gif: GifOverview)
            -> RxSpin<Gif.State, Gif.Event> in
            let loadGifFeedback = resolver.resolve(LoadGifRxSwiftFeedback.self, name: "RxSwiftLoadFeedback")!
            let persistFavoriteFeedback = resolver.resolve(SetFavoriteRxSwiftFeedback.self, name: "RxSwiftPersistFeedback")!

            // build Spin with a declarative "SwiftUI" pattern
            return
                RxSpin(initialState: .loading(id: gif.id)) {
                    RxFeedback(effect: loadGifFeedback)
                        .execute(on: SerialDispatchQueueScheduler(qos: .userInitiated))
                    RxFeedback(effect: persistFavoriteFeedback)
                        .execute(on: SerialDispatchQueueScheduler(qos: .userInitiated))
                    Reducer(Gif.reducer)
            }
        }
    }
}

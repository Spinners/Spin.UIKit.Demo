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
            let loadEntityFunction = resolver.resolve(TrendingReactiveSwiftEntity.self)!

            // build Spin with a Builder pattern
            return
                Spinner
                    .initialState(.idle)
                    .feedback(ReactiveFeedback(effect: Trending.Feedbacks.loadPage, on: QueueScheduler(), dep1: loadEntityFunction))
                    .reducer(Reducer(Trending.reducer))
        }

        // Trending Spin
        // (Combine implementation)
        container.register(CombineSpin<Trending.State, Trending.Event>.self) { resolver -> CombineSpin<Trending.State, Trending.Event> in
            let loadEntityFunction = resolver.resolve(TrendingCombineEntity.self)!

            // build Spin with a Builder pattern
            return
                Spinner
                    .initialState(.idle)
                    .feedback(CombineFeedback(effect: Trending.Feedbacks.loadPage,
                                              on: DispatchQueue(label: "background").eraseToAnyScheduler(),
                                              dep1: loadEntityFunction))
                    .reducer(Reducer(Trending.reducer))
        }

        // Trending Spin
        // (RxSwift implementation)
        container.register(RxSpin<Trending.State, Trending.Event>.self) { resolver -> RxSpin<Trending.State, Trending.Event> in
            let loadEntityFunction = resolver.resolve(TrendingRxSwiftEntity.self)!

            // build Spin with a Builder pattern
            return
                Spinner
                    .initialState(.idle)
                    .feedback(RxFeedback(effect: Trending.Feedbacks.loadPage,
                                         on: SerialDispatchQueueScheduler(qos: .userInitiated),
                                         dep1: loadEntityFunction))
                    .reducer(Reducer(Trending.reducer))
        }
        
        // Gif Spin
        // (ReactiveSwift implementation)
        container.register(ReactiveSpin<Gif.State, Gif.Event>.self) { (resolver, gif: GifOverview)
            -> ReactiveSpin<Gif.State, Gif.Event> in
            let loadEntityFunction = resolver.resolve(GifReactiveSwiftEntity.self)!
            let favoriteService = resolver.resolve(FavoriteService.self)!

            // build Spin with a declarative "SwiftUI" pattern
            return
                ReactiveSpin(initialState: .loading(id: gif.id)) {
                    ReactiveFeedback(effect: Gif.Feedbacks.load, dep1: loadEntityFunction)
                        .execute(on: QueueScheduler())
                    ReactiveFeedback(effect: Gif.Feedbacks.persist, dep1: favoriteService.set(favorite:for:))
                        .execute(on: QueueScheduler())
                    Reducer(Gif.reducer)
            }
        }

        // Gif Spin
        // (Combine implementation)
        container.register(CombineSpin<Gif.State, Gif.Event>.self) { (resolver, gif: GifOverview)
            -> CombineSpin<Gif.State, Gif.Event> in
            let loadEntityFunction = resolver.resolve(GifCombineEntity.self)!
            let favoriteService = resolver.resolve(FavoriteService.self)!

            // build Spin with a declarative "SwiftUI" pattern
            return
                CombineSpin(initialState: .loading(id: gif.id)) {
                    CombineFeedback(effect: Gif.Feedbacks.load, dep1: loadEntityFunction)
                        .execute(on: DispatchQueue(label: "\(UUID())", qos: .userInitiated).eraseToAnyScheduler())
                    CombineFeedback(effect: Gif.Feedbacks.persist, dep1: favoriteService.set(favorite:for:))
                        .execute(on: DispatchQueue(label: "\(UUID())", qos: .userInitiated).eraseToAnyScheduler())
                    Reducer(Gif.reducer)
            }
        }

        // Gif Spin
        // (RxSwift implementation)
        container.register(RxSpin<Gif.State, Gif.Event>.self) { (resolver, gif: GifOverview)
            -> RxSpin<Gif.State, Gif.Event> in
            let loadEntityFunction = resolver.resolve(GifRxSwiftEntity.self)!
            let favoriteService = resolver.resolve(FavoriteService.self)!

            // build Spin with a declarative "SwiftUI" pattern
            return
                RxSpin(initialState: .loading(id: gif.id)) {
                    RxFeedback(effect: Gif.Feedbacks.load, dep1: loadEntityFunction)
                        .execute(on: SerialDispatchQueueScheduler(qos: .userInitiated))
                    RxFeedback(effect: Gif.Feedbacks.persist, dep1: favoriteService.set(favorite:for:))
                        .execute(on: SerialDispatchQueueScheduler(qos: .userInitiated))
                    Reducer(Gif.reducer)
            }
        }
    }
}

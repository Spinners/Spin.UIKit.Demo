//
//  FeatureAssembly.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-12-19.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine
import Dispatch
import ReactiveSwift
import RxSwift
import SpinCombine
import SpinReactiveSwift
import SpinRxSwift
import Swinject

final class FeatureAssembly: Assembly {
    func assemble(container: Container) {
        // Trending Scene
        // (ReactiveSwift impolementation)
        container.register(ReactiveSwiftTrendingViewController.self) { resolver in
            let trendingSpin = resolver.resolve(ReactiveSpin<Trending.State, Trending.Event>.self)!
            let trendingUISpin = ReactiveUISpin(spin: trendingSpin)
            let viewController = ReactiveSwiftTrendingViewController.make(uiSpin: trendingUISpin)

            return viewController
        }

        // Trending Scene
        // (Combine impolementation)
        container.register(CombineTrendingViewController.self) { resolver in
            let trendingSpin = resolver.resolve(CombineSpin<Trending.State, Trending.Event>.self)!
            let trendingUISpin = CombineUISpin(spin: trendingSpin)
            let viewController = CombineTrendingViewController.make(uiSpin: trendingUISpin)

            return viewController
        }

        // Trending Scene
        // (RxSwift impolementation)
        container.register(RxSwiftTrendingViewController.self) { resolver in
            let trendingSpin = resolver.resolve(RxSpin<Trending.State, Trending.Event>.self)!
            let trendingUISpin = RxUISpin(spin: trendingSpin)
            let viewController = RxSwiftTrendingViewController.make(uiSpin: trendingUISpin)

            return viewController
        }

        // Gif Scene
        // (ReactiveSwift implementation)
        container.register(ReactiveSwiftGifViewController.self) { (resolver, gif: GifOverview) in
            let gifSpin = resolver.resolve(ReactiveSpin<Gif.State, Gif.Event>.self, argument: gif)!
            let gifSpinUISpin = ReactiveUISpin(spin: gifSpin)
            let viewController = ReactiveSwiftGifViewController.make(uiSpin: gifSpinUISpin)

            return viewController
        }

//        // Gif Scene
//        // (Combine implementation)
//        container.register(CombineGifViewController.self) { (resolver, gif: GifOverview) in
//            let gifSpin = resolver.resolve(CombineSpin<Gif.State, Gif.Event>.self, argument: gif)!
//            let gifSpinUISpin = CombineUISpin(spin: gifSpin)
//            let viewController = CombineSwiftGifViewController.make(uiSpin: gifSpinUISpin)
//
//            return viewController
//        }
//
//        // Gif Scene
//        // (RxSwift implementation)
//        container.register(CombineGifViewController.self) { (resolver, gif: GifOverview) in
//            let gifSpin = resolver.resolve(RxSpin<Gif.State, Gif.Event>.self, argument: gif)!
//            let gifSpinUISpin = RxUISpin(spin: gifSpin)
//            let viewController = RxSwiftGifViewController.make(uiSpin: gifSpinUISpin)
//
//            return viewController
//        }
    }
}

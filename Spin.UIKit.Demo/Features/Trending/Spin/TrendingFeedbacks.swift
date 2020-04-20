//
//  TrendingFeedbacks.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2019-11-17.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine
import ReactiveSwift
import RxSwift

extension Trending {
    enum Feedbacks {
        
        // Loads a page when the state is .loading
        // (ReactiveSwift implementation)
        static func loadPage(loadEntityFunction: (Int) -> SignalProducer<([(GifOverview, Bool)], Int, Int, Int), NetworkError>,
                             state: Trending.State) -> SignalProducer<Trending.Event, Never> {
            guard case let .loading(page) = state else { return .empty }

            return loadEntityFunction(page)
                .map { .succeedLoad(gif: $0.0,
                                    currentPage: page,
                                    previousPage: $0.1,
                                    nextPage: $0.2,
                                    totalPage: $0.3) }
                .flatMapError { (error) -> SignalProducer<Trending.Event, Never> in
                    return SignalProducer<Trending.Event, Never>(value: .failLoad)
            }
        }

        // Loads a page when the state is .loading
        // (Combine implementation)
        static func loadPage(loadEntityFunction: (Int) -> AnyPublisher<([(GifOverview, Bool)], Int, Int, Int), NetworkError>,
                             state: Trending.State) -> AnyPublisher<Trending.Event, Never> {
            guard case let .loading(page) = state else { return Empty().eraseToAnyPublisher() }

            return loadEntityFunction(page)
                .map { .succeedLoad(gif: $0.0,
                                    currentPage: page,
                                    previousPage: $0.1,
                                    nextPage: $0.2,
                                    totalPage: $0.3) }
                .replaceError(with: Trending.Event.failLoad)
                .eraseToAnyPublisher()
        }

        // Loads a page when the state is .loading
        // (RxSwift implementation)
        static func loadPage(loadEntityFunction: (Int) -> Observable<([(GifOverview, Bool)], Int, Int, Int)>,
                             state: Trending.State) -> Observable<Trending.Event> {
            guard case let .loading(page) = state else { return .empty() }

            return loadEntityFunction(page)
                .map { .succeedLoad(gif: $0.0,
                                    currentPage: page,
                                    previousPage: $0.1,
                                    nextPage: $0.2,
                                    totalPage: $0.3) }
                .catchErrorJustReturn(Trending.Event.failLoad)
        }
    }
}

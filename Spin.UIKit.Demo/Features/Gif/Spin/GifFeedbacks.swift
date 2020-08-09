//
//  GifFeedbacks.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine
import ReactiveSwift
import RxSwift

extension Gif {
    enum Feedbacks {

        // loads a Gif when the state is .loading
        // (ReactiveSwift implementation)
        static func load(loadEntityFunction: (String) -> SignalProducer<(GifDetail, Bool), NetworkError>,
                         state: Gif.State) -> SignalProducer<Gif.Event, Never> {
            guard case let .loading(id) = state else { return .empty }

            return loadEntityFunction(id)
                .map { .load(gif: $0.0, favorite: $0.1) }
                .flatMapError { (error) -> SignalProducer<Gif.Event, Never> in
                    return SignalProducer<Gif.Event, Never>(value: .failLoad)
            }
        }

        // loads a Gif when the state is .loading
        // (Combine implementation)
        static func load(loadEntityFunction: (String) -> AnyPublisher<(GifDetail, Bool), NetworkError>,
                         state: Gif.State) -> AnyPublisher<Gif.Event, Never> {
            guard case let .loading(id) = state else { return Empty().eraseToAnyPublisher() }

            return loadEntityFunction(id)
                .map { .load(gif: $0.0, favorite: $0.1) }
                .catch { _ in Just<Gif.Event>(.failLoad).eraseToAnyPublisher() }
                .eraseToAnyPublisher()
        }

        // loads a Gif when the state is .loading
        // (RxSwift implementation)
        static func load(loadEntityFunction: (String) -> Observable<(GifDetail, Bool)>,
                         state: Gif.State) -> Observable<Gif.Event> {
            guard case let .loading(id) = state else { return .empty() }

            return loadEntityFunction(id)
                .map { .load(gif: $0.0, favorite: $0.1) }
                .catchErrorJustReturn(Gif.Event.failLoad)
        }

        // Persist a favorite property when the state is .enablingFavorite
        // (ReactiveSwift implementation)
        static func persist(persistFavoriteFunction: (Bool, String) -> Void,
                            state: Gif.State) -> SignalProducer<Gif.Event, Never> {
            guard case let .enablingFavorite(gif, favorite) = state else { return .empty }
            
            persistFavoriteFunction(favorite, gif.url)
            return SignalProducer<Gif.Event, Never>(value: .load(gif: gif, favorite: favorite))
        }

        // Persist a favorite property when the state is .enablingFavorite
        // (Combine implementation)
        static func persist(persistFavoriteFunction: @escaping (Bool, String) -> Void,
                            state: Gif.State) -> AnyPublisher<Gif.Event, Never> {
            guard case let .enablingFavorite(gif, favorite) = state else { return Empty().eraseToAnyPublisher() }

            persistFavoriteFunction(favorite, gif.url)
            return Just<Gif.Event>(.load(gif: gif, favorite: favorite)).eraseToAnyPublisher()
        }

        // Persist a favorite property when the state is .enablingFavorite
        // (RxSwift implementation)
        static func persist(persistFavoriteFunction: (Bool, String) -> Void,
                            state: Gif.State) -> Observable<Gif.Event> {
            guard case let .enablingFavorite(gif, favorite) = state else { return .empty() }

            persistFavoriteFunction(favorite, gif.url)
            return .just(.load(gif: gif, favorite: favorite))
        }
    }
}

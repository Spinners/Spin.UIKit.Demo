//
//  GifEntity.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-04-19.
//  Copyright © 2020 Spinners. All rights reserved.
//

import Combine
import ReactiveSwift
import RxSwift

extension Gif {
    enum Entity {

        // Loads the Gif detail from Api & Favorite Service
        // Used in Gif Feedback to generate a State
        // (ReactiveSwift implementation)
        static func load(loadApisFunction: (String) -> SignalProducer<GetByIdResponse, NetworkError>,
                         isFavoriteFunction: @escaping (String) -> Bool,
                         gifId: String) -> SignalProducer<(GifDetail, Bool), NetworkError> {
            return loadApisFunction(gifId).map { getByIdResponse -> (GifDetail, Bool) in
                let isFavorite = isFavoriteFunction(getByIdResponse.data.url)
                return (getByIdResponse.data, isFavorite)
            }
        }

        // Loads the Gif detail from Api & Favorite Service
        // Used in Gif Feedback to generate a State
        // (Combine implementation)
        static func load(loadApisFunction: (String) -> AnyPublisher<GetByIdResponse, NetworkError>,
                         isFavoriteFunction: @escaping (String) -> Bool,
                         gifId: String) -> AnyPublisher<(GifDetail, Bool), NetworkError> {
            return loadApisFunction(gifId).map { getByIdResponse -> (GifDetail, Bool) in
                let isFavorite = isFavoriteFunction(getByIdResponse.data.url)
                return (getByIdResponse.data, isFavorite)
            }.eraseToAnyPublisher()
        }

        // Loads the Gif detail from Api & Favorite Service
        // Used in Gif Feedback to generate a State
        // (RxSwift implementation)
        static func load(loadApisFunction: (String) -> Observable<GetByIdResponse>,
                         isFavoriteFunction: @escaping (String) -> Bool,
                         gifId: String) -> Observable<(GifDetail, Bool)> {
            return loadApisFunction(gifId).map { getByIdResponse -> (GifDetail, Bool) in
                let isFavorite = isFavoriteFunction(getByIdResponse.data.url)
                return (getByIdResponse.data, isFavorite)
            }
        }
    }
}

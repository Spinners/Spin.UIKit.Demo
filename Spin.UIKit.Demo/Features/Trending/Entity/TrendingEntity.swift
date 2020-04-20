//
//  Planets.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import Combine
import ReactiveSwift
import RxSwift

extension Trending {
    enum Entity {

        static func pagesFrom(pagination: Pagination, pageSize: Int = Trending.Api.pageSize) -> (Int, Int, Int) {
            let factor = pagination.totalCount % pageSize
            let numberOfPages = factor == 0 ? (pagination.totalCount / pageSize) : (pagination.totalCount / pageSize) + 1
            let currentPage = (pagination.offset / pageSize)

            let previousPage = currentPage == 0 ? 0 : currentPage - 1
            let nextPage = currentPage == (numberOfPages - 1) ? currentPage : currentPage + 1

            return (previousPage, nextPage, numberOfPages)
        }

        // Loads the entities from Api & Favorite Service
        // Used in Trending Feedback to generate a State
        // (ReactiveSwift implementation)
        static func load(loadApisFunction: (Int) -> SignalProducer<TrendingResponse, NetworkError>,
                         isFavoriteFunction: @escaping (String) -> Bool,
                         page: Int) -> SignalProducer<([(GifOverview, Bool)], Int, Int, Int), NetworkError> {
            return loadApisFunction(page).map { trendingResponse -> ([(GifOverview, Bool)], Int, Int, Int) in
                let (previousPage, nextPage, numberOfPages) = Trending.Entity.pagesFrom(pagination: trendingResponse.pagination)
                let gifAndFavorite = trendingResponse.data.map { ($0, isFavoriteFunction($0.url)) }
                return (gifAndFavorite, previousPage, nextPage, numberOfPages)
            }
        }

        // Loads the entities from Api & Favorite Service
        // Used in Trending Feedback to generate a State
        // (Combine implementation)
        static func load(loadApisFunction: (Int) -> AnyPublisher<TrendingResponse, NetworkError>,
                         isFavoriteFunction: @escaping (String) -> Bool,
                         page: Int) -> AnyPublisher<([(GifOverview, Bool)], Int, Int, Int), NetworkError> {
            return loadApisFunction(page).map { trendingResponse -> ([(GifOverview, Bool)], Int, Int, Int) in
                let (previousPage, nextPage, numberOfPages) = Trending.Entity.pagesFrom(pagination: trendingResponse.pagination)
                let gifAndFavorite = trendingResponse.data.map { ($0, isFavoriteFunction($0.url)) }
                return (gifAndFavorite, previousPage, nextPage, numberOfPages)
            }.eraseToAnyPublisher()
        }

        // Loads the entities from Api & Favorite Service
        // Used in Trending Feedback to generate a State
        // (RxSwift implementation)
        static func load(loadApisFunction: (Int) -> Observable<TrendingResponse>,
                         isFavoriteFunction: @escaping (String) -> Bool,
                         page: Int) -> Observable<([(GifOverview, Bool)], Int, Int, Int)> {
            return loadApisFunction(page).map { trendingResponse -> ([(GifOverview, Bool)], Int, Int, Int) in
                let (previousPage, nextPage, numberOfPages) = Trending.Entity.pagesFrom(pagination: trendingResponse.pagination)
                let gifAndFavorite = trendingResponse.data.map { ($0, isFavoriteFunction($0.url)) }
                return (gifAndFavorite, previousPage, nextPage, numberOfPages)
            }
        }
    }
}

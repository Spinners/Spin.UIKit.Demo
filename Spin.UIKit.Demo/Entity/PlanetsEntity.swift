//
//  Planets.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import ReactiveSwift

extension Planets {
    enum Entity {

        static func load(loadApisFunction: (Int?) -> SignalProducer<ListResponse<Planet>, NetworkError>,
                         isFavoriteFunction: @escaping (String) -> Bool,
                         page: Int?) -> SignalProducer<([(Planet, Bool)], Int?, Int?), NetworkError> {
            return loadApisFunction(page).map { listResponse -> ([(Planet, Bool)], Int?, Int?) in
                let previousPage = listResponse.previous?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let nextPage = listResponse.next?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let planetsAndFavorite = listResponse.results.map { ($0, isFavoriteFunction($0.url)) }
                return (planetsAndFavorite, previousPage, nextPage)
            }
        }
    }
}

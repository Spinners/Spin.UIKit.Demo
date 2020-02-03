//
//  Starships.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import Combine

extension Starships {
    enum Entity {
        static func load(loadApisFunction: (Int?) -> AnyPublisher<ListResponse<Starship>, NetworkError>,
                         isFavoriteFunction: @escaping (String) -> Bool,
                         page: Int?) -> AnyPublisher<([(Starship, Bool)], Int?, Int?), NetworkError> {
            return loadApisFunction(page).map { listResponse -> ([(Starship, Bool)], Int?, Int?) in
                let previousPage = listResponse.previous?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let nextPage = listResponse.next?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let planetsAndFavorite = listResponse.results.map { ($0, isFavoriteFunction($0.url)) }
                return (planetsAndFavorite, previousPage, nextPage)
            }.eraseToAnyPublisher()
        }
    }
}

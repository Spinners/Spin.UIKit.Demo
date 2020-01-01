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
        
        static func search(baseUrl: String, networkService: NetworkService, query: String) -> AnyPublisher<[Starship], NetworkError> {
            let route = Route<ListEndpoint<Starship>>(baseUrl: baseUrl, endpoint: ListEndpoint<Starship>(path: StarshipsPath.starshipSearch(query: query)))
            return networkService.fetchCombine(route: route).map { $0.results }.eraseToAnyPublisher()
        }
        
        static func loadDetail(baseUrl: String, networkService: NetworkService, id: String) -> AnyPublisher<Starship, NetworkError> {
            let route = Route<EntityEndpoint<Starship>>(baseUrl: baseUrl, endpoint: EntityEndpoint<Starship>(path: StarshipsPath.starship(id: id)))
            return networkService.fetchCombine(route: route).eraseToAnyPublisher()
        }
    }
}

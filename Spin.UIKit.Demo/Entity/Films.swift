//
//  Films.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift

enum Films {
}

extension Films {
    enum Business {
        static func all(baseUrl: String, networkService: NetworkService) -> Single<([Film], Int?, Int?)> {
            let route = Route<ListEndpoint<Film>>(baseUrl: baseUrl, endpoint: ListEndpoint<Film>(path: FilmsPath.films))
            return networkService.fetchRx(route: route).map { listResponse -> ([Film], Int?, Int?) in
                let previousPage = listResponse.previous?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let nextPage = listResponse.next?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                return (listResponse.results, previousPage, nextPage)
            }
        }
        
        static func page(baseUrl: String, networkService: NetworkService, page: Int) -> Single<([Film], Int?, Int?)> {
            let route = Route<ListEndpoint<Film>>(baseUrl: baseUrl, endpoint: ListEndpoint<Film>(path: FilmsPath.films))
            route.set(parameter: ListRequest(page: page))
            return networkService.fetchRx(route: route).map { listResponse -> ([Film], Int?, Int?) in
                let previousPage = listResponse.previous?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let nextPage = listResponse.next?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                return (listResponse.results, previousPage, nextPage)
            }
        }
        
        static func search(baseUrl: String, networkService: NetworkService, query: String) -> Single<[Film]> {
            let route = Route<ListEndpoint<Film>>(baseUrl: baseUrl, endpoint: ListEndpoint<Film>(path: FilmsPath.filmSearch(query: query)))
            return networkService.fetchRx(route: route).map { $0.results }
        }
        
        static func load(baseUrl: String, networkService: NetworkService, id: String) -> Single<Film> {
            let route = Route<EntityEndpoint<Film>>(baseUrl: baseUrl, endpoint: EntityEndpoint<Film>(path: FilmsPath.film(id: id)))
            return networkService.fetchRx(route: route)
        }
    }
}

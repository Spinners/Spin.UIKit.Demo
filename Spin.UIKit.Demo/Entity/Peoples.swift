//
//  Peoples.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift

extension Peoples {
    enum Entity {

        static func load(loadApisFunction: (Int?) -> Single<ListResponse<People>>,
                         isFavoriteFunction: @escaping (String) -> Bool,
                         page: Int?) -> Single<([(People, Bool)], Int?, Int?)> {
            return loadApisFunction(page).map { listResponse -> ([(People, Bool)], Int?, Int?) in
                let previousPage = listResponse.previous?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let nextPage = listResponse.next?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let peoplesAndFavorite = listResponse.results.map { ($0, isFavoriteFunction($0.url)) }
                return (peoplesAndFavorite, previousPage, nextPage)
            }
        }
        
        static func search(baseUrl: String, networkService: NetworkService, query: String) -> Single<[People]> {
            let route = Route<ListEndpoint<People>>(baseUrl: baseUrl, endpoint: ListEndpoint<People>(path: PeoplePath.peopleSearch(query: query)))
            return networkService.fetchRx(route: route).map { $0.results }
        }
        
        static func loadDetail(baseUrl: String, networkService: NetworkService, id: String) -> Single<People> {
            let route = Route<EntityEndpoint<People>>(baseUrl: baseUrl, endpoint: EntityEndpoint<People>(path: PeoplePath.people(id: id)))
            return networkService.fetchRx(route: route)
        }
    }
}

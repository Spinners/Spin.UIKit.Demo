//
//  Species.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift

enum Species {
}

extension Species {
    static func all(baseUrl: String, networkService: NetworkService) -> Single<[Specie]> {
        let route = Route<ListEndpoint<Specie>>(baseUrl: baseUrl, endpoint: ListEndpoint<Specie>(path: SpeciesPath.species))
        return networkService.fetchRx(route: route).map { $0.results }
    }
    
    static func search(baseUrl: String, networkService: NetworkService, query: String) -> Single<[Specie]> {
        let route = Route<ListEndpoint<Specie>>(baseUrl: baseUrl, endpoint: ListEndpoint<Specie>(path: SpeciesPath.specieSearch(query: query)))
        return networkService.fetchRx(route: route).map { $0.results }
    }
    
    static func load(baseUrl: String, networkService: NetworkService, id: String) -> Single<Specie> {
        let route = Route<EntityEndpoint<Specie>>(baseUrl: baseUrl, endpoint: EntityEndpoint<Specie>(path: SpeciesPath.specie(id: id)))
        return networkService.fetchRx(route: route)
    }
}

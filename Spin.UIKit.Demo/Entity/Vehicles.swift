//
//  Vehicles.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift

enum Vehicles {
}

extension Vehicles {
    static func all(baseUrl: String, networkService: NetworkService) -> Single<[Vehicle]> {
        let route = Route<ListEndpoint<Vehicle>>(baseUrl: baseUrl, endpoint: ListEndpoint<Vehicle>(path: VehiclesPath.vehicles))
        return networkService.fetchRx(route: route).map { $0.results }
    }
    
    static func search(baseUrl: String, networkService: NetworkService, query: String) -> Single<[Vehicle]> {
        let route = Route<ListEndpoint<Vehicle>>(baseUrl: baseUrl, endpoint: ListEndpoint<Vehicle>(path: VehiclesPath.vehicleSearch(query: query)))
        return networkService.fetchRx(route: route).map { $0.results }
    }
    
    static func load(baseUrl: String, networkService: NetworkService, id: String) -> Single<Vehicle> {
        let route = Route<EntityEndpoint<Vehicle>>(baseUrl: baseUrl, endpoint: EntityEndpoint<Vehicle>(path: VehiclesPath.vehicle(id: id)))
        return networkService.fetchRx(route: route)
    }
}

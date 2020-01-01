//
//  PlanetsApi.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-23.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import ReactiveSwift

enum Planets {
}

extension Planets {
    enum Apis {
        static func load(baseUrl: String, networkService: NetworkService, page: Int?) -> SignalProducer<ListResponse<Planet>, NetworkError> {
            let route = Route<ListEndpoint<Planet>>(baseUrl: baseUrl, endpoint: ListEndpoint<Planet>(path: PlanetsPath.planets))
            if let page = page {
                route.set(parameter: ListRequest(page: page))
            }

            return networkService.fetchReactive(route: route)
        }
    }
}

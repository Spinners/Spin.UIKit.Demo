//
//  StarshipsApi.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-23.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine

enum Starships {
}

extension Starships {
    enum Apis {
        static func load(baseUrl: String, networkService: NetworkService, page: Int?) -> AnyPublisher<ListResponse<Starship>, NetworkError> {
            let route = Route<ListEndpoint<Starship>>(baseUrl: baseUrl, endpoint: ListEndpoint<Starship>(path: StarshipsPath.starships))
            if let page = page {
                route.set(parameter: ListRequest(page: page))
            }

            return networkService.fetchCombine(route: route)
        }
    }
}

//
//  GifApi.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-04-19.
//  Copyright © 2020 Spinners. All rights reserved.
//

import Combine
import ReactiveSwift
import RxSwift

enum Gif {
}

extension Gif {
    enum Api {
        
        // fetch gif endpoint
        // (ReactiveSwift implementation)
        static func load(baseUrl: String,
                         apiKey: String,
                         networkService: NetworkService,
                         id: String) -> SignalProducer<GetByIdResponse, NetworkError> {
            let parameter = GetByIdRequest(apiKey: apiKey)
            
            let route = Route<GetByIdEndpoint>(baseUrl: baseUrl,
                                               endpoint: GetByIdEndpoint(path: GiphyPath.getById(id: id)),
                                               scheme: .https)
                .set(parameter: parameter)
            return networkService.fetchReactive(route: route)
        }
        
        // fetch gif endpoint
        // (Combine implementation)
        static func load(baseUrl: String,
                         apiKey: String,
                         networkService: NetworkService,
                         id: String) -> AnyPublisher<GetByIdResponse, NetworkError> {
            let parameter = GetByIdRequest(apiKey: apiKey)
            
            let route = Route<GetByIdEndpoint>(baseUrl: baseUrl,
                                               endpoint: GetByIdEndpoint(path: GiphyPath.getById(id: id)),
                                               scheme: .https)
                .set(parameter: parameter)
            return networkService.fetchCombine(route: route)
        }
        
        // fetch gif endpoint
        // (RxSwift implementation)
        static func load(baseUrl: String,
                         apiKey: String,
                         networkService: NetworkService,
                         id: String) -> Observable<GetByIdResponse> {
            let parameter = GetByIdRequest(apiKey: apiKey)
            
            let route = Route<GetByIdEndpoint>(baseUrl: baseUrl,
                                               endpoint: GetByIdEndpoint(path: GiphyPath.getById(id: id)),
                                               scheme: .https)
                .set(parameter: parameter)
            return networkService.fetchRx(route: route).asObservable()
        }
    }
}

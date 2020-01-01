//
//  ApisAssembly.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-12-19.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine
import ReactiveSwift
import RxSwift
import Swinject

typealias PlanetsApiFunction = (Int?) -> SignalProducer<ListResponse<Planet>, NetworkError>
typealias PeoplesApiFunction = (Int?) -> Single<ListResponse<People>>
typealias StarshipsApiFunction = (Int?) -> AnyPublisher<ListResponse<Starship>, NetworkError>

final class ApisAssembly: Assembly {

    func assemble(container: Container) {
        container.register(PlanetsApiFunction.self) { resolver in
            let baseURL = resolver.resolve(String.self, name: "baseURL")!
            let networkService = resolver.resolve(NetworkService.self)!
            return curry3(function: Planets.Apis.load)(baseURL)(networkService)
        }

        container.register(PeoplesApiFunction.self) { resolver in
            let baseURL = resolver.resolve(String.self, name: "baseURL")!
            let networkService = resolver.resolve(NetworkService.self)!
            return curry3(function: Peoples.Apis.load)(baseURL)(networkService)
        }

        container.register(StarshipsApiFunction.self) { resolver in
            let baseURL = resolver.resolve(String.self, name: "baseURL")!
            let networkService = resolver.resolve(NetworkService.self)!
            return curry3(function: Starships.Apis.load)(baseURL)(networkService)
        }
    }
}

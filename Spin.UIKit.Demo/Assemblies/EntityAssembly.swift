//
//  EntityAssembly.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-12-20.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine
import ReactiveSwift
import RxSwift
import Swinject

typealias PlanetsEntityFunction = (Int?) -> SignalProducer<([(Planet, Bool)], Int?, Int?), NetworkError>
typealias PeoplesEntityFunction = (Int?) -> Single<([(People, Bool)], Int?, Int?)>
typealias StarshipsEntityFunction = (Int?) -> AnyPublisher<([(Starship, Bool)], Int?, Int?), NetworkError>

final class EntityAssembly: Assembly {

    func assemble(container: Container) {
        container.register(PlanetsEntityFunction.self) { resolver in
            let planetsApiFunction = resolver.resolve(PlanetsApiFunction.self)!
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(Planets.Entity.load, arg1: planetsApiFunction, arg2: favoriteService.isFavorite(for:), arg3: .partial)
        }

        container.register(PeoplesEntityFunction.self) { resolver in
            let peoplesApiFunction = resolver.resolve(PeoplesApiFunction.self)!
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(Peoples.Entity.load, arg1: peoplesApiFunction, arg2: favoriteService.isFavorite(for:), arg3: .partial)
        }

        container.register(StarshipsEntityFunction.self) { resolver in
            let starshipsApiFunction = resolver.resolve(StarshipsApiFunction.self)!
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(Starships.Entity.load, arg1: starshipsApiFunction, arg2: favoriteService.isFavorite(for:), arg3: .partial)
        }
    }
}

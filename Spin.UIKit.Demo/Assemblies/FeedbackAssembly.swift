//
//  FeedbackAssembly.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-12-20.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine
import ReactiveSwift
import RxSwift
import Swinject

typealias PlanetsFeedbackFunction = (PlanetsFeature.State) -> SignalProducer<PlanetsFeature.Event, Never>
typealias PeoplesFeedbackFunction = (PeoplesFeature.State) -> Observable<PeoplesFeature.Event>
typealias StarshipsFeedbackFunction = (StarshipsFeature.State) -> AnyPublisher<StarshipsFeature.Event, Never>

typealias PlanetLoadFavoriteFeedbackFunction = (PlanetFeature.State) -> SignalProducer<PlanetFeature.Event, Never>
typealias PeopleLoadFavoriteFeedbackFunction = (PeopleFeature.State) -> Observable<PeopleFeature.Event>
typealias StarshipLoadFavoriteFeedbackFunction = (StarshipFeature.State) -> AnyPublisher<StarshipFeature.Event, Never>

typealias PlanetPersistFavoriteFeedbackFunction = (PlanetFeature.State) -> SignalProducer<PlanetFeature.Event, Never>
typealias PeoplePersistFavoriteFeedbackFunction = (PeopleFeature.State) -> Observable<PeopleFeature.Event>
typealias StarshipPersistFavoriteFeedbackFunction = (StarshipFeature.State) -> AnyPublisher<StarshipFeature.Event, Never>

final class FeedbackAssembly: Assembly {

    func assemble(container: Container) {
        ////////////////////////////////////
        // LOAD PAGE FEEDBACKS
        ////////////////////////////////////
        container.register(PlanetsFeedbackFunction.self) { resolver in
            let loadEntityFunction = resolver.resolve(PlanetsEntityFunction.self)!
            return partial(PlanetsFeature.FeedbackFunctions.loadPage, arg1: loadEntityFunction, arg2: .partial)
        }

        container.register(PeoplesFeedbackFunction.self) { resolver in
            let loadEntityFunction = resolver.resolve(PeoplesEntityFunction.self)!
            return partial(PeoplesFeature.FeedbackFunctions.loadPage, arg1: loadEntityFunction, arg2: .partial)
        }

        container.register(StarshipsFeedbackFunction.self) { resolver in
            let loadEntityFunction = resolver.resolve(StarshipsEntityFunction.self)!
            return partial(StarshipsFeature.FeedbackFunctions.loadPage, arg1: loadEntityFunction, arg2: .partial)
        }

        ////////////////////////////////////
        // LOAD FAVORITE FEEDBACKS
        ////////////////////////////////////
        container.register(PlanetLoadFavoriteFeedbackFunction.self, name: "PlanetLoadFavoriteFeedbackFunction") { resolver in
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(PlanetFeature.FeedbackFunctions.load, arg1: favoriteService.isFavorite(for:), arg2: .partial)
        }

        container.register(PeopleLoadFavoriteFeedbackFunction.self, name: "PeopleLoadFavoriteFeedbackFunction") { resolver in
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(PeopleFeature.FeedbackFunctions.load, arg1: favoriteService.isFavorite(for:), arg2: .partial)
        }

        container.register(StarshipLoadFavoriteFeedbackFunction.self, name: "StarshipLoadFavoriteFeedbackFunction") { resolver in
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(StarshipFeature.FeedbackFunctions.load, arg1: favoriteService.isFavorite(for:), arg2: .partial)
        }

        ////////////////////////////////////
        // PERSIST FAVORITE FEEDBACKS
        ////////////////////////////////////
        container.register(PlanetPersistFavoriteFeedbackFunction.self, name: "PlanetPersistFavoriteFeedbackFunction") { resolver in
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(PlanetFeature.FeedbackFunctions.persist, arg1: favoriteService.set(favorite:for:), arg2: .partial)
        }

        container.register(PeoplePersistFavoriteFeedbackFunction.self, name: "PeoplePersistFavoriteFeedbackFunction") { resolver in
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(PeopleFeature.FeedbackFunctions.persist, arg1: favoriteService.set(favorite:for:), arg2: .partial)
        }

        container.register(StarshipPersistFavoriteFeedbackFunction.self, name: "StarshipPersistFavoriteFeedbackFunction") { resolver in
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return partial(StarshipFeature.FeedbackFunctions.persist, arg1: favoriteService.set(favorite:for:), arg2: .partial)
        }
    }
}

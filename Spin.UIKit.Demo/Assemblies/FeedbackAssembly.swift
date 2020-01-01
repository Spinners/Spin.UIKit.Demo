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

typealias PlanetsFeedbackFunction = (PlanetsFeature.State) -> SignalProducer<PlanetsFeature.Action, Never>
typealias PeoplesFeedbackFunction = (PeoplesFeature.State) -> Observable<PeoplesFeature.Action>
typealias StarshipsFeedbackFunction = (StarshipsFeature.State) -> AnyPublisher<StarshipsFeature.Action, Never>

typealias PlanetLoadFavoriteFeedbackFunction = (PlanetFeature.State) -> SignalProducer<PlanetFeature.Action, Never>
typealias PeopleLoadFavoriteFeedbackFunction = (PeopleFeature.State) -> Observable<PeopleFeature.Action>
typealias StarshipLoadFavoriteFeedbackFunction = (StarshipFeature.State) -> AnyPublisher<StarshipFeature.Action, Never>

typealias PlanetPersistFavoriteFeedbackFunction = (PlanetFeature.State) -> SignalProducer<PlanetFeature.Action, Never>
typealias PeoplePersistFavoriteFeedbackFunction = (PeopleFeature.State) -> Observable<PeopleFeature.Action>
typealias StarshipPersistFavoriteFeedbackFunction = (StarshipFeature.State) -> AnyPublisher<StarshipFeature.Action, Never>

final class FeedbackAssembly: Assembly {

    func assemble(container: Container) {
        ////////////////////////////////////
        // LOAD PAGE FEEDBACKS
        ///////////////////////////////////
        container.register(PlanetsFeedbackFunction.self) { resolver in
            let loadEntityFunction = resolver.resolve(PlanetsEntityFunction.self)!
            return curry2(function: PlanetsFeature.FeedbackFunctions.loadPage)(loadEntityFunction)
        }

        container.register(PeoplesFeedbackFunction.self) { resolver in
            let loadEntityFunction = resolver.resolve(PeoplesEntityFunction.self)!
            return curry2(function: PeoplesFeature.FeedbackFunctions.loadPage)(loadEntityFunction)
        }

        container.register(StarshipsFeedbackFunction.self) { resolver in
            let loadEntityFunction = resolver.resolve(StarshipsEntityFunction.self)!
            return curry2(function: StarshipsFeature.FeedbackFunctions.loadPage)(loadEntityFunction)
        }

        ////////////////////////////////////
        // LOAD FAVORITE FEEDBACKS
        ///////////////////////////////////
        container.register(PlanetLoadFavoriteFeedbackFunction.self, name: "PlanetLoadFavoriteFeedbackFunction") { resolver in
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return curry2(function: PlanetFeature.FeedbackFunctions.load)(favoriteService.isFavorite(for:))
        }

        container.register(PeopleLoadFavoriteFeedbackFunction.self, name: "PeopleLoadFavoriteFeedbackFunction") { resolver in
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return curry2(function: PeopleFeature.FeedbackFunctions.load)(favoriteService.isFavorite(for:))
        }

        container.register(StarshipLoadFavoriteFeedbackFunction.self, name: "StarshipLoadFavoriteFeedbackFunction") { resolver in
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return curry2(function: StarshipFeature.FeedbackFunctions.load)(favoriteService.isFavorite(for:))
        }

        ////////////////////////////////////
        // PERSIST FAVORITE FEEDBACKS
        ///////////////////////////////////
        container.register(PlanetPersistFavoriteFeedbackFunction.self, name: "PlanetPersistFavoriteFeedbackFunction") { resolver in
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return curry2(function: PlanetFeature.FeedbackFunctions.persistFavorite)(favoriteService.set(favorite:for:))
        }

        container.register(PeoplePersistFavoriteFeedbackFunction.self, name: "PeoplePersistFavoriteFeedbackFunction") { resolver in
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return curry2(function: PeopleFeature.FeedbackFunctions.persistFavorite)(favoriteService.set(favorite:for:))
        }

        container.register(StarshipPersistFavoriteFeedbackFunction.self, name: "StarshipPersistFavoriteFeedbackFunction") { resolver in
            let favoriteService = resolver.resolve(FavoriteService.self)!
            return curry2(function: StarshipFeature.FeedbackFunctions.persistFavorite)(favoriteService.set(favorite:for:))
        }
    }
}

//
//  FeatureAssembly.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-12-19.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine
import Dispatch
import ReactiveSwift
import RxSwift
import Spin_Swift
import Spin_Combine
import Spin_ReactiveSwift
import Spin_RxSwift
import Swinject

final class FeatureAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PlanetsViewController.self) { resolver in
            let viewContext = ReactiveViewContext<PlanetsFeature.State, PlanetsFeature.Event>(state: PlanetsFeature.State.idle)
            let viewController = PlanetsViewController.make(context: viewContext)
            let loadFeedback = resolver.resolve(PlanetsFeedbackFunction.self)!

            // build Spin with a Builder pattern
            Spinner
                .from(initialState: PlanetsFeature.State.idle)
                .add(feedback: viewContext.toFeedback())
                .add(feedback: ReactiveFeedback(effect: loadFeedback, on: QueueScheduler()))
                .reduce(with: ReactiveReducer(reducer: PlanetsFeature.reducer))
                .spin()
                .disposed(by: viewController.disposeBag)

            return viewController
        }

        container.register(PeoplesViewController.self) { resolver in
            let viewContext = RxViewContext<PeoplesFeature.State, PeoplesFeature.Event>(state: PeoplesFeature.State.idle)
            let viewController = PeoplesViewController.make(context: viewContext)
            let loadFeedback = resolver.resolve(PeoplesFeedbackFunction.self)!

            // build Spin with a Builder pattern
            Spinner
                .from(initialState: PeoplesFeature.State.idle)
                .add(feedback: viewContext.toFeedback())
                .add(feedback: RxFeedback(effect: loadFeedback, on: SerialDispatchQueueScheduler(qos: .userInitiated)))
                .reduce(with: RxReducer(reducer: PeoplesFeature.reducer))
                .spin()
                .disposed(by: viewController.disposeBag)

            return viewController
        }

        container.register(StarshipsViewController.self) { resolver in
            let viewContext = CombineViewContext<StarshipsFeature.State, StarshipsFeature.Event>(state: StarshipsFeature.State.idle)
            let viewController = StarshipsViewController.make(context: viewContext)
            let loadFeedback = resolver.resolve(StarshipsFeedbackFunction.self)!

            // build Spin with a Builder pattern
            Spinner
                .from(initialState: StarshipsFeature.State.idle)
                .add(feedback: viewContext.toFeedback())
                .add(feedback: CombineFeedback(effect: loadFeedback, on: DispatchQueue(label: "background").eraseToAnyScheduler()))
                .reduce(with: CombineReducer(reducer: StarshipsFeature.reducer))
                .spin()
                .disposed(by: &viewController.disposeBag)

            return viewController
        }

        container.register(PlanetViewController.self) { (resolver, planet: Planet) in
            let viewContext = ReactiveViewContext<PlanetFeature.State, PlanetFeature.Event>(state: .loading(planet: planet))
            let viewController = PlanetViewController.make(context: viewContext)
            let loadFavoriteFeedback = resolver.resolve(PlanetLoadFavoriteFeedbackFunction.self, name: "PlanetLoadFavoriteFeedbackFunction")!
            let persistFavoriteFeedback = resolver.resolve(PlanetPersistFavoriteFeedbackFunction.self, name: "PlanetPersistFavoriteFeedbackFunction")!

            // build Spin with a declarative "SwiftUI" pattern
            ReactiveSpin(initialState: PlanetFeature.State.loading(planet: planet),
                         reducer: ReactiveReducer(reducer: PlanetFeature.reducer)) {
                            viewContext.toFeedback()
                            ReactiveFeedback(effect: loadFavoriteFeedback).execute(on: QueueScheduler())
                            ReactiveFeedback(effect: persistFavoriteFeedback).execute(on: QueueScheduler())
            }
            .toReactiveStream()
            .spin(after: viewController.reactive.viewWillAppear.producer)
            .disposed(by: viewController.disposeBag)

            return viewController
        }

        container.register(PeopleViewController.self) { (resolver, people: People) in
            let viewContext = RxViewContext<PeopleFeature.State, PeopleFeature.Event>(state: .loading(people: people))
            let viewController = PeopleViewController.make(context: viewContext)
            let loadFavoriteFeedback = resolver.resolve(PeopleLoadFavoriteFeedbackFunction.self, name: "PeopleLoadFavoriteFeedbackFunction")!
            let persistFavoriteFeedback = resolver.resolve(PeoplePersistFavoriteFeedbackFunction.self, name: "PeoplePersistFavoriteFeedbackFunction")!

            // build Spin with a declarative "SwiftUI" pattern
            RxSpin(initialState: PeopleFeature.State.loading(people: people),
                   reducer: RxReducer(reducer: PeopleFeature.reducer)) {
                    viewContext.toFeedback()
                    RxFeedback(effect: loadFavoriteFeedback).execute(on: SerialDispatchQueueScheduler(qos: .userInitiated))
                    RxFeedback(effect: persistFavoriteFeedback).execute(on: SerialDispatchQueueScheduler(qos: .userInitiated))
            }
            .toReactiveStream()
            .spin(after: viewController.rx.viewWillAppear)
            .disposed(by: viewController.disposeBag)
            
            return viewController
        }

        container.register(StarshipViewController.self) { (resolver, starship: Starship) in
            let viewContext = CombineViewContext<StarshipFeature.State, StarshipFeature.Event>(state: .loading(starship: starship))
            let viewController = StarshipViewController.make(context: viewContext)
            let loadFavoriteFeedback = resolver.resolve(StarshipLoadFavoriteFeedbackFunction.self, name: "StarshipLoadFavoriteFeedbackFunction")!
            let persistFavoriteFeedback = resolver.resolve(StarshipPersistFavoriteFeedbackFunction.self, name: "StarshipPersistFavoriteFeedbackFunction")!

            // build Spin with a declarative "SwiftUI" pattern
            CombineSpin(initialState: StarshipFeature.State.loading(starship: starship),
                        reducer: CombineReducer(reducer: StarshipFeature.reducer)) {
                            viewContext.toFeedback()
                            CombineFeedback(effect: loadFavoriteFeedback).execute(on: DispatchQueue(label: "background").eraseToAnyScheduler())
                            CombineFeedback(effect: persistFavoriteFeedback).execute(on: DispatchQueue(label: "background").eraseToAnyScheduler())
            }
            .toReactiveStream()
            .spin(after: viewController.viewWillAppearPublisher)
            .disposed(by: &viewController.disposeBag)

            return viewController

        }
    }
}

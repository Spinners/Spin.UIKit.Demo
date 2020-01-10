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
            let viewContext = ReactiveViewContext<PlanetsFeature.State, PlanetsFeature.Action>(state: PlanetsFeature.State.idle)
            let viewController = PlanetsViewController.make(context: viewContext)
            let loadFeedback = resolver.resolve(PlanetsFeedbackFunction.self)!

            // build Spin with a Builder pattern
            Spinner
                .from(initialState: PlanetsFeature.State.idle)
                .add(feedback: viewContext.toFeedback())
                .add(feedback: ReactiveFeedback(feedback: loadFeedback, on: QueueScheduler()))
                .reduce(with: ReactiveReducer(reducer: PlanetsFeature.reducer))
                .spin()
                .disposed(by: viewController.disposeBag)

            return viewController
        }

        container.register(PeoplesViewController.self) { resolver in
            let viewContext = RxViewContext<PeoplesFeature.State, PeoplesFeature.Action>(state: PeoplesFeature.State.idle)
            let viewController = PeoplesViewController.make(context: viewContext)
            let loadFeedback = resolver.resolve(PeoplesFeedbackFunction.self)!

            // build Spin with a Builder pattern
            Spinner
                .from(initialState: PeoplesFeature.State.idle)
                .add(feedback: viewContext.toFeedback())
                .add(feedback: RxFeedback(feedback: loadFeedback, on: SerialDispatchQueueScheduler(qos: .userInitiated)))
                .reduce(with: RxReducer(reducer: PeoplesFeature.reducer))
                .spin()
                .disposed(by: viewController.disposeBag)

            return viewController
        }

        container.register(StarshipsViewController.self) { resolver in
            let viewContext = CombineViewContext<StarshipsFeature.State, StarshipsFeature.Action>(state: StarshipsFeature.State.idle)
            let viewController = StarshipsViewController.make(context: viewContext)
            let loadFeedback = resolver.resolve(StarshipsFeedbackFunction.self)!

            // build Spin with a Builder pattern
            Spinner
                .from(initialState: StarshipsFeature.State.idle)
                .add(feedback: viewContext.toFeedback())
                .add(feedback: CombineFeedback(feedback: loadFeedback, on: DispatchQueue(label: "background").eraseToAnyScheduler()))
                .reduce(with: CombineReducer(reducer: StarshipsFeature.reducer))
                .spin()
                .disposed(by: &viewController.disposeBag)

            return viewController
        }

        container.register(PlanetViewController.self) { (resolver, planet: Planet) in
            let viewContext = ReactiveViewContext<PlanetFeature.State, PlanetFeature.Action>(state: .loading(planet: planet))
            let viewController = PlanetViewController.make(context: viewContext)
            let loadFavoriteFeedback = resolver.resolve(PlanetLoadFavoriteFeedbackFunction.self, name: "PlanetLoadFavoriteFeedbackFunction")!
            let persistFavoriteFeedback = resolver.resolve(PlanetPersistFavoriteFeedbackFunction.self, name: "PlanetPersistFavoriteFeedbackFunction")!

            // build Spin with a declarative "SwiftUI" pattern
            PlanetFeature.Spin(planet: planet,
                               loadFavoriteFeedback: loadFavoriteFeedback,
                               persistFavoriteFeedback: persistFavoriteFeedback,
                               uiFeedback: viewContext.toFeedback(),
                               reducerFunction: PlanetFeature.reducer)
                .toReactiveStream()
                .spin(after: viewController.reactive.viewWillAppear.producer)
                .disposed(by: viewController.disposeBag)

            return viewController
        }

        container.register(PeopleViewController.self) { (resolver, people: People) in
            let viewContext = RxViewContext<PeopleFeature.State, PeopleFeature.Action>(state: .loading(people: people))
            let viewController = PeopleViewController.make(context: viewContext)
            let loadFavoriteFeedback = resolver.resolve(PeopleLoadFavoriteFeedbackFunction.self, name: "PeopleLoadFavoriteFeedbackFunction")!
            let persistFavoriteFeedback = resolver.resolve(PeoplePersistFavoriteFeedbackFunction.self, name: "PeoplePersistFavoriteFeedbackFunction")!

            // build Spin with a declarative "SwiftUI" pattern
            PeopleFeature.Spin(people: people,
                               loadFavoriteFeedback: loadFavoriteFeedback,
                               persistFavoriteFeedback: persistFavoriteFeedback,
                               uiFeedback: viewContext.toFeedback(),
                               reducerFunction: PeopleFeature.reducer)
                .toReactiveStream()
                .spin(after: viewController.rx.viewWillAppear)
                .disposed(by: viewController.disposeBag)
            
            return viewController
        }

        container.register(StarshipViewController.self) { (resolver, starship: Starship) in
            let viewContext = CombineViewContext<StarshipFeature.State, StarshipFeature.Action>(state: .loading(starship: starship))
            let viewController = StarshipViewController.make(context: viewContext)
            let loadFavoriteFeedback = resolver.resolve(StarshipLoadFavoriteFeedbackFunction.self, name: "StarshipLoadFavoriteFeedbackFunction")!
            let persistFavoriteFeedback = resolver.resolve(StarshipPersistFavoriteFeedbackFunction.self, name: "StarshipPersistFavoriteFeedbackFunction")!

            // build Spin with a declarative "SwiftUI" pattern
            StarshipFeature.Spin(starship: starship,
                                 loadFavoriteFeedback: loadFavoriteFeedback,
                                 persistFavoriteFeedback: persistFavoriteFeedback,
                                 uiFeedback: viewContext.toFeedback(),
                                 reducerFunction: StarshipFeature.reducer)
                .toReactiveStream()
                .spin(after: viewController.viewWillAppearPublisher)
                .disposed(by: &viewController.disposeBag)

            return viewController

        }
    }
}

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
            let viewController = PlanetsViewController.instantiate()
            let loadFeedback = resolver.resolve(PlanetsFeedbackFunction.self)!
            let renderStateFeedback = weakify(viewController) { $0.stateFeedback(state: $1) }
            let emitActionFeedback = weakify(viewController, nilValue: .empty) { $0.actionFeedback() }

            // build Spin
            Spinner
                .from(initialState: PlanetsFeature.State.idle)
                .add(feedback: ReactiveFeedback(uiFeedbacks: renderStateFeedback, emitActionFeedback, on: UIScheduler()))
                .add(feedback: ReactiveFeedback(feedback: loadFeedback, on: QueueScheduler()))
                .reduce(with: ReactiveReducer(reducer: PlanetsFeature.reducer))
                .spin()
                .disposed(by: viewController.disposeBag)

            return viewController
        }

        container.register(PeoplesViewController.self) { resolver in
            let viewController = PeoplesViewController.instantiate()
            let loadFeedback = resolver.resolve(PeoplesFeedbackFunction.self)!
            let renderStateFeedback = weakify(viewController) { $0.stateFeedback(state: $1) }
            let emitActionFeedback = weakify(viewController, nilValue: .empty()) { $0.actionFeedback() }

            // build Spin
            Spinner
                .from(initialState: PeoplesFeature.State.idle)
                .add(feedback: RxFeedback(uiFeedbacks: renderStateFeedback, emitActionFeedback, on: MainScheduler.instance))
                .add(feedback: RxFeedback(feedback: loadFeedback, on: SerialDispatchQueueScheduler(qos: .userInitiated)))
                .reduce(with: RxReducer(reducer: PeoplesFeature.reducer))
                .spin()
                .disposed(by: viewController.disposeBag)

            return viewController
        }

        container.register(StarshipsViewController.self) { resolver in
            let viewController = StarshipsViewController.instantiate()
            let loadFeedback = resolver.resolve(StarshipsFeedbackFunction.self)!
            let renderStateFeedback = weakify(viewController) { $0.stateFeedback(state: $1) }
            let emitActionFeedback = weakify(viewController, nilValue: Empty().eraseToAnyPublisher()) { $0.actionFeedback() }

            // build Spin
            Spinner
                .from(initialState: StarshipsFeature.State.idle)
                .add(feedback: CombineFeedback(uiFeedbacks: renderStateFeedback, emitActionFeedback, on: DispatchQueue.main.eraseToAnyScheduler()))
                .add(feedback: CombineFeedback(feedback: loadFeedback, on: DispatchQueue(label: "background").eraseToAnyScheduler()))
                .reduce(with: CombineReducer(reducer: StarshipsFeature.reducer))
                .spin()
                .disposed(by: &viewController.disposeBag)

            return viewController
        }

        container.register(PlanetViewController.self) { (resolver, planet: Planet) in
            let viewController = PlanetViewController.instantiate()
            let loadFavoriteFeedback = resolver.resolve(PlanetLoadFavoriteFeedbackFunction.self, name: "PlanetLoadFavoriteFeedbackFunction")!
            let persistFavoriteFeedback = resolver.resolve(PlanetPersistFavoriteFeedbackFunction.self, name: "PlanetPersistFavoriteFeedbackFunction")!
            let renderStateFeedback = weakify(viewController) { $0.stateFeedback(state: $1) }
            let emitActionFeedback = weakify(viewController, nilValue: .empty) { $0.actionFeedback() }

            // build Spin
            PlanetFeature.Spin(planet: planet,
                               loadFavoriteFeedback: loadFavoriteFeedback,
                               persistFavoriteFeedback: persistFavoriteFeedback,
                               renderStateFeedback: renderStateFeedback,
                               emitActionFeedback: emitActionFeedback,
                               reducerFunction: PlanetFeature.reducer)
                .toReactiveStream()
                .on(disposed: {
                    print("---------------------- PLANET SPIN DISPOSED")
                })
                .spin(after: viewController.reactive.viewWillAppear.producer)
                .disposed(by: viewController.disposeBag)

            return viewController
        }

        container.register(PeopleViewController.self) { (resolver, people: People) in
            let viewController = PeopleViewController.instantiate()
            let loadFavoriteFeedback = resolver.resolve(PeopleLoadFavoriteFeedbackFunction.self, name: "PeopleLoadFavoriteFeedbackFunction")!
            let persistFavoriteFeedback = resolver.resolve(PeoplePersistFavoriteFeedbackFunction.self, name: "PeoplePersistFavoriteFeedbackFunction")!
            let renderStateFeedback = weakify(viewController) { $0.stateFeedback(state: $1) }
            let emitActionFeedback = weakify(viewController, nilValue: .empty()) { $0.actionFeedback() }

            // build Spin
            PeopleFeature.Spin(people: people,
                               loadFavoriteFeedback: loadFavoriteFeedback,
                               persistFavoriteFeedback: persistFavoriteFeedback,
                               renderStateFeedback: renderStateFeedback,
                               emitActionFeedback: emitActionFeedback,
                               reducerFunction: PeopleFeature.reducer)
                .toReactiveStream()
                .spin(after: viewController.rx.viewWillAppear)
                .disposed(by: viewController.disposeBag)
            
            return viewController
        }

        container.register(StarshipViewController.self) { (resolver, starship: Starship) in
            let viewController = StarshipViewController.instantiate()
            let loadFavoriteFeedback = resolver.resolve(StarshipLoadFavoriteFeedbackFunction.self, name: "StarshipLoadFavoriteFeedbackFunction")!
            let persistFavoriteFeedback = resolver.resolve(StarshipPersistFavoriteFeedbackFunction.self, name: "StarshipPersistFavoriteFeedbackFunction")!
            let renderStateFeedback = weakify(viewController) { $0.stateFeedback(state: $1) }
            let emitActionFeedback = weakify(viewController, nilValue: Empty().eraseToAnyPublisher()) { $0.actionFeedback() }

            // build Spin
            StarshipFeature.Spin(starship: starship,
                                 loadFavoriteFeedback: loadFavoriteFeedback,
                                 persistFavoriteFeedback: persistFavoriteFeedback,
                                 renderStateFeedback: renderStateFeedback,
                                 emitActionFeedback: emitActionFeedback,
                                 reducerFunction: StarshipFeature.reducer)
                .toReactiveStream()
                .spin(after: viewController.viewWillAppearSubject.eraseToAnyPublisher())
                .disposed(by: &viewController.disposeBag)

            return viewController

        }
    }
}

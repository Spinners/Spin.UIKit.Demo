//
//  SpinAssembly.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-02-04.
//  Copyright © 2020 Spinners. All rights reserved.
//

import Dispatch
import ReactiveSwift
import RxSwift
import Spin_Swift
import Spin_Combine
import Spin_ReactiveSwift
import Spin_RxSwift
import Swinject

class SpinAssembly: Assembly {
    func assemble(container: Container) {
        ////////////////////////////////////
        // PLANETS LIST SPIN
        ////////////////////////////////////
        container.register(ReactiveSpin<PlanetsFeature.State, PlanetsFeature.Event>.self) { resolver
            -> ReactiveSpin<PlanetsFeature.State, PlanetsFeature.Event> in
            let loadFeedback = resolver.resolve(PlanetsFeedbackFunction.self)!
            
            // build Spin with a Builder pattern
            return
                Spinner
                    .initialState(.idle)
                    .feedback(ReactiveFeedback(effect: loadFeedback, on: QueueScheduler()))
                    .reducer(ReactiveReducer(PlanetsFeature.reducer))
        }
        
        ////////////////////////////////////
        // PEOPLES LIST SPIN
        ////////////////////////////////////
        container.register(RxSpin<PeoplesFeature.State, PeoplesFeature.Event>.self) { resolver
            -> RxSpin<PeoplesFeature.State, PeoplesFeature.Event> in
            let loadFeedback = resolver.resolve(PeoplesFeedbackFunction.self)!
            
            // build Spin with a Builder pattern
            return
                Spinner
                    .initialState(.idle)
                    .feedback(RxFeedback(effect: loadFeedback, on: SerialDispatchQueueScheduler(qos: .userInitiated)))
                    .reducer(RxReducer(PeoplesFeature.reducer))
        }
        
        ////////////////////////////////////
        // STARSHIPS LIST SPIN
        ////////////////////////////////////
        container.register(CombineSpin<StarshipsFeature.State, StarshipsFeature.Event>.self) { resolver
            -> CombineSpin<StarshipsFeature.State, StarshipsFeature.Event> in
            let loadFeedback = resolver.resolve(StarshipsFeedbackFunction.self)!
            
            // build Spin with a Builder pattern
            return
                Spinner
                    .initialState(.idle)
                    .feedback(CombineFeedback(effect: loadFeedback, on: DispatchQueue(label: "background").eraseToAnyScheduler()))
                    .reducer(CombineReducer(StarshipsFeature.reducer))
        }
        
        ////////////////////////////////////
        // PLANET DETAIL SPIN
        ////////////////////////////////////
        container.register(ReactiveSpin<PlanetFeature.State, PlanetFeature.Event>.self) { (resolver, planet: Planet)
            -> ReactiveSpin<PlanetFeature.State, PlanetFeature.Event> in
            let loadFavoriteFeedback = resolver.resolve(PlanetLoadFavoriteFeedbackFunction.self, name: "PlanetLoadFavoriteFeedbackFunction")!
            let persistFavoriteFeedback = resolver.resolve(PlanetPersistFavoriteFeedbackFunction.self, name: "PlanetPersistFavoriteFeedbackFunction")!
            
            // build Spin with a declarative "SwiftUI" pattern
            return
                ReactiveSpin(initialState: .loading(planet: planet), reducer: ReactiveReducer(PlanetFeature.reducer)) {
                    ReactiveFeedback(effect: loadFavoriteFeedback)
                        .execute(on: QueueScheduler())
                    ReactiveFeedback(effect: persistFavoriteFeedback)
                        .execute(on: QueueScheduler())
            }
        }
        
        ////////////////////////////////////
        // PEOPLE DETAIL SPIN
        ////////////////////////////////////
        container.register(RxSpin<PeopleFeature.State, PeopleFeature.Event>.self) { (resolver, people: People)
            -> RxSpin<PeopleFeature.State, PeopleFeature.Event> in
            let loadFavoriteFeedback = resolver.resolve(PeopleLoadFavoriteFeedbackFunction.self, name: "PeopleLoadFavoriteFeedbackFunction")!
            let persistFavoriteFeedback = resolver.resolve(PeoplePersistFavoriteFeedbackFunction.self, name: "PeoplePersistFavoriteFeedbackFunction")!
            
            // build Spin with a declarative "SwiftUI" pattern
            return
                RxSpin(initialState: .loading(people: people), reducer: RxReducer(PeopleFeature.reducer)) {
                    RxFeedback(effect: loadFavoriteFeedback)
                        .execute(on: SerialDispatchQueueScheduler(qos: .userInitiated))
                    RxFeedback(effect: persistFavoriteFeedback)
                        .execute(on: SerialDispatchQueueScheduler(qos: .userInitiated))
            }
        }
        
        ////////////////////////////////////
        // STARSHIP DETAIL SPIN
        ////////////////////////////////////
        container.register(CombineSpin<StarshipFeature.State, StarshipFeature.Event>.self) { (resolver, starship: Starship)
            -> CombineSpin<StarshipFeature.State, StarshipFeature.Event> in
            let loadFavoriteFeedback = resolver.resolve(StarshipLoadFavoriteFeedbackFunction.self, name: "StarshipLoadFavoriteFeedbackFunction")!
            let persistFavoriteFeedback = resolver.resolve(StarshipPersistFavoriteFeedbackFunction.self, name: "StarshipPersistFavoriteFeedbackFunction")!
            
            // build Spin with a declarative "SwiftUI" pattern
            return
                CombineSpin(initialState: .loading(starship: starship), reducer: CombineReducer(StarshipFeature.reducer)) {
                    CombineFeedback(effect: loadFavoriteFeedback)
                        .execute(on: DispatchQueue(label: "background").eraseToAnyScheduler())
                    CombineFeedback(effect: persistFavoriteFeedback)
                        .execute(on: DispatchQueue(label: "background").eraseToAnyScheduler())
            }
        }
    }
}

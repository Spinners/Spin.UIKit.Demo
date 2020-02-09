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
        ////////////////////////////////////
        // PLANETS LIST SCENE
        ////////////////////////////////////
        container.register(PlanetsViewController.self) { resolver in
            let planetsSpin = resolver.resolve(ReactiveSpin<PlanetsFeature.State, PlanetsFeature.Event>.self)!
            let planetsUISpin = ReactiveUISpin(spin: planetsSpin)
            let viewController = PlanetsViewController.make(uiSpin: planetsUISpin)

            return viewController
        }

        ////////////////////////////////////
        // PEOPLES LIST SCENE
        ////////////////////////////////////
        container.register(PeoplesViewController.self) { resolver in
            let peoplesSpin = resolver.resolve(RxSpin<PeoplesFeature.State, PeoplesFeature.Event>.self)!
            let peoplesUISpin = RxUISpin(spin: peoplesSpin)
            let viewController = PeoplesViewController.make(uiSpin: peoplesUISpin)

            return viewController
        }

        ////////////////////////////////////
        // STARSHIPS LIST SCENE
        ////////////////////////////////////
        container.register(StarshipsViewController.self) { resolver in
            let starshipsSpin = resolver.resolve(CombineSpin<StarshipsFeature.State, StarshipsFeature.Event>.self)!
            let starshipsUISpin = CombineUISpin(spin: starshipsSpin)
            let viewController = StarshipsViewController.make(uiSpin: starshipsUISpin)

            return viewController
        }

        ////////////////////////////////////
        // PLANET DETAIL SCENE
        ////////////////////////////////////
        container.register(PlanetViewController.self) { (resolver, planet: Planet) in
            let planetSpin = resolver.resolve(ReactiveSpin<PlanetFeature.State, PlanetFeature.Event>.self, argument: planet)!
            let planetUISpin = ReactiveUISpin(spin: planetSpin)
            let viewController = PlanetViewController.make(uiSpin: planetUISpin)

            return viewController
        }

        ////////////////////////////////////
        // PEOPLE DETAIL SCENE
        ////////////////////////////////////
        container.register(PeopleViewController.self) { (resolver, people: People) in
            let peopleSpin = resolver.resolve(RxSpin<PeopleFeature.State, PeopleFeature.Event>.self, argument: people)!
            let peopleUISpin = RxUISpin(spin: peopleSpin)
            let viewController = PeopleViewController.make(uiSpin: peopleUISpin)

            return viewController
        }

        ////////////////////////////////////
        // STARSHIP DETAIL SCENE
        ////////////////////////////////////
        container.register(StarshipViewController.self) { (resolver, starship: Starship) in
            let starshipSpin = resolver.resolve(CombineSpin<StarshipFeature.State, StarshipFeature.Event>.self, argument: starship)!
            let starshipUISpin = CombineUISpin(spin: starshipSpin)
            let viewController = StarshipViewController.make(uiSpin: starshipUISpin)

            return viewController
        }
    }
}

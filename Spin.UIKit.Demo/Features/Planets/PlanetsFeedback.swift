//
//  PlanetsFeedback.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-17.
//  Copyright © 2019 WarpFactor. All rights reserved.
//
import ReactiveSwift

enum PlanetsFeature {
}

extension PlanetsFeature {
    enum FeedbackFunctions {
        
        /////////////////////////////////////////////
        // Loads a page when the state is .loading
        /////////////////////////////////////////////
        static func loadPage(loadEntityFunction: (Int?) -> SignalProducer<([(Planet, Bool)], Int?, Int?), NetworkError>,
                             state: PlanetsFeature.State) -> SignalProducer<PlanetsFeature.Action, Never> {
            guard case let .loading(page) = state else { return .empty }

            return loadEntityFunction(page)
                .map { .succeedLoad(planets: $0.0, previousPage: $0.1, nextPage: $0.2) }
                .flatMapError { (error) -> SignalProducer<PlanetsFeature.Action, Never> in
                    return SignalProducer<PlanetsFeature.Action, Never>(value: .failLoad)
            }
        }
    }
}

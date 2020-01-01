//
//  PlanetSpin.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-12-25.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import ReactiveSwift
import Spin_ReactiveSwift
import Spin_Swift

extension PlanetFeature {
    struct Spin: Spin_Swift.SpinDefinition {

        let planet: Planet
        let loadFavoriteFeedback: (PlanetFeature.State) -> SignalProducer<PlanetFeature.Action, Never>
        let persistFavoriteFeedback: (PlanetFeature.State) -> SignalProducer<PlanetFeature.Action, Never>
        let renderStateFeedback: (PlanetFeature.State) -> Void
        let emitActionFeedback: () -> SignalProducer<PlanetFeature.Action, Never>
        let reducerFunction: (PlanetFeature.State, PlanetFeature.Action) -> PlanetFeature.State

        var spin: ReactiveSpin<PlanetFeature.State> {
            ReactiveSpin(initialState: PlanetFeature.State.loading(planet: planet),
                         reducer: ReactiveReducer(reducer: reducerFunction)) {
                ReactiveFeedback(feedback: loadFavoriteFeedback).execute(on: QueueScheduler())
                ReactiveFeedback(feedback: persistFavoriteFeedback).execute(on: QueueScheduler())
                ReactiveFeedback(uiFeedbacks: renderStateFeedback, emitActionFeedback).execute(on: UIScheduler())
            }
        }
    }
}

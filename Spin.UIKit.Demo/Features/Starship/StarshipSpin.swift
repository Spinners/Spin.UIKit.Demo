//
//  StarshipSpin.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-12-25.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine
import Dispatch
import Spin_Combine
import Spin_Swift

extension StarshipFeature {
    struct Spin: Spin_Swift.SpinDefinition {

        let starship: Starship
        let loadFavoriteFeedback: (StarshipFeature.State) -> AnyPublisher<StarshipFeature.Action, Never>
        let persistFavoriteFeedback: (StarshipFeature.State) -> AnyPublisher<StarshipFeature.Action, Never>
        let renderStateFeedback: (StarshipFeature.State) -> Void
        let emitActionFeedback: () -> AnyPublisher<StarshipFeature.Action, Never>
        let reducerFunction: (StarshipFeature.State, StarshipFeature.Action) -> StarshipFeature.State

        var spin: CombineSpin<StarshipFeature.State> {
            CombineSpin(initialState: StarshipFeature.State.loading(starship: starship),
                        reducer: CombineReducer(reducer: reducerFunction)) {
                            CombineFeedback(feedback: loadFavoriteFeedback).execute(on: DispatchQueue(label: "background").eraseToAnyScheduler())
                            CombineFeedback(feedback: persistFavoriteFeedback).execute(on: DispatchQueue(label: "background").eraseToAnyScheduler())
                            CombineFeedback(uiFeedbacks: renderStateFeedback, emitActionFeedback).execute(on: DispatchQueue.main.eraseToAnyScheduler())
            }
        }
    }
}

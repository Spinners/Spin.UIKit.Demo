//
//  PeopleSpin.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-12-25.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import RxSwift
import Spin_RxSwift
import Spin_Swift

extension PeopleFeature {
    struct Spin: Spin_Swift.SpinDefinition {

        let people: People
        let loadFavoriteFeedback: (PeopleFeature.State) -> Observable<PeopleFeature.Action>
        let persistFavoriteFeedback: (PeopleFeature.State) -> Observable<PeopleFeature.Action>
        let renderStateFeedback: (PeopleFeature.State) -> Void
        let emitActionFeedback: () -> Observable<PeopleFeature.Action>
        let reducerFunction: (PeopleFeature.State, PeopleFeature.Action) -> PeopleFeature.State

        var spin: RxSpin<PeopleFeature.State> {
            RxSpin(initialState: PeopleFeature.State.loading(people: people),
                   reducer: RxReducer(reducer: reducerFunction)) {
                    RxFeedback(feedback: loadFavoriteFeedback).execute(on: SerialDispatchQueueScheduler(qos: .userInitiated))
                    RxFeedback(feedback: persistFavoriteFeedback).execute(on: SerialDispatchQueueScheduler(qos: .userInitiated))
                    RxFeedback(uiFeedbacks: renderStateFeedback, emitActionFeedback).execute(on: MainScheduler.instance)
            }
        }
    }
}
